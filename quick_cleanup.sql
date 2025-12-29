-- Limpieza rápida - mantener solo COW_GPS_ER_02
DELETE FROM "CustomerTrackers";
DELETE FROM "Trackers" WHERE "DeviceId" != 'COW_GPS_ER_02';

-- Verificar resultado
SELECT "DeviceId", "Name", "IsActive" FROM "Trackers";