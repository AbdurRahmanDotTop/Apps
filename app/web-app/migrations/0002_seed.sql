-- Seed data migrated from legacy MySQL database

-- 1. App Categories
INSERT INTO app_categories (id, name, slug, status) VALUES
(2, 'Productivity', 'productivity', 'active');

-- 2. Apps
INSERT INTO apps (id, category_id, name, slug, developer, version, logo_url, banner_url, description, requirements, play_store_rating, indus_store_rating, play_store_version, indus_store_version, play_store_downloads, indus_store_downloads, play_store_link, is_play_store_active, app_store_link, is_app_store_active, indus_store_link, is_indus_store_active, amazon_store_link, is_amazon_store_active, apk_download_link, is_apk_active, rating, downloads, cached_reviews, reviews_updated_at, is_featured, status, publish_date, app_update_date, created_at, updated_at) VALUES
(7, 2, 'TF Plans - Smart Notes & Tasks with Reminders', 'TF-Plans', 'Abdurrahman Dot Top', '1.2.0', 'https://z-cdn-media.chatglm.cn/files/964726f5-5d6c-4a88-a6bb-5d9f81c890a5.png?auth_key=1885328558-ced8c481b35f4f5c9d86d4591b15ee7b-0-2bf7d0498048213caa51ebcf1300fd80', NULL, 'Smart notes, tasks, AI assistant, and reminders to organize your life.

# 🌟 User Features Guide

Welcome to the feature documentation! This guide outlines every capability available to you as an end-user. Whether you are taking quick notes, organizing your thoughts with checklists and attachments, or leveraging our AI Writing Assistant, this document will help you understand exactly what the app has to offer.

---

## 🔐 1. Authentication & Account Management

Your notes are secure and tied to your personal account.

*   **Sign Up & Login:** Create an account using your email and password.
*   **Google Sign-In:** One-tap login using your Google account for quicker access.
*   **Password Recovery:** Easily reset your password using the "Forgot Password" flow.
*   **Profile Management:** Update your display name and profile picture at any time.
*   **Account Security:** Sensitive actions (like changing passwords or deleting your account) require re-authentication to keep your data safe.
*   **Email Verification:** Check your email verification status directly from your profile.
*   **Account Deletion:** You have full control to permanently delete your account and all associated data.
*   **Sign Out:** Securely log out of your account on any device.

---

## 📝 2. Core Notes Management

A powerful and intuitive home for all your thoughts.

*   **Create & Edit Notes:** Easily draft new notes or view/edit existing ones.
*   **Pin Notes:** Keep important notes at the very top of your list for immediate access.
*   **Archive Notes:** Hide notes from the main feed without deleting them (accessible via the Archive menu).
*   **Global Search:** Quickly find specific notes using the search bar.
*   **Grid & List Views:** Toggle between a compact Grid view or a detailed List view directly from the Home screen.
*   **Auto-Save:** Never lose your work—notes save automatically when you press the back button.
*   **Timestamps:** View "Last Edited" and "Updated" timestamps to track changes.
*   **Empty States:** Helpful visual cues when you have "No notes yet", "No archived notes", or "No reminders".

---

## 🎨 3. Rich Text & Block Editor

Customize your notes with a flexible, block-based rich text editor.

*   **Modular Blocks:** Treat every paragraph or item as a flexible block.
*   **Interactive Checklists:** 
    *   Easily convert text into a checklist.
    *   Toggle items as complete or incomplete.
    *   **Drag & Drop:** Long-press and drag to reorder checklist items.
*   **Text Formatting:** 
    *   **Text Color:** Change the color of specific text.
    *   **Highlighting:** Add background colors to text for emphasis.
    *   **Clear Formatting:** Quickly strip formatting from selected text.
*   **Image Attachments:** Select and attach images from your device gallery directly into your notes.
*   **Voice & Audio Notes:** Record audio notes using your microphone and play them back inside the note.
*   **Note Background Colors:** Personalize the entire background color of any note with an advanced color picker.
*   **Dynamic Readability:** Text and icon colors automatically adjust to contrast with your chosen note background color.

---

## ✨ 4. AI Writing Assistant

Boost your productivity with the built-in AI Assistant (requires an active internet connection). All AI suggestions generate a preview that you can either "Accept & Apply" or "Cancel".

*   **Summarize Note:** Condense long notes into a quick summary.
*   **Fix Grammar & Spelling:** Automatically detect and correct language errors.
*   **Rewrite Professionally:** Rephrase your casual notes into a professional tone.
*   **Expand Ideas:** Let the AI add detail and depth to your brief bullet points.
*   **Continue Writing:** Stuck? The AI can seamlessly generate the next few sentences for you.
*   **Generate Title:** Automatically suggest a fitting title based on your note''s content.

---

## 📅 5. Organization & Reminders

Stay on top of your tasks and categorize your life.

*   **Category Tags:** Organize notes using preset tags (e.g., Work, Personal, Study, Ideas) or create your own custom tags.
*   **Time-based Reminders:** Set exact date and time alarms for specific notes.
*   **Recurring Reminders:** Choose repeating patterns for your reminders:
    *   Daily
    *   Weekly
    *   Monthly
    *   Yearly
*   **Quick Reminder Presets:** Save time with one-tap presets like:
    *   *Today at 6:00 PM*
    *   *Tomorrow at 9:00 AM*
    *   *Next Week (Monday at 9:00 AM)*
*   **System Notifications:** Receive push notifications when a reminder is due.

---

## ⚙️ 6. App Settings & Customization

Tailor the application to fit your personal preferences.

*   **Theme Selection:** Choose between Light mode, Dark mode, or follow your System Default.
*   **Adjustable Font Size:** Use a slider to increase or decrease the app''s font size with a live preview.
*   **Default View Preference:** Set your preferred default home layout (Grid vs. List).
*   **Support & Legal:** Easy access to "Contact Us", "Privacy Policy", "Terms & Conditions", and the ability to rate/share the app.

---

## ☁️ 7. Cloud Sync & Backup

Your data is synchronized and backed up securely.

*   **Real-time Cloud Sync:** Your notes automatically sync to the cloud.
*   **Manual Sync:** Use the "Sync Now" button on your profile for an immediate backup.
*   **Sync Status:** View your "Last Cloud Sync" timestamp on the profile page to ensure your data is safe.
*   **Offline Mode:** Create and edit notes without an internet connection. The app will automatically sync your changes to the cloud once you are back online (Note: AI features require an internet connection).', 'Android 8.0 (API 26) or higher. Internet required for sign-in, cloud sync and AI features.', 0.00, 5.00, '', '1.2.0', 0, 2, 'https://play.google.com/store/apps/details?id=com.techilyfly.tfplans', 1, 'https://drive.google.com/drive/folders/1Nh_Z33EA_d6d4pkXu253uwJXf66nPAjV?usp=drive_link', 0, 'https://www.indusappstore.com/apps/productivity/tf-plans/com.techilyfly.tfplans/?page=details&id=com.techilyfly.tfplans', 1, 'https://www.amazon.in/s?i=mobile-apps&rh=p_4%3ATechily%2BFly%2B%2528Ibn%2BGhufran%2529&search-type=ss', 0, 'https://drive.google.com/drive/folders/1Nh_Z33EA_d6d4pkXu253uwJXf66nPAjV?usp=drive_link', 1, 0.00, 32, '{"success":true,"reviews":[],"play_store_count":0,"indus_store_count":0}', '2026-08-25 03:41:16', 1, 'published', '2026-08-02', '2026-08-07', '2026-08-02 15:53:12', '2026-08-25 05:11:05');

-- 3. Services
INSERT INTO services (id, name, slug, icon, description, status) VALUES
(1, 'Mobile App Development', 'mobile-app-development', 'bx-mobile', 'Custom native and cross-platform apps.', 'active'),
(2, 'Web App Development', 'web-app-development', 'bx-laptop', 'Scalable full-stack web solutions.', 'active'),
(3, 'UI/UX Design', 'ui-ux-design', 'bx-palette', 'Premium, modern aesthetic designs.', 'active');

-- 4. Admins
INSERT INTO admins (id, username, email, phone, password_hash, created_at) VALUES
(1, 'TechilyFlyApps', 'techilyflyappofficial@gmail.com', '+918825164657', '$2y$10$LqP9WQRWvX5Dxr1QB1foCu.skMX3bHvA3c1bH8GRg5OaI9JR9w2Rm', '2026-08-02 14:55:19');

-- 5. Website Settings (Replace the initial one)
DELETE FROM website_settings;
INSERT INTO website_settings (id, site_name, logo_url, contact_email, contact_phone, contact_address, facebook_url, twitter_url, instagram_url, linkedin_url, github_url) VALUES
(1, 'Techily Fly Apps', 'https://techilyfly.com/uploads/logo/Techily%20Fly%20Logo%20HD%20Large.svg', 'support@techilyfly.com', '+91-8825164657', 'Ward No. 07, Lahsaniya, Khoripakar, Dewapur, Motihari, Bihar 845427, IN', 'https://facebook.com/AbdurRahmanDotTop', 'https://twitter.com/techilyfly', 'https://instagram.com/AbdurRahmanDotTop', 'https://linkedin.com/company/techilyfly', 'https://github.com/AbdurRahmanDotTop');
