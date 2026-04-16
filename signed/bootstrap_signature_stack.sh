#!/bin/bash
set -e

PROJECT="signature-platform"

echo "[1] CLEAN OLD STACK"
docker compose down -v || true

echo "[2] CREATE FOLDERS"
mkdir -p api gateway

# -----------------------------
# API (FASTAPI)
# -----------------------------
cat > api/main.py <<'EOF'
from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI(title="Signature Core")

class Req(BaseModel):
    message_id: str | None = None
    from_email: str | None = None
    to: list[str] = []
    html: str

@app.post("/v1/signature/render")
def render(req: Req):
    # SIMULATION: signature processing layer
    processed = f"<div class='signed'>{req.html}</div>"
    return {
        "status": "OK",
        "final_output": processed
    }
EOF

cat > api/requirements.txt <<'EOF'
fastapi
uvicorn
EOF

cat > api/Dockerfile <<'EOF'
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "5000"]
EOF

# -----------------------------
# GATEWAY (POSTFIX + PIPE)
# -----------------------------
cat > gateway/processor.py <<'EOF'
#!/usr/bin/env python3
import sys
import requests

API = "http://api:5000/v1/signature/render"

data = sys.stdin.read().strip()

if not data:
    sys.stdout.write("\n")
    sys.exit(0)

try:
    r = requests.post(API, json={
        "message_id": "smtp",
        "from_email": "gateway@local",
        "to": ["x@x.com"],
        "html": data
    }, timeout=3)

    out = r.json().get("final_output", data)

except Exception:
    out = data

sys.stdout.write(out + "\n")
sys.stdout.flush()
EOF

cat > gateway/master.cf <<'EOF'
smtp      inet  n       -       n       -       -       smtpd

signature-filter unix  -       n       n       -       -       pipe
  flags=Rq user=root argv=/usr/bin/python3 /processor.py
EOF

cat > gateway/main.cf <<'EOF'
myhostname = signature.local
inet_interfaces = all
inet_protocols = ipv4

mynetworks = 0.0.0.0/0

content_filter = signature-filter:
EOF

cat > gateway/Dockerfile <<'EOF'
FROM boky/postfix

RUN apt-get update && apt-get install -y python3 python3-pip curl && \
    pip3 install requests --break-system-packages

COPY master.cf /etc/postfix/master.cf
COPY main.cf /etc/postfix/main.cf
COPY processor.py /processor.py
RUN chmod +x /processor.py

CMD ["sh", "-c", "postfix start-fg"]
EOF

# -----------------------------
# DOCKER COMPOSE
# -----------------------------
cat > docker-compose.yml <<'EOF'
services:
  db:
    image: postgres:15
    environment:
      POSTGRES_DB: signature
      POSTGRES_USER: signature_user
      POSTGRES_PASSWORD: signature_pass
    ports:
      - "5433:5432"

  api:
    build: ./api
    ports:
      - "5000:5000"

  gateway:
    build: ./gateway
    depends_on:
      - api
    ports:
      - "2525:25"
EOF

# -----------------------------
# BUILD + RUN
# -----------------------------
echo "[3] BUILD & START"
docker compose up -d --build

echo "[4] WAIT API"
sleep 5

echo "[5] TEST API"
curl -s http://localhost:5000/openapi.json | head

echo "[6] SMTP TEST (swaks)"
echo "Test HTML" | swaks --server localhost:2525 --from a@a.com --to b@b.com --body "PIPE TEST"

echo "[DONE]"
