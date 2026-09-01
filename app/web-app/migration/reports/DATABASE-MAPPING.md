# Database Relationships Mapping

## Overview
This document visually and technically maps the relationships between the migrated tables in the Cloudflare D1 environment. These relationships dictate how the Astro backend fetches complex relational data.

## Complete Map

```text
apps
  │
  └── (category_id) ──→ app_categories (id)
```

## Detailed Relationship Breakdown

### `apps` → `app_categories`
- **Relationship Type:** Many-to-One
- **Source:** `apps.category_id`
- **Target:** `app_categories.id`
- **Usage Context:** Displayed on the `Apps Directory` frontend (`/apps/index.astro`) and specific App Detail Pages. Each app must belong to a category. 
- **Migration Note:** Migrated successfully using standard SQLite FOREIGN KEY constraints with `ON DELETE SET NULL`.

### Isolated Tables
The following tables are structurally isolated and do not rely on foreign keys:
- `admins` (Used for Admin authentication and dashboard access)
- `contact_messages` (Stores incoming messages from the frontend contact form)
- `services` (Stores the static list of services provided, displayed on `/services`)
- `website_settings` (Stores global configurations applied across all frontend components like headers and footers)
