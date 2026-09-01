# Frontend to Data Mapping

## Overview
This document serves as the mandatory PRD requirement tracing every frontend user-facing component to its corresponding Cloudflare D1 backend data source.

## Page-by-Page Mapping

### 1. Apps Directory (Main Listing)
- **URL:** `/apps`
- **Purpose:** Display all published applications and allow filtering.
- **Database Tables:** `apps`, `app_categories`
- **Fields Rendered:** 
  - `apps.name`
  - `apps.description`
  - `apps.logo_url`
  - `apps.rating`
  - `app_categories.name`
- **API/Endpoint:** Direct D1 query inside `src/pages/apps/index.astro` 
  ```sql
  SELECT apps.*, app_categories.name as category_name 
  FROM apps LEFT JOIN app_categories ON apps.category_id = app_categories.id
  ```
- **Access:** Public

### 2. App Detail Page
- **URL:** `/apps/[slug]`
- **Purpose:** Display comprehensive details about a specific application.
- **Database Tables:** `apps`
- **Fields Rendered:** `name`, `description`, `developer`, `version`, `play_store_link`, `downloads`, `logo_url`, `requirements`
- **API/Endpoint:** Direct D1 query by `slug` in `src/pages/apps/[slug].astro`
- **Access:** Public

### 3. Services Page
- **URL:** `/services`
- **Purpose:** Display active company services.
- **Database Tables:** `services`
- **Fields Rendered:** `name`, `description`, `icon`, `status`
- **API/Endpoint:** `SELECT * FROM services WHERE status = 'active'` in `src/pages/services/index.astro`
- **Access:** Public

### 4. Contact Page
- **URL:** `/contact`
- **Purpose:** Display contact info and accept user messages.
- **Database Tables:** `website_settings` (Read), `contact_messages` (Write)
- **Fields Rendered:** `website_settings.contact_email`, `website_settings.contact_phone`
- **API/Endpoint:** 
  - POST request form handler in `src/pages/contact.astro` inserts into `contact_messages`
- **Access:** Public
