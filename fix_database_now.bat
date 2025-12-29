@echo off
echo ===== APLICANDO MIGRACION CUSTOMERTRACKER =====
echo.

echo 1. Verificando si la columna ya existe...
"C:\Program Files\PostgreSQL\17\bin\psql.exe" -h localhost -p 5432 -U postgres -d CattleTrackingDB -c "SELECT column_name FROM information_schema.columns WHERE table_name = 'Animals' AND column_name = 'CustomerTrackerId';" > temp_check.txt 2>&1

findstr /C:"CustomerTrackerId" temp_check.txt >nul
if %ERRORLEVEL% EQU 0 (
    echo [OK] La columna CustomerTrackerId ya existe
    goto VERIFY
) else (
    echo [INFO] La columna CustomerTrackerId no existe, creandola...
)

echo.
echo 2. Agregando columna CustomerTrackerId a tabla Animals...
"C:\Program Files\PostgreSQL\17\bin\psql.exe" -h localhost -p 5432 -U postgres -d CattleTrackingDB -c "ALTER TABLE \"Animals\" ADD COLUMN \"CustomerTrackerId\" integer;"

if %ERRORLEVEL% EQU 0 (
    echo [OK] Columna agregada exitosamente
) else (
    echo [ERROR] Fallo agregando columna
    goto ERROR
)

echo.
echo 3. Agregando constraint de foreign key...
"C:\Program Files\PostgreSQL\17\bin\psql.exe" -h localhost -p 5432 -U postgres -d CattleTrackingDB -c "ALTER TABLE \"Animals\" ADD CONSTRAINT \"FK_Animals_CustomerTrackers_CustomerTrackerId\" FOREIGN KEY (\"CustomerTrackerId\") REFERENCES \"CustomerTrackers\" (\"Id\") ON DELETE SET NULL;"

if %ERRORLEVEL% EQU 0 (
    echo [OK] Foreign key constraint agregado exitosamente
) else (
    echo [WARNING] Fallo agregando foreign key constraint (puede ya existir)
)

echo.
echo 4. Agregando indice para performance...
"C:\Program Files\PostgreSQL\17\bin\psql.exe" -h localhost -p 5432 -U postgres -d CattleTrackingDB -c "CREATE INDEX \"IX_Animals_CustomerTrackerId\" ON \"Animals\" (\"CustomerTrackerId\");"

if %ERRORLEVEL% EQU 0 (
    echo [OK] Indice agregado exitosamente
) else (
    echo [WARNING] Fallo agregando indice (puede ya existir)
)

:VERIFY
echo.
echo 5. Verificando estructura final de la tabla Animals...
"C:\Program Files\PostgreSQL\17\bin\psql.exe" -h localhost -p 5432 -U postgres -d CattleTrackingDB -c "SELECT column_name, data_type, is_nullable FROM information_schema.columns WHERE table_name = 'Animals' ORDER BY ordinal_position;"

echo.
echo ===== MIGRACION COMPLETADA =====
echo Ahora puedes reiniciar el API Web
goto END

:ERROR
echo.
echo [ERROR] La migracion fallo. Verifica que PostgreSQL este corriendo.
echo.

:END
if exist temp_check.txt del temp_check.txt
echo.
echo Presiona cualquier tecla para continuar...
pause >nul