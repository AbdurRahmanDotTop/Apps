-- Create Menus Table
CREATE TABLE IF NOT EXISTS `menus` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `name` TEXT NOT NULL,
  `location` TEXT DEFAULT NULL,
  `status` TEXT DEFAULT 'active',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Create Menu Items Table
CREATE TABLE IF NOT EXISTS `menu_items` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `menu_id` INTEGER NOT NULL,
  `parent_id` INTEGER DEFAULT NULL,
  `label` TEXT NOT NULL,
  `url` TEXT NOT NULL,
  `icon` TEXT DEFAULT NULL,
  `target` TEXT DEFAULT '_self',
  `display_order` INTEGER DEFAULT 0,
  `status` TEXT DEFAULT 'active',
  `visibility` TEXT DEFAULT 'public',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`menu_id`) REFERENCES `menus` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`parent_id`) REFERENCES `menu_items` (`id`) ON DELETE CASCADE
);

-- Create Page Sections Table
CREATE TABLE IF NOT EXISTS `page_sections` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `identifier` TEXT NOT NULL UNIQUE,
  `name` TEXT NOT NULL,
  `content` TEXT NOT NULL, -- Stored as JSON
  `default_content` TEXT NOT NULL, -- Stored as JSON
  `is_active` INTEGER DEFAULT 1,
  `display_order` INTEGER DEFAULT 0,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Seed Menus
INSERT INTO `menus` (`id`, `name`, `location`) VALUES 
(1, 'Header Menu', 'header'),
(2, 'Footer Links', 'footer');

-- Seed Menu Items (Header Menu)
INSERT INTO `menu_items` (`menu_id`, `parent_id`, `label`, `url`, `target`, `display_order`) VALUES 
(1, NULL, 'Home', 'https://techilyfly.com/', '_blank', 1),
(1, NULL, 'Apps', '/apps', '_self', 2),
(1, NULL, 'Web Apps', '/web-apps', '_self', 3),
(1, NULL, 'Tools', '/tools', '_self', 4),
(1, NULL, 'Services', '/services', '_self', 5),
(1, NULL, 'Contact', '/contact', '_self', 6);

-- Seed Page Sections
INSERT INTO `page_sections` (`identifier`, `name`, `content`, `default_content`, `display_order`) VALUES 
('hero', 'Hero Section', 
 '{"title": "Discover Premium Apps <br /> <span class=\"gradient-text\">For Your Lifestyle</span>", "subtitle": "Explore our curated collection of top-tier mobile and web applications, or hire our expert team to build your dream app from scratch.", "button1_text": "Explore Apps", "button1_url": "/apps", "button2_text": "Our Services", "button2_url": "/services"}',
 '{"title": "Discover Premium Apps <br /> <span class=\"gradient-text\">For Your Lifestyle</span>", "subtitle": "Explore our curated collection of top-tier mobile and web applications, or hire our expert team to build your dream app from scratch.", "button1_text": "Explore Apps", "button1_url": "/apps", "button2_text": "Our Services", "button2_url": "/services"}',
 1),

('featured_apps', 'Featured Apps', 
 '{"title": "Featured Apps", "subtitle": "Discover our most popular mobile applications"}',
 '{"title": "Featured Apps", "subtitle": "Discover our most popular mobile applications"}',
 2),

('featured_web_apps', 'Featured Web Apps', 
 '{"title": "Featured Web Apps", "subtitle": "Explore our top web-based solutions"}',
 '{"title": "Featured Web Apps", "subtitle": "Explore our top web-based solutions"}',
 3),

('featured_tools', 'Featured Tools', 
 '{"title": "Featured Tools", "subtitle": "Explore our top recommended tools"}',
 '{"title": "Featured Tools", "subtitle": "Explore our top recommended tools"}',
 4),

('services', 'Our Expertise', 
 '{"title": "Our Expertise", "subtitle": "Professional integrations and managed solutions tailored for you."}',
 '{"title": "Our Expertise", "subtitle": "Professional integrations and managed solutions tailored for you."}',
 5),

('cta', 'Call To Action', 
 '{"title": "Ready to Start Your Project?", "subtitle": "Whether you need a cutting-edge mobile app or a scalable web platform, our team of experts is ready to bring your vision to life.", "button_text": "Request a Quote", "button_url": "/contact"}',
 '{"title": "Ready to Start Your Project?", "subtitle": "Whether you need a cutting-edge mobile app or a scalable web platform, our team of experts is ready to bring your vision to life.", "button_text": "Request a Quote", "button_url": "/contact"}',
 6);
