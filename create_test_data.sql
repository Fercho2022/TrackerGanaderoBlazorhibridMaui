-- Crear datos de prueba para desarrollo
-- Asegurar que existe usuario y customer para testing

-- 1. Insertar usuario de prueba si no existe
INSERT INTO "Users" ("Id", "Name", "Email", "PasswordHash", "Role", "IsActive", "CreatedAt")
SELECT 1, 'Usuario de Prueba', 'test@example.com', 'test_hash', 'User', true, NOW()
WHERE NOT EXISTS (SELECT 1 FROM "Users" WHERE "Id" = 1);

-- 2. Insertar customer de prueba si no existe
INSERT INTO "Customers" ("Id", "UserId", "CompanyName", "TaxId", "ContactPerson", "Phone", "Address", "City", "Country", "Plan", "TrackerLimit", "FarmLimit", "Status", "SubscriptionStart", "CreatedAt", "UpdatedAt")
SELECT 1, 1, 'Granja de Prueba S.A.', '12345678901', 'Juan Pérez', '+54-11-1234-5678', 'Av. Rural 123', 'Buenos Aires', 'Argentina', 'Premium', 50, 10, 'Active', NOW(), NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM "Customers" WHERE "UserId" = 1);

-- 3. Insertar licencia de prueba si no existe
INSERT INTO "Licenses" ("Id", "CustomerId", "LicenseKey", "LicenseType", "Status", "IssuedAt", "ExpiresAt", "MaxTrackers", "MaxFarms", "Features", "CreatedAt")
SELECT 1, 1, 'TEST-LICENSE-2025-DEVELOPMENT', 'Premium', 'Active', NOW(), NOW() + INTERVAL '1 year', 50, 10, '{"tracking": true, "geofencing": true, "alerts": true, "reports": true}', NOW()
WHERE NOT EXISTS (SELECT 1 FROM "Licenses" WHERE "CustomerId" = 1);

-- 4. Insertar granja de prueba si no existe
INSERT INTO "Farms" ("Id", "Name", "Address", "Latitude", "Longitude", "UserId", "CreatedAt")
SELECT 1, 'Granja Norte', 'Campo Norte, Buenos Aires', -34.6118, -58.3960, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM "Farms" WHERE "UserId" = 1);

-- 5. Insertar algunos animales de prueba si no existen
INSERT INTO "Animals" ("Id", "Name", "Tag", "BirthDate", "Gender", "Breed", "Weight", "Status", "FarmId", "CreatedAt", "UpdatedAt")
SELECT 1, 'Vaca Número 1', 'COW001', '2022-01-15', 'Hembra', 'Holstein', 450.00, 'Active', 1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM "Animals" WHERE "Id" = 1);

INSERT INTO "Animals" ("Id", "Name", "Tag", "BirthDate", "Gender", "Breed", "Weight", "Status", "FarmId", "CreatedAt", "UpdatedAt")
SELECT 2, 'Vaca Número 2', 'COW002', '2022-02-20', 'Hembra', 'Holstein', 420.00, 'Active', 1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM "Animals" WHERE "Id" = 2);

INSERT INTO "Animals" ("Id", "Name", "Tag", "BirthDate", "Gender", "Breed", "Weight", "Status", "FarmId", "CreatedAt", "UpdatedAt")
SELECT 3, 'Toro Número 1', 'BULL001', '2021-05-10', 'Macho', 'Holstein', 680.00, 'Active', 1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM "Animals" WHERE "Id" = 3);

-- Verificar que se crearon los datos
SELECT 'Users' as tabla, COUNT(*) as registros FROM "Users" WHERE "Id" = 1
UNION ALL
SELECT 'Customers', COUNT(*) FROM "Customers" WHERE "UserId" = 1
UNION ALL
SELECT 'Licenses', COUNT(*) FROM "Licenses" WHERE "CustomerId" = 1
UNION ALL
SELECT 'Farms', COUNT(*) FROM "Farms" WHERE "UserId" = 1
UNION ALL
SELECT 'Animals', COUNT(*) FROM "Animals" WHERE "FarmId" = 1;

-- Mostrar información de customer para verificar
SELECT
    c."CompanyName",
    c."Plan",
    c."TrackerLimit",
    c."Status",
    COUNT(ct."Id") as "TrackersAsignados"
FROM "Customers" c
LEFT JOIN "CustomerTrackers" ct ON c."Id" = ct."CustomerId" AND ct."Status" = 'Active'
WHERE c."UserId" = 1
GROUP BY c."Id", c."CompanyName", c."Plan", c."TrackerLimit", c."Status";