# Database Schema

## Overview
This document outlines the final schema inventory running in the Cloudflare D1 environment. All tables from the original MySQL `.sql` dump have been securely migrated to SQLite format to be compatible with Cloudflare D1.

## Table Inventory

### 1. `admins`
| Column | Type | Attributes |
|---|---|---|
| id | INTEGER | PRIMARY KEY AUTOINCREMENT |
| username | TEXT | UNIQUE NOT NULL |
| email | TEXT | |
| phone | TEXT | |
| password_hash | TEXT | NOT NULL |
| created_at | DATETIME | DEFAULT CURRENT_TIMESTAMP |

### 2. `apps`
| Column | Type | Attributes |
|---|---|---|
| id | INTEGER | PRIMARY KEY AUTOINCREMENT |
| category_id | INTEGER | FOREIGN KEY REFERENCES app_categories(id) |
| name | TEXT | NOT NULL |
| slug | TEXT | UNIQUE NOT NULL |
| developer | TEXT | |
| version | TEXT | |
| logo_url | TEXT | |
| banner_url | TEXT | |
| description | TEXT | |
| rating | REAL | DEFAULT 0.0 |
| downloads | INTEGER | DEFAULT 0 |
| status | TEXT | DEFAULT 'published' |
| created_at | DATETIME | DEFAULT CURRENT_TIMESTAMP |

### 3. `app_categories`
| Column | Type | Attributes |
|---|---|---|
| id | INTEGER | PRIMARY KEY AUTOINCREMENT |
| name | TEXT | NOT NULL |
| slug | TEXT | UNIQUE NOT NULL |
| description | TEXT | |
| icon | TEXT | |
| status | TEXT | DEFAULT 'active' |

### 4. `contact_messages`
| Column | Type | Attributes |
|---|---|---|
| id | INTEGER | PRIMARY KEY AUTOINCREMENT |
| name | TEXT | NOT NULL |
| email | TEXT | NOT NULL |
| subject | TEXT | NOT NULL |
| message | TEXT | NOT NULL |
| status | TEXT | DEFAULT 'unread' |
| created_at | DATETIME | DEFAULT CURRENT_TIMESTAMP |

### 5. `services`
| Column | Type | Attributes |
|---|---|---|
| id | INTEGER | PRIMARY KEY AUTOINCREMENT |
| name | TEXT | NOT NULL |
| slug | TEXT | UNIQUE NOT NULL |
| icon | TEXT | |
| description | TEXT | |
| status | TEXT | DEFAULT 'active' |

### 6. `website_settings`
| Column | Type | Attributes |
|---|---|---|
| id | INTEGER | PRIMARY KEY AUTOINCREMENT |
| site_name | TEXT | NOT NULL |
| logo_url | TEXT | |
| contact_email | TEXT | |
| primary_color | TEXT | |
| contact_phone | TEXT | |
| social_github | TEXT | |
