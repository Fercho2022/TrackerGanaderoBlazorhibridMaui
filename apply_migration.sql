-- Migración manual: Agregar CustomerTrackerId a tabla Animals

-- Verificar si la columna ya existe
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_name = 'Animals'
        AND column_name = 'CustomerTrackerId'
    ) THEN
        -- Agregar la columna
        ALTER TABLE "Animals" ADD COLUMN "CustomerTrackerId" integer;
        RAISE NOTICE 'Columna CustomerTrackerId agregada exitosamente';
    ELSE
        RAISE NOTICE 'Columna CustomerTrackerId ya existe';
    END IF;
END $$;

-- Agregar foreign key constraint si no existe
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.table_constraints
        WHERE constraint_name = 'FK_Animals_CustomerTrackers_CustomerTrackerId'
    ) THEN
        ALTER TABLE "Animals"
        ADD CONSTRAINT "FK_Animals_CustomerTrackers_CustomerTrackerId"
        FOREIGN KEY ("CustomerTrackerId")
        REFERENCES "CustomerTrackers" ("Id")
        ON DELETE SET NULL;
        RAISE NOTICE 'Foreign key constraint agregado exitosamente';
    ELSE
        RAISE NOTICE 'Foreign key constraint ya existe';
    END IF;
END $$;

-- Crear índice si no existe
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_indexes
        WHERE indexname = 'IX_Animals_CustomerTrackerId'
    ) THEN
        CREATE INDEX "IX_Animals_CustomerTrackerId"
        ON "Animals" ("CustomerTrackerId");
        RAISE NOTICE 'Índice creado exitosamente';
    ELSE
        RAISE NOTICE 'Índice ya existe';
    END IF;
END $$;

-- Verificar el resultado
SELECT
    column_name,
    data_type,
    is_nullable,
    'CustomerTrackerId column added successfully' as status
FROM information_schema.columns
WHERE table_name = 'Animals'
AND column_name = 'CustomerTrackerId';

-- Si no se muestra ninguna fila arriba, la columna no se creó
SELECT CASE
    WHEN EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'Animals' AND column_name = 'CustomerTrackerId'
    )
    THEN '✅ MIGRACIÓN EXITOSA: CustomerTrackerId creado correctamente'
    ELSE '❌ ERROR: CustomerTrackerId NO se creó'
END as resultado_final;