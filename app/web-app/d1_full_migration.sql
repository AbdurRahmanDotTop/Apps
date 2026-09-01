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
INSERT INTO `apps` (`id`, `category_id`, `name`, `slug`, `developer`, `version`, `logo_url`, `banner_url`, `description`, `requirements`, `play_store_rating`, `indus_store_rating`, `play_store_version`, `indus_store_version`, `play_store_downloads`, `indus_store_downloads`, `play_store_link`, `is_play_store_active`, `app_store_link`, `is_app_store_active`, `indus_store_link`, `is_indus_store_active`, `amazon_store_link`, `is_amazon_store_active`, `apk_download_link`, `is_apk_active`, `rating`, `downloads`, `cached_reviews`, `reviews_updated_at`, `is_featured`, `status`, `publish_date`, `app_update_date`, `created_at`, `updated_at`) VALUES
(7, 2, 'TF Plans - Smart Notes & Tasks with Reminders', 'TF-Plans', 'Abdurrahman Dot Top', '1.2.0', 'https://z-cdn-media.chatglm.cn/files/964726f5-5d6c-4a88-a6bb-5d9f81c890a5.png?auth_key=1885328558-ced8c481b35f4f5c9d86d4591b15ee7b-0-2bf7d0498048213caa51ebcf1300fd80', NULL, 'Smart notes, tasks, AI assistant, and reminders to organize your life.\r\n\r\n# 🌟 User Features Guide\r\n\r\nWelcome to the feature documentation! This guide outlines every capability available to you as an end-user. Whether you are taking quick notes, organizing your thoughts with checklists and attachments, or leveraging our AI Writing Assistant, this document will help you understand exactly what the app has to offer.\r\n\r\n---\r\n\r\n## 🔐 1. Authentication & Account Management\r\n\r\nYour notes are secure and tied to your personal account.\r\n\r\n*   **Sign Up & Login:** Create an account using your email and password.\r\n*   **Google Sign-In:** One-tap login using your Google account for quicker access.\r\n*   **Password Recovery:** Easily reset your password using the \"Forgot Password\" flow.\r\n*   **Profile Management:** Update your display name and profile picture at any time.\r\n*   **Account Security:** Sensitive actions (like changing passwords or deleting your account) require re-authentication to keep your data safe.\r\n*   **Email Verification:** Check your email verification status directly from your profile.\r\n*   **Account Deletion:** You have full control to permanently delete your account and all associated data.\r\n*   **Sign Out:** Securely log out of your account on any device.\r\n\r\n---\r\n\r\n## 📝 2. Core Notes Management\r\n\r\nA powerful and intuitive home for all your thoughts.\r\n\r\n*   **Create & Edit Notes:** Easily draft new notes or view/edit existing ones.\r\n*   **Pin Notes:** Keep important notes at the very top of your list for immediate access.\r\n*   **Archive Notes:** Hide notes from the main feed without deleting them (accessible via the Archive menu).\r\n*   **Global Search:** Quickly find specific notes using the search bar.\r\n*   **Grid & List Views:** Toggle between a compact Grid view or a detailed List view directly from the Home screen.\r\n*   **Auto-Save:** Never lose your work—notes save automatically when you press the back button.\r\n*   **Timestamps:** View \"Last Edited\" and \"Updated\" timestamps to track changes.\r\n*   **Empty States:** Helpful visual cues when you have \"No notes yet\", \"No archived notes\", or \"No reminders\".\r\n\r\n---\r\n\r\n## 🎨 3. Rich Text & Block Editor\r\n\r\nCustomize your notes with a flexible, block-based rich text editor.\r\n\r\n*   **Modular Blocks:** Treat every paragraph or item as a flexible block.\r\n*   **Interactive Checklists:** \r\n    *   Easily convert text into a checklist.\r\n    *   Toggle items as complete or incomplete.\r\n    *   **Drag & Drop:** Long-press and drag to reorder checklist items.\r\n*   **Text Formatting:** \r\n    *   **Text Color:** Change the color of specific text.\r\n    *   **Highlighting:** Add background colors to text for emphasis.\r\n    *   **Clear Formatting:** Quickly strip formatting from selected text.\r\n*   **Image Attachments:** Select and attach images from your device gallery directly into your notes.\r\n*   **Voice & Audio Notes:** Record audio notes using your microphone and play them back inside the note.\r\n*   **Note Background Colors:** Personalize the entire background color of any note with an advanced color picker.\r\n*   **Dynamic Readability:** Text and icon colors automatically adjust to contrast with your chosen note background color.\r\n\r\n---\r\n\r\n## ✨ 4. AI Writing Assistant\r\n\r\nBoost your productivity with the built-in AI Assistant (requires an active internet connection). All AI suggestions generate a preview that you can either \"Accept & Apply\" or \"Cancel\".\r\n\r\n*   **Summarize Note:** Condense long notes into a quick summary.\r\n*   **Fix Grammar & Spelling:** Automatically detect and correct language errors.\r\n*   **Rewrite Professionally:** Rephrase your casual notes into a professional tone.\r\n*   **Expand Ideas:** Let the AI add detail and depth to your brief bullet points.\r\n*   **Continue Writing:** Stuck? The AI can seamlessly generate the next few sentences for you.\r\n*   **Generate Title:** Automatically suggest a fitting title based on your note''s content.\r\n\r\n---\r\n\r\n## 📅 5. Organization & Reminders\r\n\r\nStay on top of your tasks and categorize your life.\r\n\r\n*   **Category Tags:** Organize notes using preset tags (e.g., Work, Personal, Study, Ideas) or create your own custom tags.\r\n*   **Time-based Reminders:** Set exact date and time alarms for specific notes.\r\n*   **Recurring Reminders:** Choose repeating patterns for your reminders:\r\n    *   Daily\r\n    *   Weekly\r\n    *   Monthly\r\n    *   Yearly\r\n*   **Quick Reminder Presets:** Save time with one-tap presets like:\r\n    *   *Today at 6:00 PM*\r\n    *   *Tomorrow at 9:00 AM*\r\n    *   *Next Week (Monday at 9:00 AM)*\r\n*   **System Notifications:** Receive push notifications when a reminder is due.\r\n\r\n---\r\n\r\n## ⚙️ 6. App Settings & Customization\r\n\r\nTailor the application to fit your personal preferences.\r\n\r\n*   **Theme Selection:** Choose between Light mode, Dark mode, or follow your System Default.\r\n*   **Adjustable Font Size:** Use a slider to increase or decrease the app''s font size with a live preview.\r\n*   **Default View Preference:** Set your preferred default home layout (Grid vs. List).\r\n*   **Support & Legal:** Easy access to \"Contact Us\", \"Privacy Policy\", \"Terms & Conditions\", and the ability to rate/share the app.\r\n\r\n---\r\n\r\n## ☁️ 7. Cloud Sync & Backup\r\n\r\nYour data is synchronized and backed up securely.\r\n\r\n*   **Real-time Cloud Sync:** Your notes automatically sync to the cloud.\r\n*   **Manual Sync:** Use the \"Sync Now\" button on your profile for an immediate backup.\r\n*   **Sync Status:** View your \"Last Cloud Sync\" timestamp on the profile page to ensure your data is safe.\r\n*   **Offline Mode:** Create and edit notes without an internet connection. The app will automatically sync your changes to the cloud once you are back online (Note: AI features require an internet connection).', 'Android 8.0 (API 26) or higher. Internet required for sign-in, cloud sync and AI features.', 0.00, 5.00, '', '1.2.0', 0, 2, 'https://play.google.com/store/apps/details?id=com.techilyfly.tfplans', 1, 'https://drive.google.com/drive/folders/1Nh_Z33EA_d6d4pkXu253uwJXf66nPAjV?usp=drive_link', 0, 'https://www.indusappstore.com/apps/productivity/tf-plans/com.techilyfly.tfplans/?page=details&id=com.techilyfly.tfplans', 1, 'https://www.amazon.in/s?i=mobile-apps&rh=p_4%3ATechily%2BFly%2B%2528Ibn%2BGhufran%2529&search-type=ss', 0, 'https://drive.google.com/drive/folders/1Nh_Z33EA_d6d4pkXu253uwJXf66nPAjV?usp=drive_link', 1, 0.00, 32, '{\"success\":true,\"reviews\":[],\"play_store_count\":0,\"indus_store_count\":0}', '2026-08-25 03:41:16', 1, 'published', '2026-08-02', '2026-08-07', '2026-08-02 15:53:12', '2026-08-25 05:11:05');
INSERT INTO `app_categories` (`id`, `name`, `slug`, `description`, `icon`, `status`) VALUES
(2, 'Productivity', 'productivity', 'Tools to boost your workflow.', 'bx-briefcase', 'active');
INSERT INTO `services` (`id`, `name`, `slug`, `icon`, `description`, `status`) VALUES
(1, 'Mobile App Development', 'mobile-app-development', 'bx-mobile', 'Custom native and cross-platform apps.', 'active'),
(2, 'Web App Development', 'web-app-development', 'bx-laptop', 'Scalable full-stack web solutions.', 'active'),
(3, 'UI/UX Design', 'ui-ux-design', 'bx-palette', 'Premium, modern aesthetic designs.', 'active');
INSERT INTO `website_settings` (`id`, `site_name`, `logo_url`, `contact_email`, `primary_color`, `contact_phone`, `contact_address`, `social_facebook`, `social_twitter`, `social_instagram`, `social_linkedin`, `social_github`) VALUES
(1, 'Techily Fly Apps', 'https://techilyfly.com/uploads/logo/Techily%20Fly%20Logo%20HD%20Large.svg', 'support@techilyfly.com', '#007bff', '+91-8825164657', 'Ward No. 07, Lahsaniya, Khoripakar, Dewapur, Motihari, Bihar 845427, IN', 'https://facebook.com/AbdurRahmanDotTop', 'https://twitter.com/techilyfly', 'https://instagram.com/AbdurRahmanDotTop', 'https://linkedin.com/company/techilyfly', 'https://github.com/AbdurRahmanDotTop'),
(2, 'Techily Fly Apps', '/assets/images/logo.png', 'contact@techilyfly.com', '#007bff', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
