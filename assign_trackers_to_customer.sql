-- Script para asignar trackers existentes a un customer
-- Esto solucionará el problema de "No hay trackers disponibles para asignar"

-- 1. Crear un customer por defecto si no existe
INSERT INTO "Customers" ("Name", "Email", "Phone", "CreatedAt")
SELECT 'Customer Default', 'default@tracker.com', '000-000-0000', NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM "Customers" WHERE "Email" = 'default@tracker.com'
);

-- 2. Obtener el ID del customer
WITH CustomerInfo AS (
    SELECT "Id" as customer_id FROM "Customers" WHERE "Email" = 'default@tracker.com'
)
-- 3. Asignar todos los trackers al customer que no tengan asignación
INSERT INTO "CustomerTrackers" ("CustomerId", "TrackerId", "AssignedAt", "Status", "IsActive")
SELECT
    c.customer_id,
    t."Id",
    NOW(),
    'Active',
    true
FROM "Trackers" t
CROSS JOIN CustomerInfo c
WHERE t."Id" NOT IN (
    SELECT "TrackerId" FROM "CustomerTrackers" WHERE "TrackerId" IS NOT NULL
)
AND t."IsAvailableForAssignment" = true;

-- 4. Verificar los resultados
SELECT
    ct."Id" as CustomerTrackerId,
    ct."CustomerId",
    c."Name" as CustomerName,
    ct."TrackerId",
    t."DeviceId",
    t."Name" as TrackerName,
    ct."Status",
    ct."AssignedAt"
FROM "CustomerTrackers" ct
JOIN "Customers" c ON ct."CustomerId" = c."Id"
JOIN "Trackers" t ON ct."TrackerId" = t."Id"
WHERE c."Email" = 'default@tracker.com'
ORDER BY ct."AssignedAt" DESC
LIMIT 10;