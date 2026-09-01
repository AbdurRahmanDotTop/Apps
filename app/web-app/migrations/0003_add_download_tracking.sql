-- Create a table for tracking unique downloads to prevent duplicate counting
CREATE TABLE `app_downloads_tracking` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `app_id` INTEGER NOT NULL,
  `platform` TEXT NOT NULL, -- e.g., 'apk', 'playstore', 'indus', 'appstore'
  `visitor_id` TEXT NOT NULL,
  `downloaded_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`app_id`) REFERENCES `apps` (`id`) ON DELETE CASCADE
);

-- Unique index to enforce one count per user per app per platform
CREATE UNIQUE INDEX `idx_unique_download` ON `app_downloads_tracking` (`app_id`, `platform`, `visitor_id`);

-- Add missing tracking columns for individual platforms
ALTER TABLE `apps` ADD COLUMN `app_store_downloads` INTEGER DEFAULT 0;
ALTER TABLE `apps` ADD COLUMN `apk_downloads` INTEGER DEFAULT 0;
