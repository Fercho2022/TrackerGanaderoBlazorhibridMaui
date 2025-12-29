-- Fix LocationHistory table to allow NULL AnimalId and TrackerId
-- This allows storing GPS data from unassigned trackers

-- Add missing DeviceId column (this is the CRITICAL fix)
ALTER TABLE "LocationHistories" ADD COLUMN IF NOT EXISTS "DeviceId" VARCHAR(100);

-- Make AnimalId nullable
ALTER TABLE "LocationHistories" ALTER COLUMN "AnimalId" DROP NOT NULL;

-- Make TrackerId nullable
ALTER TABLE "LocationHistories" ALTER COLUMN "TrackerId" DROP NOT NULL;

-- Create index on DeviceId for faster tracker discovery
CREATE INDEX IF NOT EXISTS "IX_LocationHistories_DeviceId" ON "LocationHistories" ("DeviceId");

-- Create index on Timestamp for faster queries
CREATE INDEX IF NOT EXISTS "IX_LocationHistories_Timestamp" ON "LocationHistories" ("Timestamp" DESC);

-- Verify the changes
\d "LocationHistories"