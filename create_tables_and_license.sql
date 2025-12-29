-- Create Customers table
CREATE TABLE IF NOT EXISTS "Customers" (
    "Id" SERIAL PRIMARY KEY,
    "UserId" INTEGER NOT NULL,
    "CompanyName" VARCHAR(200) NOT NULL,
    "TaxId" VARCHAR(50),
    "ContactPerson" VARCHAR(100),
    "Phone" VARCHAR(20),
    "Address" VARCHAR(500),
    "City" VARCHAR(100),
    "Country" VARCHAR(100),
    "Plan" VARCHAR(50) NOT NULL DEFAULT 'Basic',
    "TrackerLimit" INTEGER NOT NULL DEFAULT 10,
    "FarmLimit" INTEGER NOT NULL DEFAULT 1,
    "Status" VARCHAR(20) NOT NULL DEFAULT 'Active',
    "SubscriptionStart" TIMESTAMP NOT NULL DEFAULT NOW(),
    "SubscriptionEnd" TIMESTAMP,
    "CreatedAt" TIMESTAMP NOT NULL DEFAULT NOW(),
    "UpdatedAt" TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Create Licenses table
CREATE TABLE IF NOT EXISTS "Licenses" (
    "Id" SERIAL PRIMARY KEY,
    "CustomerId" INTEGER NOT NULL REFERENCES "Customers"("Id") ON DELETE CASCADE,
    "LicenseKey" VARCHAR(50) NOT NULL UNIQUE,
    "LicenseType" VARCHAR(50) NOT NULL DEFAULT 'Basic',
    "MaxTrackers" INTEGER NOT NULL DEFAULT 10,
    "MaxFarms" INTEGER NOT NULL DEFAULT 1,
    "MaxUsers" INTEGER NOT NULL DEFAULT 1,
    "Features" VARCHAR(1000),
    "Status" VARCHAR(20) NOT NULL DEFAULT 'Active',
    "IssuedAt" TIMESTAMP NOT NULL DEFAULT NOW(),
    "ActivatedAt" TIMESTAMP,
    "ExpiresAt" TIMESTAMP NOT NULL DEFAULT NOW() + INTERVAL '1 year',
    "ActivationIp" VARCHAR(50),
    "HardwareId" VARCHAR(100),
    "Notes" VARCHAR(500),
    "CreatedAt" TIMESTAMP NOT NULL DEFAULT NOW(),
    "UpdatedAt" TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Create CustomerTrackers table
CREATE TABLE IF NOT EXISTS "CustomerTrackers" (
    "Id" SERIAL PRIMARY KEY,
    "CustomerId" INTEGER NOT NULL REFERENCES "Customers"("Id") ON DELETE CASCADE,
    "TrackerId" INTEGER NOT NULL,
    "FarmId" INTEGER,
    "AnimalName" VARCHAR(100),
    "Status" VARCHAR(20) NOT NULL DEFAULT 'Active',
    "AssignedAt" TIMESTAMP NOT NULL DEFAULT NOW(),
    "UnassignedAt" TIMESTAMP,
    "CreatedAt" TIMESTAMP NOT NULL DEFAULT NOW(),
    "UpdatedAt" TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE("CustomerId", "TrackerId")
);

-- Insert test customer (if not exists)
INSERT INTO "Customers" ("UserId", "CompanyName", "ContactPerson", "Phone", "Address", "Status", "Plan", "TrackerLimit")
SELECT 1, 'Test Company', 'Test Contact Person', '123-456-7890', 'Test Address 123', 'Active', 'Premium', 50
WHERE NOT EXISTS (SELECT 1 FROM "Customers" WHERE "CompanyName" = 'Test Company');

-- Insert test license (if not exists)
INSERT INTO "Licenses" ("CustomerId", "LicenseKey", "LicenseType", "MaxTrackers", "MaxFarms", "MaxUsers", "Status", "IssuedAt", "ExpiresAt")
SELECT c."Id", 'TG-2024-1234-5678-9ABC', 'Premium', 50, 5, 10, 'Active', NOW(), NOW() + INTERVAL '1 year'
FROM "Customers" c
WHERE c."CompanyName" = 'Test Company'
  AND NOT EXISTS (SELECT 1 FROM "Licenses" WHERE "LicenseKey" = 'TG-2024-1234-5678-9ABC');

-- Verify the data was created
SELECT
    l."LicenseKey",
    c."CompanyName",
    l."LicenseType",
    l."MaxTrackers",
    l."Status",
    l."CanBeActivated" = (l."Status" = 'Active' AND l."ExpiresAt" > NOW() AND l."ActivatedAt" IS NULL)
FROM "Licenses" l
JOIN "Customers" c ON l."CustomerId" = c."Id"
WHERE l."LicenseKey" = 'TG-2024-1234-5678-9ABC';