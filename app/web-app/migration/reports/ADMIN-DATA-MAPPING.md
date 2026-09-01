# Admin Panel Data Mapping

## Overview
This document traces the data flow from the Admin Panel interfaces down to the Cloudflare D1 database, and explains how updates made by the admin affect the public-facing frontend.

## Admin Features Mapping

### 1. Dashboard Overview
- **Admin Feature:** General Statistics
- **Database Tables:** `contact_messages`, `apps`, `services`
- **Database Operation:** `COUNT(*)` aggregations
- **Frontend Effect:** None (Internal use only)

### 2. Apps Management (Future Extension)
- **Admin Feature:** Create, Edit, or Delete Applications
- **Database Tables:** `apps`
- **API/Backend:** Astro server-side form handlers inside `admin/apps`
- **Database Operation:** `INSERT`, `UPDATE`, `DELETE` on `apps` table
- **Frontend Effect:** Changes instantly reflect on `/apps` directory and the specific `/apps/[slug]` detail pages.

### 3. Contact Messages
- **Admin Feature:** Read and manage incoming support messages
- **Database Tables:** `contact_messages`
- **Database Operation:** `SELECT` and `UPDATE` (status changes from unread to read)
- **Frontend Effect:** None (Internal administrative use only)

### 4. Website Settings Management
- **Admin Feature:** Edit Site configuration (e.g. contact email, phone)
- **Database Tables:** `website_settings`
- **Database Operation:** `UPDATE` on `website_settings` ID 1
- **Frontend Effect:** Instantly updates the contact details displayed on the `/contact` frontend page and global `Footer` components.
