import sys

schema = """
DROP TABLE IF EXISTS `apps`;
DROP TABLE IF EXISTS `app_categories`;
DROP TABLE IF EXISTS `admins`;
DROP TABLE IF EXISTS `contact_messages`;
DROP TABLE IF EXISTS `services`;
DROP TABLE IF EXISTS `website_settings`;

CREATE TABLE `admins` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `username` TEXT NOT NULL UNIQUE,
  `email` TEXT DEFAULT '',
  `phone` TEXT DEFAULT '',
  `password_hash` TEXT NOT NULL,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE `app_categories` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `name` TEXT NOT NULL,
  `slug` TEXT NOT NULL UNIQUE,
  `description` TEXT DEFAULT NULL,
  `icon` TEXT DEFAULT NULL,
  `status` TEXT DEFAULT 'active'
);

CREATE TABLE `apps` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `category_id` INTEGER DEFAULT NULL,
  `name` TEXT NOT NULL,
  `slug` TEXT NOT NULL UNIQUE,
  `developer` TEXT DEFAULT NULL,
  `version` TEXT DEFAULT NULL,
  `logo_url` TEXT DEFAULT NULL,
  `banner_url` TEXT DEFAULT NULL,
  `description` TEXT DEFAULT NULL,
  `requirements` TEXT DEFAULT NULL,
  `play_store_rating` REAL DEFAULT 0.00,
  `indus_store_rating` REAL DEFAULT 0.00,
  `play_store_version` TEXT DEFAULT '',
  `indus_store_version` TEXT DEFAULT '',
  `play_store_downloads` INTEGER DEFAULT 0,
  `indus_store_downloads` INTEGER DEFAULT 0,
  `play_store_link` TEXT DEFAULT NULL,
  `is_play_store_active` INTEGER DEFAULT 1,
  `app_store_link` TEXT DEFAULT NULL,
  `is_app_store_active` INTEGER DEFAULT 1,
  `indus_store_link` TEXT DEFAULT NULL,
  `is_indus_store_active` INTEGER DEFAULT 1,
  `amazon_store_link` TEXT DEFAULT NULL,
  `is_amazon_store_active` INTEGER DEFAULT 1,
  `apk_download_link` TEXT DEFAULT NULL,
  `is_apk_active` INTEGER DEFAULT 1,
  `rating` REAL DEFAULT 0.00,
  `downloads` INTEGER DEFAULT 0,
  `cached_reviews` TEXT DEFAULT NULL,
  `reviews_updated_at` DATETIME DEFAULT NULL,
  `is_featured` INTEGER DEFAULT 0,
  `status` TEXT DEFAULT 'published',
  `publish_date` TEXT DEFAULT NULL,
  `app_update_date` TEXT DEFAULT NULL,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`category_id`) REFERENCES `app_categories` (`id`) ON DELETE SET NULL
);

CREATE TABLE `contact_messages` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `name` TEXT NOT NULL,
  `email` TEXT NOT NULL,
  `subject` TEXT NOT NULL,
  `message` TEXT NOT NULL,
  `status` TEXT DEFAULT 'unread',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE `services` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `name` TEXT NOT NULL,
  `slug` TEXT NOT NULL UNIQUE,
  `icon` TEXT DEFAULT NULL,
  `description` TEXT DEFAULT NULL,
  `status` TEXT DEFAULT 'active'
);

CREATE TABLE `website_settings` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `site_name` TEXT NOT NULL,
  `logo_url` TEXT DEFAULT NULL,
  `contact_email` TEXT DEFAULT NULL,
  `primary_color` TEXT DEFAULT '#007bff',
  `contact_phone` TEXT DEFAULT NULL,
  `contact_address` TEXT DEFAULT NULL,
  `social_facebook` TEXT DEFAULT NULL,
  `social_twitter` TEXT DEFAULT NULL,
  `social_instagram` TEXT DEFAULT NULL,
  `social_linkedin` TEXT DEFAULT NULL,
  `social_github` TEXT DEFAULT NULL
);

INSERT INTO `admins` (`id`, `username`, `email`, `phone`, `password_hash`, `created_at`) VALUES
(1, 'TechilyFlyApps', 'techilyflyappofficial@gmail.com', '+918825164657', '$2y$10$LqP9WQRWvX5Dxr1QB1foCu.skMX3bHvA3c1bH8GRg5OaI9JR9w2Rm', '2026-08-02 14:55:19');

INSERT INTO `app_categories` (`id`, `name`, `slug`, `description`, `icon`, `status`) VALUES
(2, 'Productivity', 'productivity', 'Tools to boost your workflow.', 'bx-briefcase', 'active');
"""

with open(r'c:\Users\abdur\OneDrive\Desktop\Abdurrahman\Abdurrahman_Developer\Techily_Fly\Techily_Fly_Apps\app\web-app\d1_import_fixed.sql', 'r', encoding='utf-8') as f:
    inserts = f.read()

app_insert = ""
for line in inserts.split('\n'):
    if "INSERT INTO `apps`" in line or "(7, 2" in line:
        app_insert += line + '\n'

rest_of_schema = """
INSERT INTO `services` (`id`, `name`, `slug`, `icon`, `description`, `status`) VALUES
(1, 'Mobile App Development', 'mobile-app-development', 'bx-mobile', 'Custom native and cross-platform apps.', 'active'),
(2, 'Web App Development', 'web-app-development', 'bx-laptop', 'Scalable full-stack web solutions.', 'active'),
(3, 'UI/UX Design', 'ui-ux-design', 'bx-palette', 'Premium, modern aesthetic designs.', 'active');

INSERT INTO `website_settings` (`id`, `site_name`, `logo_url`, `contact_email`, `primary_color`, `contact_phone`, `contact_address`, `social_facebook`, `social_twitter`, `social_instagram`, `social_linkedin`, `social_github`) VALUES
(1, 'Techily Fly Apps', 'https://techilyfly.com/uploads/logo/Techily%20Fly%20Logo%20HD%20Large.svg', 'support@techilyfly.com', '#007bff', '+91-8825164657', 'Ward No. 07, Lahsaniya, Khoripakar, Dewapur, Motihari, Bihar 845427, IN', 'https://facebook.com/AbdurRahmanDotTop', 'https://twitter.com/techilyfly', 'https://instagram.com/AbdurRahmanDotTop', 'https://linkedin.com/company/techilyfly', 'https://github.com/AbdurRahmanDotTop'),
(2, 'Techily Fly Apps', '/assets/images/logo.png', 'contact@techilyfly.com', '#007bff', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
"""

with open(r'c:\Users\abdur\OneDrive\Desktop\Abdurrahman\Abdurrahman_Developer\Techily_Fly\Techily_Fly_Apps\app\web-app\d1_full_migration3.sql', 'w', encoding='utf-8') as f:
    f.write(schema + '\n' + app_insert + '\n' + rest_of_schema)
