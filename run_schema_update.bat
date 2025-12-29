@echo off
echo Updating database schema to add CustomerTracker relationship...

"C:\Program Files\PostgreSQL\17\bin\psql.exe" -h localhost -p 5432 -U postgres -d CattleTrackingDB -c "ALTER TABLE \"Animals\" ADD COLUMN \"CustomerTrackerId\" integer;"

if %ERRORLEVEL% EQU 0 (
    echo Column added successfully
    "C:\Program Files\PostgreSQL\17\bin\psql.exe" -h localhost -p 5432 -U postgres -d CattleTrackingDB -c "ALTER TABLE \"Animals\" ADD CONSTRAINT \"FK_Animals_CustomerTrackers_CustomerTrackerId\" FOREIGN KEY (\"CustomerTrackerId\") REFERENCES \"CustomerTrackers\" (\"Id\") ON DELETE SET NULL;"

    if %ERRORLEVEL% EQU 0 (
        echo Foreign key constraint added successfully
        "C:\Program Files\PostgreSQL\17\bin\psql.exe" -h localhost -p 5432 -U postgres -d CattleTrackingDB -c "CREATE INDEX \"IX_Animals_CustomerTrackerId\" ON \"Animals\" (\"CustomerTrackerId\");"

        if %ERRORLEVEL% EQU 0 (
            echo Index created successfully
            echo Schema update completed!
        ) else (
            echo Error creating index
        )
    ) else (
        echo Error adding foreign key constraint
    )
) else (
    echo Error adding column
)

pause