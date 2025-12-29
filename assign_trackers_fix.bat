@echo off
echo ==================================================
echo LIMPIANDO BASE DE DATOS - TRACKERS ANTIGUOS
echo ==================================================

echo.
echo ADVERTENCIA: Esto eliminara todos los trackers excepto COW_GPS_ER_02
echo Presione Ctrl+C para cancelar o cualquier tecla para continuar...
pause

echo.
echo 1. Eliminando CustomerTrackers...
"C:\Program Files\PostgreSQL\17\bin\psql.exe" -h localhost -p 5432 -U postgres -d CattleTrackingDB -c "DELETE FROM \"CustomerTrackers\";"

echo.
echo 2. Desasignando trackers de animales...
"C:\Program Files\PostgreSQL\17\bin\psql.exe" -h localhost -p 5432 -U postgres -d CattleTrackingDB -c "UPDATE \"Animals\" SET \"TrackerId\" = NULL, \"CustomerTrackerId\" = NULL;"

echo.
echo 3. Eliminando trackers antiguos (excepto COW_GPS_ER_02)...
"C:\Program Files\PostgreSQL\17\bin\psql.exe" -h localhost -p 5432 -U postgres -d CattleTrackingDB -c "DELETE FROM \"Trackers\" WHERE \"DeviceId\" != 'COW_GPS_ER_02';"

echo.
echo 4. Verificando resultado final...
"C:\Program Files\PostgreSQL\17\bin\psql.exe" -h localhost -p 5432 -U postgres -d CattleTrackingDB -c "SELECT COUNT(*) as total_trackers FROM \"Trackers\";"
"C:\Program Files\PostgreSQL\17\bin\psql.exe" -h localhost -p 5432 -U postgres -d CattleTrackingDB -c "SELECT \"DeviceId\", \"Name\", \"IsActive\" FROM \"Trackers\";"

echo.
echo ==================================================
echo ¡COMPLETADO! Base de datos limpiada.
echo Solo deberia quedar COW_GPS_ER_02 si fue registrado.
echo ==================================================
pause