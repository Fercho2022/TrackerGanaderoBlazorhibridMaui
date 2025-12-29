-- ===== MIGRACIÓN MANUAL: AGREGAR CUSTOMERTRACKER =====
-- Ejecutar este SQL en Visual Studio o pgAdmin

BEGIN;

-- 1. Verificar tabla Animals existe
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'Animals') THEN
        RAISE EXCEPTION 'Tabla Animals no existe!';
    END IF;
    RAISE NOTICE '✓ Tabla Animals encontrada';
END $$;

-- 2. Verificar tabla CustomerTrackers existe
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'CustomerTrackers') THEN
        RAISE EXCEPTION 'Tabla CustomerTrackers no existe!';
    END IF;
    RAISE NOTICE '✓ Tabla CustomerTrackers encontrada';
END $$;

-- 3. Agregar columna CustomerTrackerId si no existe
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'Animals' AND column_name = 'CustomerTrackerId'
    ) THEN
        ALTER TABLE "Animals" ADD COLUMN "CustomerTrackerId" integer;
        RAISE NOTICE '✓ Columna CustomerTrackerId agregada a tabla Animals';
    ELSE
        RAISE NOTICE '! Columna CustomerTrackerId ya existe';
    END IF;
END $$;

-- 4. Agregar foreign key constraint
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints
        WHERE constraint_name = 'FK_Animals_CustomerTrackers_CustomerTrackerId'
    ) THEN
        ALTER TABLE "Animals"
        ADD CONSTRAINT "FK_Animals_CustomerTrackers_CustomerTrackerId"
        FOREIGN KEY ("CustomerTrackerId")
        REFERENCES "CustomerTrackers" ("Id")
        ON DELETE SET NULL;
        RAISE NOTICE '✓ Foreign key constraint agregado';
    ELSE
        RAISE NOTICE '! Foreign key constraint ya existe';
    END IF;
EXCEPTION
    WHEN others THEN
        RAISE NOTICE '! Warning: No se pudo agregar foreign key constraint: %', SQLERRM;
END $$;

-- 5. Crear índice para performance
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_indexes
        WHERE indexname = 'IX_Animals_CustomerTrackerId'
    ) THEN
        CREATE INDEX "IX_Animals_CustomerTrackerId" ON "Animals" ("CustomerTrackerId");
        RAISE NOTICE '✓ Índice IX_Animals_CustomerTrackerId creado';
    ELSE
        RAISE NOTICE '! Índice IX_Animals_CustomerTrackerId ya existe';
    END IF;
END $$;

COMMIT;

-- 6. VERIFICACIÓN FINAL
SELECT
    '🎉 MIGRACIÓN COMPLETADA' as status,
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_name = 'Animals' AND column_name = 'CustomerTrackerId';

-- Si no aparece ninguna fila arriba, la migración falló
SELECT CASE
    WHEN EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'Animals' AND column_name = 'CustomerTrackerId'
    )
    THEN '✅ ÉXITO: CustomerTrackerId existe en tabla Animals'
    ELSE '❌ ERROR: CustomerTrackerId NO se creó correctamente'
END as resultado_final;