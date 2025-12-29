-- Insert a default farm if none exists
INSERT INTO "Farms" ("Name", "Location", "UserId", "CreatedAt", "UpdatedAt")
SELECT 'Granja Central', 'Ubicación Central', 1, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM "Farms" WHERE "Name" = 'Granja Central');

-- Verify farms exist
SELECT "Id", "Name", "Location", "CreatedAt" FROM "Farms" ORDER BY "Id";