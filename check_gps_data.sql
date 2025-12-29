-- Verificar que los datos GPS se están guardando correctamente
-- en la tabla LocationHistories con los DeviceId

-- 1. Contar registros totales
SELECT COUNT(*) as "Total_GPS_Records"
FROM "LocationHistories";

-- 2. Ver últimos 10 registros por DeviceId
SELECT
    "DeviceId",
    "Latitude",
    "Longitude",
    "Timestamp",
    "AnimalId",
    "TrackerId"
FROM "LocationHistories"
WHERE "DeviceId" IS NOT NULL
ORDER BY "Timestamp" DESC
LIMIT 10;

-- 3. Ver DeviceIds únicos detectados
SELECT
    "DeviceId",
    COUNT(*) as "Record_Count",
    MIN("Timestamp") as "First_Seen",
    MAX("Timestamp") as "Last_Seen"
FROM "LocationHistories"
WHERE "DeviceId" IS NOT NULL
GROUP BY "DeviceId"
ORDER BY "Last_Seen" DESC;

-- 4. Verificar si hay datos en los últimos 5 minutos
SELECT
    "DeviceId",
    "Latitude",
    "Longitude",
    "Timestamp"
FROM "LocationHistories"
WHERE "DeviceId" IS NOT NULL
  AND "Timestamp" > NOW() - INTERVAL '5 minutes'
ORDER BY "Timestamp" DESC;