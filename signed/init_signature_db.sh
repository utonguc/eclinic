#!/bin/bash

DB_HOST="localhost"
DB_PORT="5433"
DB_NAME="signature"
DB_USER="signature_user"
DB_PASS="signature_pass"

export PGPASSWORD=$DB_PASS

echo "Connecting to DB..."

psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME <<EOF

CREATE TABLE IF NOT EXISTS tenants (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    domain TEXT UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    tenant_id INT,
    email TEXT UNIQUE NOT NULL,
    full_name TEXT,
    title TEXT,
    phone TEXT
);

CREATE TABLE IF NOT EXISTS templates (
    id SERIAL PRIMARY KEY,
    tenant_id INT,
    name TEXT,
    html TEXT,
    is_default BOOLEAN DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS rules (
    id SERIAL PRIMARY KEY,
    tenant_id INT,
    priority INT DEFAULT 100,
    match_field TEXT,
    match_value TEXT,
    template_id INT
);

-- CLEAN DATA
DELETE FROM rules;
DELETE FROM templates;
DELETE FROM users;
DELETE FROM tenants;

-- SEED
INSERT INTO tenants (name, domain)
VALUES ('mega', 'megasarayhotels.com');

INSERT INTO users (tenant_id, email, full_name, title, phone)
VALUES (
    1,
    'u.tonguc@megasarayhotels.com',
    'Demo User',
    'IT Manager',
    '+90 000 000 00 00'
);

INSERT INTO templates (tenant_id, name, html, is_default)
VALUES (
    1,
    'default',
    '<br/><div><b>{{name}}</b><br/>{{title}}<br/>{{phone}}</div><!-- SIGNATURE-ID -->',
    true
);

INSERT INTO rules (tenant_id, priority, match_field, match_value, template_id)
VALUES (
    1,
    1,
    'email',
    'u.tonguc@megasarayhotels.com',
    1
);

EOF

echo "DONE ✔"
