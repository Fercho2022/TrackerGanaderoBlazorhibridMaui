-- Add CustomerTrackerId column to Animals table to link farm management with tracker assignment
-- This creates the bridge between the Customer/License model and Farm/Animal model

-- Add the new column to Animals table
ALTER TABLE "Animals"
ADD COLUMN "CustomerTrackerId" integer;

-- Add foreign key constraint to CustomerTrackers
ALTER TABLE "Animals"
ADD CONSTRAINT "FK_Animals_CustomerTrackers_CustomerTrackerId"
FOREIGN KEY ("CustomerTrackerId")
REFERENCES "CustomerTrackers" ("Id")
ON DELETE SET NULL;

-- Create index for better query performance
CREATE INDEX "IX_Animals_CustomerTrackerId"
ON "Animals" ("CustomerTrackerId");

-- Verify the changes
SELECT
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_name = 'Animals'
AND column_name = 'CustomerTrackerId';

PRINT 'CustomerTracker relationship added successfully to Animals table';