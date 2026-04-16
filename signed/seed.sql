-- ============================================================
-- Seed: Megasaray Hotels (demo tenant)
-- ============================================================

INSERT INTO tenants (id, name, slug)
VALUES ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'Megasaray Hotels', 'megasaray');

INSERT INTO domains (tenant_id, domain, verified)
VALUES ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'megasarayhotels.com', TRUE);

INSERT INTO users (tenant_id, email, display_name, job_title, mobile_phone, department)
VALUES
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',
     'u.tonguc@megasarayhotels.com',
     'Umut Tonguc', 'IT Manager', '+90 555 000 00 00', 'Information Technology'),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',
     'satis@megasarayhotels.com',
     'Satis Ekibi', 'Sales Executive', '+90 555 111 11 11', 'Sales');

-- Standard template (default for all)
INSERT INTO templates (id, tenant_id, name, html_content, is_default)
VALUES (
    'b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a22',
    'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',
    'Standart Imza',
    '<br/><table cellpadding="0" cellspacing="0" style="font-family:Arial,sans-serif;font-size:13px;color:#333;border-top:2px solid #0066cc;padding-top:8px;margin-top:4px;">
<tr><td style="padding:2px 0;"><b>{{ display_name }}</b></td></tr>
<tr><td style="padding:2px 0;color:#555;">{{ job_title }}{% if department %} &bull; {{ department }}{% endif %}</td></tr>
<tr><td style="padding:2px 0;color:#777;">{{ mobile_phone }}</td></tr>
<tr><td style="padding:4px 0;"><a href="https://www.megasarayhotels.com" style="color:#0066cc;text-decoration:none;">www.megasarayhotels.com</a></td></tr>
</table>',
    TRUE
);

-- Sales-specific template
INSERT INTO templates (id, tenant_id, name, html_content, is_default)
VALUES (
    'c2eebc99-9c0b-4ef8-bb6d-6bb9bd380a33',
    'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',
    'Satis Imzasi',
    '<br/><table cellpadding="0" cellspacing="0" style="font-family:Arial,sans-serif;font-size:13px;color:#333;border-top:2px solid #e67e00;padding-top:8px;margin-top:4px;">
<tr><td style="padding:2px 0;"><b>{{ display_name }}</b></td></tr>
<tr><td style="padding:2px 0;color:#555;">{{ job_title }} &bull; Satis Ekibi</td></tr>
<tr><td style="padding:2px 0;color:#777;">{{ mobile_phone }}</td></tr>
<tr><td style="padding:4px 0;"><a href="https://www.megasarayhotels.com/ozel-teklif" style="color:#e67e00;text-decoration:none;">Ozel Teklif Alin &rarr;</a></td></tr>
</table>',
    FALSE
);

-- Rules: Sales department gets the sales template (priority 10 beats catch-all 100)
INSERT INTO rules (tenant_id, priority, condition_type, condition_value, template_id, enabled)
VALUES
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 10,  'department', 'Sales',
     'c2eebc99-9c0b-4ef8-bb6d-6bb9bd380a33', TRUE),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 100, NULL, NULL,
     'b1eebc99-9c0b-4ef8-bb6d-6bb9bd380a22', TRUE);

-- Gateway system API key (raw value: 'dev-gateway-key-change-in-prod')
INSERT INTO api_keys (tenant_id, key_hash, name)
VALUES (NULL,
        encode(digest('dev-gateway-key-change-in-prod', 'sha256'), 'hex'),
        'Gateway System Key');
