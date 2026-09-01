-- Migration number: 0006 	 2026-08-28T00:00:00.000Z

-- 1. Create Web App Categories Table
CREATE TABLE web_app_categories (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  slug TEXT NOT NULL UNIQUE,
  description TEXT DEFAULT NULL,
  icon TEXT DEFAULT NULL,
  status TEXT DEFAULT 'active'
);

-- 2. Alter Web Apps table to add category_id
ALTER TABLE web_apps ADD COLUMN category_id INTEGER DEFAULT NULL REFERENCES web_app_categories(id) ON DELETE SET NULL;

-- 3. Create Tool Categories Table
CREATE TABLE tool_categories (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  slug TEXT NOT NULL UNIQUE,
  description TEXT DEFAULT NULL,
  icon TEXT DEFAULT NULL,
  status TEXT DEFAULT 'active'
);

-- 4. Create Tools Table
CREATE TABLE tools (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  category_id INTEGER DEFAULT NULL,
  name TEXT NOT NULL,
  slug TEXT NOT NULL UNIQUE,
  logo_url TEXT,
  banner_url TEXT,
  description TEXT,
  web_url TEXT,
  is_featured INTEGER DEFAULT 0 CHECK (is_featured IN (0, 1)),
  status TEXT NOT NULL CHECK (status IN ('published', 'draft')) DEFAULT 'draft',
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (category_id) REFERENCES tool_categories(id) ON DELETE SET NULL
);
