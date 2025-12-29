$env:PGPASSWORD = "123456"
$sqlFile = "C:\Cursos\Net\TrackerGanaderoMixto\create_tables_and_license.sql"

# Try different possible PostgreSQL paths
$psqlPaths = @(
    "C:\Program Files\PostgreSQL\16\bin\psql.exe",
    "C:\Program Files\PostgreSQL\15\bin\psql.exe",
    "C:\Program Files\PostgreSQL\14\bin\psql.exe",
    "C:\Program Files\PostgreSQL\13\bin\psql.exe",
    "psql"
)

$psqlPath = $null
foreach ($path in $psqlPaths) {
    if (Test-Path $path -ErrorAction SilentlyContinue) {
        $psqlPath = $path
        break
    }
    if ((Get-Command $path -ErrorAction SilentlyContinue)) {
        $psqlPath = $path
        break
    }
}

if ($psqlPath) {
    Write-Host "Using psql at: $psqlPath"
    & $psqlPath -h localhost -U postgres -d TrackerGanadero -f $sqlFile
} else {
    Write-Host "PostgreSQL psql.exe not found. Please install PostgreSQL or add it to PATH."
}