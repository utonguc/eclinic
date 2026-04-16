#!/bin/bash
set -e

echo "[1] WRITE PROCESSOR INSIDE CONTAINER (SAFE PIPE VERSION)"

sudo docker exec -i signature_gateway sh -c "cat > /processor.py" <<'PY'
#!/usr/bin/env python3
import sys
import select
import requests

API_URL = "http://api:5000/v1/signature/render"

# NON-BLOCKING STDIN READ (CRITICAL FOR POSTFIX PIPE)
data = ""
try:
    r, _, _ = select.select([sys.stdin], [], [], 1)
    if r:
        data = sys.stdin.read()
except Exception:
    data = ""

if not data:
    sys.stdout.write("\n")
    sys.stdout.flush()
    sys.exit(0)

try:
    r = requests.post(
        API_URL,
        json={
            "message_id": "smtp",
            "from_email": "u.tonguc@megasarayhotels.com",
            "to": ["test@test.com"],
            "html": data
        },
        timeout=3
    )

    if r.ok:
        out = (r.json().get("final_output") or data)
    else:
        out = data

except Exception:
    out = data

sys.stdout.write(out + "\n")
sys.stdout.flush()
sys.exit(0)
PY

sudo docker exec -i signature_gateway chmod +x /processor.py

echo "[2] OVERWRITE POSTFIX CONFIGS"

sudo docker exec -i signature_gateway sh -c "cat > /etc/postfix/main.cf" <<'MCF'
myhostname = signature.local
inet_interfaces = all
inet_protocols = ipv4

mynetworks = 0.0.0.0/0

content_filter = signature-filter:
default_process_limit = 100
smtp_connect_timeout = 5s
smtpd_delay_reject = no
disable_vrfy_command = yes
MCF

sudo docker exec -i signature_gateway sh -c "cat > /etc/postfix/master.cf" <<'MCF'
smtp      inet  n       -       n       -       -       smtpd -v

signature-filter unix  -       n       n       -       -       pipe
  flags=Rq user=root argv=/usr/bin/python3 /processor.py
MCF

echo "[3] FIX PERMISSIONS (POSTFIX WARNING KILLER)"

sudo docker exec -i signature_gateway sh -c "
chmod 644 /etc/postfix/main.cf || true
chmod 644 /etc/postfix/master.cf || true
"

echo "[4] RESTART POSTFIX CLEAN"

sudo docker exec -i signature_gateway sh -c "postfix stop || true && postfix start"

echo "[5] VERIFY"

sudo docker exec -i signature_gateway sh -c "postconf -n | grep content_filter"

echo "[6] DONE - TEST NOW WITH SWAKS"
