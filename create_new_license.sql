-- Crear nueva licencia de prueba
INSERT INTO "Licenses" ("CustomerId", "LicenseKey", "LicenseType", "MaxTrackers", "MaxFarms", "MaxUsers", "Status", "IssuedAt", "ExpiresAt")
SELECT c."Id", 'TG-2025-TEST-ABCD-1234', 'Premium', 50, 5, 10, 'Active', NOW(), NOW() + INTERVAL '1 year'
FROM "Customers" c
WHERE c."CompanyName" = 'Test Company'
  AND NOT EXISTS (SELECT 1 FROM "Licenses" WHERE "LicenseKey" = 'TG-2025-TEST-ABCD-1234');