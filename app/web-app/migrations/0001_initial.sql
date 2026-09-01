-- Initial SQLite schema for Cloudflare D1 Migration

CREATE TABLE admins (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    phone TEXT,
    password_hash TEXT NOT NULL,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE admin_sessions (
    id TEXT PRIMARY KEY,
    admin_id INTEGER NOT NULL,
    token_hash TEXT NOT NULL,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    expires_at TEXT NOT NULL,
    last_seen_at TEXT DEFAULT CURRENT_TIMESTAMP,
    ip_hash TEXT,
    user_agent_hash TEXT,
    FOREIGN KEY(admin_id) REFERENCES admins(id) ON DELETE CASCADE
);

CREATE TABLE admin_activity_logs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    admin_id INTEGER NOT NULL,
    action TEXT NOT NULL,
    target_entity TEXT,
    target_id INTEGER,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(admin_id) REFERENCES admins(id) ON DELETE CASCADE
);

CREATE TABLE app_categories (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    slug TEXT NOT NULL UNIQUE,
    status TEXT NOT NULL CHECK (status IN ('active', 'inactive')) DEFAULT 'active',
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE apps (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    category_id INTEGER,
    name TEXT NOT NULL,
    slug TEXT NOT NULL UNIQUE,
    developer TEXT,
    version TEXT,
    logo_url TEXT,
    banner_url TEXT,
    description TEXT,
    requirements TEXT,
    play_store_rating REAL,
    indus_store_rating REAL,
    play_store_version TEXT,
    indus_store_version TEXT,
    play_store_downloads TEXT,
    indus_store_downloads TEXT,
    play_store_link TEXT,
    is_play_store_active INTEGER DEFAULT 1 CHECK (is_play_store_active IN (0, 1)),
    app_store_link TEXT,
    is_app_store_active INTEGER DEFAULT 1 CHECK (is_app_store_active IN (0, 1)),
    indus_store_link TEXT,
    is_indus_store_active INTEGER DEFAULT 1 CHECK (is_indus_store_active IN (0, 1)),
    amazon_store_link TEXT,
    is_amazon_store_active INTEGER DEFAULT 1 CHECK (is_amazon_store_active IN (0, 1)),
    apk_download_link TEXT,
    is_apk_active INTEGER DEFAULT 1 CHECK (is_apk_active IN (0, 1)),
    rating REAL DEFAULT 0.0,
    downloads INTEGER DEFAULT 0,
    cached_reviews TEXT,
    reviews_updated_at TEXT,
    is_featured INTEGER DEFAULT 0 CHECK (is_featured IN (0, 1)),
    status TEXT NOT NULL CHECK (status IN ('published', 'draft')) DEFAULT 'draft',
    publish_date TEXT,
    app_update_date TEXT,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(category_id) REFERENCES app_categories(id) ON DELETE SET NULL
);

CREATE TABLE services (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    slug TEXT NOT NULL UNIQUE,
    icon TEXT,
    description TEXT,
    status TEXT NOT NULL CHECK (status IN ('active', 'inactive')) DEFAULT 'active',
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE contact_messages (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    subject TEXT,
    message TEXT NOT NULL,
    status TEXT NOT NULL CHECK (status IN ('read', 'unread')) DEFAULT 'unread',
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE website_settings (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    site_name TEXT NOT NULL,
    logo_url TEXT,
    contact_email TEXT,
    contact_phone TEXT,
    contact_address TEXT,
    facebook_url TEXT,
    twitter_url TEXT,
    instagram_url TEXT,
    linkedin_url TEXT,
    github_url TEXT,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP
);

-- Initialize default website settings
INSERT INTO website_settings (site_name, contact_email) VALUES ('Techily Fly', 'contact@techilyfly.com');
