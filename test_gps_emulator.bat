@echo off
echo Testing GPS endpoint...

curl -X POST "http://localhost:5192/api/tracking/gps" ^
-H "Content-Type: application/json" ^
-d "{\"deviceId\":\"TEST_DEVICE_001\",\"latitude\":-34.6118,\"longitude\":-58.3960,\"timestamp\":\"%date:~10,4%-%date:~4,2%-%date:~7,2%T%time:~0,2%:%time:~3,2%:%time:~6,2%Z\",\"speed\":5.2,\"temperature\":22,\"batteryLevel\":85,\"signalStrength\":-65,\"activityLevel\":75}"

echo.
echo.
echo Testing tracker detection...
curl -X GET "http://localhost:5192/api/TrackerManagement/detect-new-public" ^
-H "Accept: application/json"

echo.
pause