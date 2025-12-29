-- Create the specific license the user was trying to activate
INSERT INTO "Licenses" ("CustomerId", "LicenseKey", "LicenseType", "MaxTrackers", "MaxFarms", "MaxUsers", "Status", "IssuedAt", "ExpiresAt", "CreatedAt", "UpdatedAt")
SELECT c."Id", 'TG-2024-1111-2222-3333-4444', 'Premium', 50, 5, 10, 'Active', NOW(), NOW() + INTERVAL '1 year', NOW(), NOW()
FROM "Customers" c
WHERE c."CompanyName" = 'Test Company'
  AND NOT EXISTS (SELECT 1 FROM "Licenses" WHERE "LicenseKey" = 'TG-2024-1111-2222-3333-4444');

-- Verify the license was created
SELECT l."LicenseKey", c."CompanyName", l."LicenseType", l."MaxTrackers", l."Status"
FROM "Licenses" l
JOIN "Customers" c ON l."CustomerId" = c."Id"
WHERE l."LicenseKey" = 'TG-2024-1111-2222-3333-4444';