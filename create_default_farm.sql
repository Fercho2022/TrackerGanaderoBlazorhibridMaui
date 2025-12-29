-- Crear una granja por defecto si no existe
DO $$
BEGIN
    -- Insertar granja por defecto si no existe
    IF NOT EXISTS (SELECT 1 FROM "Farms" WHERE "Name" = 'Granja Animal') THEN
        INSERT INTO "Farms" ("Name", "Location", "UserId", "CreatedAt", "UpdatedAt")
        VALUES ('Granja Animal', 'Ubicación Principal', 1, NOW(), NOW());

        RAISE NOTICE 'Granja por defecto creada exitosamente';
    ELSE
        RAISE NOTICE 'La granja ya existe';
    END IF;

    -- Mostrar las granjas existentes
    RAISE NOTICE 'Granjas existentes:';
    FOR rec IN SELECT "Id", "Name", "Location" FROM "Farms" ORDER BY "Id"
    LOOP
        RAISE NOTICE 'ID: %, Nombre: %, Ubicación: %', rec."Id", rec."Name", rec."Location";
    END LOOP;
END $$;