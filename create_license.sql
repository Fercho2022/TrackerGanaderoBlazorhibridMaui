-- First insert a customer (if not exists)
INSERT INTO "Customers" ("UserId", "CompanyName", "ContactEmail", "ContactPhone", "Address", "Status", "CreatedAt", "UpdatedAt")
SELECT 1, 'Test Company', 'test@company.com', '123-456-7890', 'Test Address 123', 'Active', NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM "Customers" WHERE "CompanyName" = 'Test Company');

-- Get the customer ID
-- Insert license (if not exists)
INSERT INTO "Licenses" ("CustomerId", "LicenseKey", "LicenseType", "MaxTrackers", "MaxFarms", "MaxUsers", "Status", "IssuedAt", "ExpiresAt", "CreatedAt", "UpdatedAt")
SELECT c."Id", 'TG-2024-1234-5678-9ABC', 'Premium', 50, 5, 10, 'Active', NOW(), NOW() + INTERVAL '1 year', NOW(), NOW()
FROM "Customers" c
WHERE c."CompanyName" = 'Test Company'
  AND NOT EXISTS (SELECT 1 FROM "Licenses" WHERE "LicenseKey" = 'TG-2024-1234-5678-9ABC');

-- Verify the license was created
SELECT l."LicenseKey", c."CompanyName", l."LicenseType", l."MaxTrackers", l."Status"
FROM "Licenses" l
JOIN "Customers" c ON l."CustomerId" = c."Id"
WHERE l."LicenseKey" = 'TG-2024-1234-5678-9ABC';