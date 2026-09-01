-- Migration number: 0005 	 2026-08-27T00:00:00.000Z
CREATE TABLE web_apps (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    slug TEXT NOT NULL UNIQUE,
    logo_url TEXT,
    banner_url TEXT,
    description TEXT,
    web_url TEXT,
    is_featured INTEGER DEFAULT 0 CHECK (is_featured IN (0, 1)),
    status TEXT NOT NULL CHECK (status IN ('published', 'draft')) DEFAULT 'draft',
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP
);
