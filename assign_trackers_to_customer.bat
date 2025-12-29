@echo off
echo Asignando trackers existentes al customer...

echo.
echo Obteniendo lista de trackers registrados...
curl -s "http://localhost:5192/api/TrackerManagement/detect-new-public" > temp_trackers.json

echo.
echo Procesando asignaciones...
echo Tracker ID 40 (TEST_SIMPLE_001)...
curl -X POST "http://localhost:5192/api/DebugTracker/assign-to-customer" -H "Content-Type: application/json" -d "{\"TrackerId\":40}"

echo.
echo Tracker ID 41 (COW_GPS_NEW_TEST_01)...
curl -X POST "http://localhost:5192/api/DebugTracker/assign-to-customer" -H "Content-Type: application/json" -d "{\"TrackerId\":41}"

echo.
echo Algunos trackers principales del sistema...
curl -X POST "http://localhost:5192/api/DebugTracker/assign-to-customer" -H "Content-Type: application/json" -d "{\"TrackerId\":4}"
curl -X POST "http://localhost:5192/api/DebugTracker/assign-to-customer" -H "Content-Type: application/json" -d "{\"TrackerId\":6}"
curl -X POST "http://localhost:5192/api/DebugTracker/assign-to-customer" -H "Content-Type: application/json" -d "{\"TrackerId\":7}"
curl -X POST "http://localhost:5192/api/DebugTracker/assign-to-customer" -H "Content-Type: application/json" -d "{\"TrackerId\":8}"
curl -X POST "http://localhost:5192/api/DebugTracker/assign-to-customer" -H "Content-Type: application/json" -d "{\"TrackerId\":9}"

echo.
echo ¡Terminado! Los trackers han sido asignados al customer.
echo Ahora deberían aparecer en "Gestión de Granjas" como disponibles para asignar.
echo.
pause