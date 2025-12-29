-- Limpieza de trackers antiguos - solo mantener COW_GPS_ER_02
-- Este script mantiene únicamente el tracker que acabas de registrar

BEGIN;

-- Mostrar los trackers actuales antes de la limpieza
SELECT 'ANTES DE LA LIMPIEZA:' as status;
SELECT "DeviceId", "Name", "IsActive", "Status", "LastSeen"
FROM "Trackers"
ORDER BY "DeviceId";

-- Eliminar todos los trackers excepto COW_GPS_ER_02
DELETE FROM "CustomerTrackers" WHERE "TrackerId" IN (
    SELECT "Id" FROM "Trackers" WHERE "DeviceId" != 'COW_GPS_ER_02'
);

DELETE FROM "Trackers" WHERE "DeviceId" != 'COW_GPS_ER_02';

-- Mostrar los trackers restantes después de la limpieza
SELECT 'DESPUÉS DE LA LIMPIEZA:' as status;
SELECT "DeviceId", "Name", "IsActive", "Status", "LastSeen"
FROM "Trackers"
ORDER BY "DeviceId";

-- Verificar el conteo final
SELECT COUNT(*) as "TrackerCountAfterCleanup" FROM "Trackers";

COMMIT;