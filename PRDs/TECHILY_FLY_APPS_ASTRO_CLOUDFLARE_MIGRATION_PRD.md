# TECHILY FLY APPS

## Complete PHP/MySQL → Astro + Cloudflare Migration

### Product Requirements Document (PRD)

**Document Version:** 1.0
**Prepared:** 26 August 2026
**Migration Type:** Existing-system technology migration / modernization
**Primary Goal:** Preserve the existing website’s public interface, functionality, admin workflows, data and behavior while replacing the PHP + MySQL runtime with Astro + Cloudflare’s free-tier-compatible stack.

---

# 1. Executive Summary

Techily Fly Apps is currently implemented as a PHP + MySQL application with a public website, application directory, application detail pages, services, contact system, administrative panel, application/category/service management, website settings, download redirection, dynamic download counters and cached third-party app-store reviews.

The supplied project and database dump were inspected as the migration source of truth.

The supplied application contains **48 non-Git project files** plus the existing Git repository metadata. The current SQL database contains the following **6 implemented tables**:

1. `admins`
2. `apps`
3. `app_categories`
4. `contact_messages`
5. `services`
6. `website_settings`

The migration shall **not redesign the product conceptually** and shall **not add unrelated modules merely because an older PRD mentioned them**. The current working PHP code and current SQL dump are the authoritative source for functional parity.

The target system will use:

**Frontend / application framework**

* Astro
* TypeScript
* Astro components/pages
* Astro server rendering where dynamic behavior is required

**Cloud platform**

* Cloudflare Workers
* Cloudflare D1
* Cloudflare R2
* Cloudflare Turnstile
* Wrangler
* Cloudflare caching/CDN/security features

**Supporting open-source/free dependencies**

* Standard npm packages that are free/open-source and compatible with Cloudflare Workers
* No paid CMS
* No paid database
* No paid hosting
* No PHP runtime
* No MySQL runtime
* No Composer dependency
* No Node.js server running continuously in production

Astro’s official Cloudflare integration supports on-demand rendering, APIs, sessions and other full-stack capabilities on Cloudflare Workers. Current Astro documentation recommends Cloudflare Workers for new Cloudflare deployments. ([docs.astro.build][1])

Cloudflare’s current Free plan includes 100,000 Worker requests/day, D1 at 5 million rows read/day and 100,000 rows written/day, and 5 GB total D1 storage. ([Cloudflare Docs][2])

Cloudflare R2 currently includes 10 GB-month storage, 1 million Class A operations/month, 10 million Class B operations/month and free Internet egress on its free tier. ([Cloudflare Docs][3])

Cloudflare Turnstile has a Free plan with unlimited challenges, subject to its documented widget/hostname limits. ([Cloudflare Docs][4])

Therefore, the target architecture is suitable for this project provided actual traffic, database activity and storage remain within Cloudflare’s free-tier allowances. “Free” does not mean unlimited usage.

---

# 2. Migration Objective

The primary objective is:

> **Replace the PHP/MySQL implementation with Astro + Cloudflare while maintaining the existing website’s behavior, data and administrative capabilities as closely as technically possible.**

The following principle is mandatory:

## Functional parity before modernization

The first production migration must preserve:

* Existing public pages
* Existing application directory
* Existing application detail pages
* Existing application filtering
* Existing search
* Existing sorting
* Existing category system
* Existing service listing
* Existing contact form
* Existing admin login
* Existing admin dashboard
* Existing application CRUD
* Existing application duplication
* Existing category CRUD
* Existing service CRUD
* Existing contact-message management
* Existing website settings
* Existing admin profile functionality
* Existing password system
* Existing app download routing
* Existing download-count behavior
* Existing cached review behavior
* Existing social/contact information
* Existing app-store links
* Existing APK links
* Existing featured/draft/published states
* Existing legal/static page routes and content behavior
* Existing responsive behavior
* Existing light/dark theme behavior, subject to the mandatory new design-system palette

---

# 3. Important Scope Clarification

The older project documentation contains a much larger future CMS specification, including:

* Portfolio
* Blog
* Testimonials
* FAQ CMS
* Newsletter
* Quote requests
* User management
* RBAC
* Media manager
* SEO manager
* Analytics
* Notifications
* Backups
* File manager
* Multiple admin roles
* etc.

However, those modules are **not present as implemented database tables in the supplied current database**, and many are explicitly identified in the legacy documentation as future/planned features.

The migration therefore uses:

> **Current PHP source + current SQL dump = functional source of truth.**

The migration must not silently turn planned features into assumed existing features.

Future functionality may be added after parity is achieved.

---

# 4. Current System Audit

## 4.1 Current technology

The supplied implementation currently uses:

* PHP
* MySQL/MariaDB
* PDO
* PHP sessions
* HTML
* CSS
* JavaScript
* Boxicons
* external HTTP/API calls
* local server/shared-host style file structure
* `.htaccess` routing support

The SQL dump was generated against:

* MariaDB 10.4.32
* PHP 8.2.12

---

# 5. Current Implemented Public Modules

## 5.1 Homepage

Current homepage provides the public-facing Techily Fly Apps presentation and uses dynamic website settings.

Migration requirements:

* Preserve public branding/content structure.
* Preserve navigation.
* Preserve responsive behavior.
* Replace PHP templates with Astro components/layouts.
* Fetch dynamic settings from D1.
* Keep database as source of truth for editable settings.

Target route:

`/`

---

# 6. Application Directory

Current route:

`/modules/apps/index.php`

The application directory currently supports:

### Search

Users can search applications by keyword.

### Category filtering

Users can filter by application category.

### Sorting

Current sorting options include:

* Latest
* Most Popular
* Top Rated

### Application cards

Application cards display:

* Application logo
* Application name
* Category
* Rating
* Description/excerpt
* Featured badge
* Details action
* APK action

The migration must preserve all of these.

Suggested canonical Astro route:

`/apps`

Legacy URL compatibility must be implemented through redirect/rewrite handling.

---

# 7. Application Detail System

Current implementation resolves applications using the slug.

Example behavior:

`details.php/<slug>`

The new system shall use:

`/apps/[slug]`

The page must retain:

## Application identity

* Name
* Logo
* Developer
* Version
* Category
* Rating
* Download count

## Download and store actions

* APK
* Google Play Store
* Apple App Store
* Indus App Store
* Amazon Appstore

Each action must honor its active/inactive flag.

## Content

* Banner
* About application
* Requirements
* Developer
* Category
* Published date
* Updated date
* Last modification date

## Review section

* Review cards
* Reviewer name
* Rating
* Review text
* Date
* Source
* Google Play count
* Indus App Store count
* Read-more links

---

# 8. Application Download System

The old application uses a server-side download router that:

1. Receives application ID.
2. Receives download type.
3. Checks the application record.
4. Determines the correct destination URL.
5. Increments the application download counter.
6. Prevents repeated increments during the same session.
7. Redirects to the final store/APK URL.

The migration must preserve this logic.

New architecture:

`/api/download/[id]/[type]`

Possible types:

* `apk`
* `playstore`
* `appstore`
* `indus`
* `amazon`

The Worker/Astro endpoint will:

1. Validate route parameters.
2. Query D1.
3. Verify that the requested destination exists.
4. Verify the associated active flag.
5. Increment the download counter exactly according to the legacy business rule.
6. Redirect with HTTP 302/307 as appropriate.

---

# 9. Services System

Current implementation:

`/services.php`

The current system displays active services ordered by ID.

Each service has:

* ID
* Name
* Slug
* Icon
* Description
* Status

Target route:

`/services`

The public page must display only active services.

---

# 10. Contact System

Current implementation:

`/contact.php`

The current database structure supports:

* Name
* Email
* Subject
* Message
* Status
* Created date

The migration shall preserve this behavior.

Target endpoint:

`POST /api/contact`

The form must:

1. Validate the visitor input.
2. Sanitize input.
3. Validate email.
4. Protect against automated abuse.
5. Store the message in D1.
6. Return a clear success/error result.

---

# 11. Contact Admin System

Current admin implementation supports:

* Message listing
* Read/unread status
* Message viewing
* Message deletion

New routes:

* `/admin/messages`
* `/admin/messages/[id]`
* `/admin/messages/[id]/delete`

The administrator must retain the ability to review incoming contact messages.

---

# 12. Admin Authentication

The current SQL database contains an `admins` table.

Current structure:

* ID
* Username
* Email
* Phone
* Password hash
* Created date

The migration shall preserve existing administrator records.

## Password compatibility requirement

The existing database contains bcrypt password hashes.

The migration must not replace the existing administrator password with a guessed or hardcoded value.

The migration must support verification of the existing bcrypt hashes.

A pure-JavaScript bcrypt-compatible implementation may be used where required for Cloudflare Worker compatibility.

After successful login, the application may optionally upgrade password hashes to a stronger future-compatible scheme, but existing accounts must remain usable during migration.

---

# 13. Admin Login Flow

New route:

`/admin/login`

Requirements:

* Username/password login
* Secure password verification
* Rate limiting
* Turnstile integration
* HttpOnly cookie
* Secure cookie
* SameSite protection
* Session expiration
* Logout
* Login failure handling
* No password leakage
* No database credentials exposed to browser
* No session information stored in LocalStorage

Cloudflare Turnstile should be used for login/contact anti-abuse protection where appropriate. Its Free plan currently supports unlimited challenges, subject to documented account/widget limits. ([Cloudflare Docs][4])

---

# 14. Admin Session Architecture

PHP sessions cannot be copied directly to Cloudflare Workers.

New session architecture:

### Preferred model

D1-backed sessions:

```text
Browser
   ↓
Secure HttpOnly Session Cookie
   ↓
Astro/Cloudflare Worker
   ↓
D1 sessions table
   ↓
Administrator identity
```

A future session table may contain:

* `id`
* `admin_id`
* `token_hash`
* `created_at`
* `expires_at`
* `last_seen_at`
* `ip_hash`
* `user_agent_hash`

Only a hashed session token should be persisted.

No raw session credentials should be stored in D1.

---

# 15. Admin Dashboard

Current dashboard behavior and statistics must be preserved.

New route:

`/admin`

The dashboard should provide the existing administrative overview, including applicable statistics such as:

* Total apps
* Total downloads
* Published apps
* Draft apps
* Featured apps
* Total categories
* Total services
* Total contact messages
* Unread messages

The system should avoid expensive database queries for every dashboard card when a single optimized query or aggregated query can provide the necessary totals.

---

# 16. Application Management

Current admin implementation includes:

* List applications
* Create
* Edit
* Delete
* Duplicate

New routes:

```text
/admin/apps
/admin/apps/new
/admin/apps/[id]
/admin/apps/[id]/edit
/admin/apps/[id]/delete
/admin/apps/[id]/duplicate
```

---

# 17. Application Fields

The migration must preserve the current `apps` schema.

The current application record includes:

```text
id
category_id
name
slug
developer
version
logo_url
banner_url
description
requirements

play_store_rating
indus_store_rating

play_store_version
indus_store_version

play_store_downloads
indus_store_downloads

play_store_link
is_play_store_active

app_store_link
is_app_store_active

indus_store_link
is_indus_store_active

amazon_store_link
is_amazon_store_active

apk_download_link
is_apk_active

rating
downloads

cached_reviews
reviews_updated_at

is_featured
status
publish_date
app_update_date

created_at
updated_at
```

No field may be silently dropped during migration.

---

# 18. Application Duplication

Existing duplicate logic must be preserved.

The duplicate workflow currently:

1. Copies the application.
2. Changes the name to a copy-style name.
3. Generates a unique slug.
4. Sets the new application to Draft.
5. Redirects to editing.

The Astro implementation must preserve this workflow.

---

# 19. Categories

Current admin category management supports:

* List categories
* Create category
* Edit category
* Delete category
* Active/inactive status

New routes:

```text
/admin/categories
/admin/categories/new
/admin/categories/[id]/edit
/admin/categories/[id]/delete
```

---

# 20. Category Public Behavior

Only active categories must appear in public application filtering.

Application records linked to deleted categories must preserve the legacy `ON DELETE SET NULL` behavior.

Because D1 uses SQLite semantics, the migration must explicitly configure foreign-key enforcement and preserve this relationship behavior.

---

# 21. Services Administration

Current admin service management supports:

* List services
* Create
* Edit
* Delete
* Status

New routes:

```text
/admin/services
/admin/services/new
/admin/services/[id]/edit
/admin/services/[id]/delete
```

---

# 22. Website Settings

Current website settings support:

* Site name
* Logo
* Contact email
* Contact phone
* Contact address
* Facebook
* Twitter
* Instagram
* LinkedIn
* GitHub

The new system must retain all editable fields.

New route:

`/admin/settings`

---

# 23. Admin Profile

The current implementation includes administrator profile functionality.

The migration must preserve:

* Username
* Email
* Phone
* Password update

New route:

`/admin/profile`

Password update must require:

* authenticated session
* current password confirmation
* new password validation
* password confirmation
* secure password hashing

---

# 24. Admin Authorization

The supplied database currently contains an `admins` table but does not contain a complete role/permission matrix.

Therefore:

## Migration Phase 1

The administrator model will remain:

**Authenticated administrator**

rather than inventing unsupported roles.

Future RBAC can be added later without changing the public application architecture.

---

# 25. Public User Account Requirement

The supplied current application does **not** contain a public user-account database model.

The SQL schema has no:

* users table
* customer accounts
* user passwords
* customer profiles
* customer dashboard
* user roles

Therefore the migration will preserve the current architecture:

> Public visitors are anonymous users; only administrator authentication exists.

A future customer/user account system must be treated as a new feature rather than as part of parity migration.

---

# 26. Reviews System

The supplied project includes a dedicated review aggregation/cache mechanism.

The current implementation retrieves reviews from external services and stores a cached JSON response in:

`apps.cached_reviews`

with timestamp:

`apps.reviews_updated_at`

The current system includes two external review sources:

### Google Play review source

Current project uses an externally hosted review API.

### Indus App Store review source

Current project uses an external Playwright-based service.

---

# 27. Review Migration Architecture

The target system should introduce a provider abstraction:

```text
ReviewService
 ├── GooglePlayProvider
 ├── IndusStoreProvider
 └── CachedReviewRepository
```

The application detail page must never directly depend on scraping logic.

Flow:

```text
App Details Page
      ↓
GET /api/apps/[id]/reviews
      ↓
Review Cache Check
      ↓
Fresh Cache?
   ↙          ↘
 YES           NO
  ↓             ↓
D1 Cache      Provider API
  ↓             ↓
 Response     Normalize
                ↓
              D1 Cache
                ↓
             Response
```

The cache duration should remain equivalent to the existing implementation.

The source code currently documents a 24-hour/legacy caching strategy, while the currently inspected endpoint contains a shorter cache comparison in one revision. The migration must establish **one explicit configurable TTL** and use it consistently rather than retaining conflicting hardcoded values.

Recommended default:

`86400 seconds`

---

# 28. Third-Party Review Dependency Policy

Because the requested production stack is intended to be Cloudflare + Astro + free technologies, external review providers must not become a hard dependency for the entire application.

Therefore:

* Review data must be cached.
* Failure to contact external review providers must not break the app details page.
* Existing cached data must continue to render.
* Empty review data must render a graceful fallback.
* Provider failures must be logged.
* Provider URLs must be environment/config driven.
* The main website must continue operating if either review provider becomes unavailable.

---

# 29. Design System

The new application must use **only** the following visual tokens.

## Brand colors

| Token         | Hex       |
| ------------- | --------- |
| TF Graphite   | `#212121` |
| Signal Coral  | `#FF7759` |
| Cloud Surface | `#FAFAFA` |

## Typography

| Use                  | Typeface   |
| -------------------- | ---------- |
| Brand                | Manrope    |
| Headings             | Manrope    |
| UI                   | Manrope    |
| Body                 | Manrope    |
| Code                 | Geist Mono |
| Technical/data layer | Geist Mono |

No other font family may be introduced.

No additional brand color may be added.

---

# 30. Color Token Architecture

CSS must use variables:

```css
:root {
  --tf-graphite: #212121;
  --signal-coral: #FF7759;
  --cloud-surface: #FAFAFA;

  --font-brand: "Manrope", sans-serif;
  --font-mono: "Geist Mono", monospace;
}
```

All other UI colors must be derived from these approved tokens rather than introducing new hexadecimal colors.

For example:

* Primary text → TF Graphite
* Primary surface → Cloud Surface
* Primary CTA → Signal Coral
* Borders → controlled opacity of approved tokens
* Hover states → controlled opacity/tint of approved tokens
* Focus states → Signal Coral
* Dangerous/delete actions → Signal Coral
* Secondary controls → Graphite + approved opacity
* Code/data → Geist Mono + approved tokens

---

# 31. Dark Mode

The existing application supports light/dark theme switching.

The redesigned system shall preserve the feature.

However, no additional brand colors may be introduced.

Dark mode must be produced from the approved palette through token relationships and opacity rather than adding blue, purple, green, red or other colors.

Example conceptual mapping:

```text
Dark background → TF Graphite
Dark text        → Cloud Surface
Primary CTA      → Signal Coral
Secondary text   → Cloud Surface with opacity
Borders          → Cloud Surface with opacity
```

The dark/light preference may continue to use local browser preference storage because theme preference is not core business data.

---

# 32. Typography Rules

### Manrope

Must be used for:

* Logo text
* Navigation
* H1–H6
* Buttons
* Forms
* Tables
* Cards
* Body content
* Messages
* Labels

### Geist Mono

Must be used only for:

* IDs
* technical values
* version numbers where appropriate
* API/technical data
* debug/developer-facing information
* code snippets
* timestamps where a technical presentation is appropriate

Geist Mono should not become the normal UI/body font.

---

# 33. Astro Architecture

Recommended structure:

```text
techily-fly-apps/
│
├── src/
│   ├── components/
│   │   ├── ui/
│   │   ├── public/
│   │   ├── admin/
│   │   ├── apps/
│   │   ├── services/
│   │   └── reviews/
│   │
│   ├── layouts/
│   │   ├── PublicLayout.astro
│   │   └── AdminLayout.astro
│   │
│   ├── pages/
│   │   ├── index.astro
│   │   ├── apps/
│   │   │   ├── index.astro
│   │   │   └── [slug].astro
│   │   ├── services/
│   │   │   └── index.astro
│   │   ├── contact.astro
│   │   ├── page/
│   │   │   └── [slug].astro
│   │   │
│   │   ├── admin/
│   │   │   ├── index.astro
│   │   │   ├── login.astro
│   │   │   ├── profile.astro
│   │   │   ├── settings.astro
│   │   │   ├── apps/
│   │   │   ├── categories/
│   │   │   ├── services/
│   │   │   └── messages/
│   │   │
│   │   └── api/
│   │       ├── auth/
│   │       ├── apps/
│   │       ├── contact.ts
│   │       ├── download/
│   │       ├── reviews/
│   │       └── admin/
│   │
│   ├── lib/
│   │   ├── db/
│   │   ├── auth/
│   │   ├── security/
│   │   ├── reviews/
│   │   ├── validation/
│   │   └── utils/
│   │
│   ├── middleware.ts
│   └── styles/
│       ├── tokens.css
│       ├── global.css
│       ├── public.css
│       └── admin.css
│
├── public/
│   ├── favicon/
│   └── static/
│
├── migrations/
│   ├── 0001_initial.sql
│   ├── 0002_seed.sql
│   └── ...
│
├── scripts/
│   ├── migrate-data/
│   └── validation/
│
├── astro.config.mjs
├── wrangler.jsonc
├── package.json
├── tsconfig.json
└── README.md
```

---

# 34. Cloudflare Architecture

Target architecture:

```text
                         ┌───────────────────────┐
                         │       Visitor         │
                         └───────────┬───────────┘
                                     │
                                     ▼
                         ┌───────────────────────┐
                         │   Cloudflare DNS/CDN  │
                         └───────────┬───────────┘
                                     │
                                     ▼
                         ┌───────────────────────┐
                         │   Cloudflare Worker   │
                         │       + Astro         │
                         └──────┬─────────┬──────┘
                                │         │
                     ┌──────────┘         └────────────┐
                     ▼                                 ▼
              ┌────────────┐                    ┌────────────┐
              │     D1     │                    │     R2     │
              │  Database  │                    │   Assets   │
              └────────────┘                    └────────────┘
                               
                                │
                                ▼
                        ┌──────────────┐
                        │ Third-party  │
                        │ review APIs  │
                        └──────────────┘
```

---

# 35. Cloudflare Worker

The Worker is the production runtime for the Astro application.

Responsibilities:

* HTTP handling
* Astro SSR
* API endpoints
* Authentication
* D1 access
* R2 access
* redirects
* security middleware
* caching headers
* review API proxying
* download counting
* contact submission
* admin operations

Astro’s official deployment documentation currently recommends Workers for new Cloudflare projects. ([docs.astro.build][1])

---

# 36. Cloudflare D1

D1 replaces MySQL/MariaDB.

Current D1 Free limits include:

* 5 million rows read/day
* 100,000 rows written/day
* 5 GB total storage
* 10 free-plan D1 databases
* 50 queries per Worker invocation
* 2 MB maximum string/BLOB/table-row size

These limits must be incorporated into application design. ([Cloudflare Docs][5])

---

# 37. MySQL → D1 Conversion

The migration must translate the SQL schema rather than attempt to execute the MySQL dump unchanged.

Example:

### MySQL

```sql
id int(11) NOT NULL AUTO_INCREMENT
```

### D1/SQLite

```sql
id INTEGER PRIMARY KEY AUTOINCREMENT
```

---

# 38. Data-Type Mapping

| MySQL      | D1/SQLite                                      |
| ---------- | ---------------------------------------------- |
| INT        | INTEGER                                        |
| BIGINT     | INTEGER                                        |
| TINYINT(1) | INTEGER                                        |
| VARCHAR    | TEXT                                           |
| TEXT       | TEXT                                           |
| LONGTEXT   | TEXT                                           |
| DECIMAL    | REAL/INTEGER depending on business requirement |
| DATE       | TEXT                                           |
| DATETIME   | TEXT                                           |
| TIMESTAMP  | TEXT                                           |
| ENUM       | TEXT + CHECK constraint                        |
| BOOLEAN    | INTEGER                                        |

---

# 39. Enum Conversion

For example:

```sql
status ENUM('published','draft')
```

becomes:

```sql
status TEXT NOT NULL
CHECK (status IN ('published', 'draft'))
```

Similarly:

```text
active/inactive
unread/read
```

must become equivalent SQLite constraints.

---

# 40. Foreign Keys

The current applications table has:

```text
category_id → app_categories.id
```

with delete behavior:

```text
ON DELETE SET NULL
```

The D1 migration must preserve this relationship.

Foreign-key enforcement must be explicitly enabled.

---

# 41. Target Core Database

Target database tables:

```text
admins
apps
app_categories
contact_messages
services
website_settings
```

Additional infrastructure tables:

```text
admin_sessions
admin_activity_logs
```

These additional infrastructure tables are permitted because they are required to reproduce secure Worker-based sessions/logging that PHP sessions previously provided implicitly.

---

# 42. Future Database Extensions

The architecture must allow later additions such as:

```text
roles
permissions
blogs
portfolio
testimonials
faqs
newsletter_subscribers
quote_requests
media
seo
notifications
analytics
```

But none of these should be mandatory for the first parity release.

---

# 43. R2 Storage

Cloudflare R2 is recommended for:

* application logos
* banners
* future screenshots
* uploaded media
* APK files
* PDF/document assets
* other application assets

Current R2 Free allowance includes 10 GB-month storage, 1 million Class A operations/month, 10 million Class B operations/month and free egress. ([Cloudflare Docs][3])

The application must not assume unlimited free storage.

---

# 44. Asset Strategy

Existing external image URLs must initially remain valid.

Migration strategy:

### Phase A

Preserve existing URLs.

### Phase B

Optionally migrate controlled assets to R2.

### Phase C

Update D1 URLs to R2 objects.

This prevents a database migration from unnecessarily breaking currently working image URLs.

---

# 45. R2 Public Access Strategy

R2 assets should be served through controlled public URLs or Worker routes.

Example:

```text
https://techilyfly.com/assets/apps/{slug}/logo.webp
```

Internally:

```text
R2 bucket
   ↓
Cloudflare Worker
   ↓
Cache-Control
   ↓
Browser
```

Private administrative files must not be publicly readable unless explicitly intended.

---

# 46. Legacy URL Compatibility

The migration must not unnecessarily destroy existing URLs.

The following legacy paths should be recognized:

```text
/index.php
/modules/apps/index.php
/modules/apps/details.php/{slug}
/modules/apps/download.php
/services.php
/contact.php
/page.php/{slug}

/admin/index.php
/admin/login.php
/admin/apps/...
/admin/categories/...
/admin/services/...
/admin/messages/...
/admin/settings.php
/admin/profile.php
```

Recommended canonical paths:

```text
/
 /apps
 /apps/{slug}
 /services
 /contact
 /page/{slug}

/admin
/admin/login
/admin/apps
/admin/categories
/admin/services
/admin/messages
/admin/settings
/admin/profile
```

Legacy routes should return appropriate redirects to the canonical Astro routes.

For SEO preservation, permanent redirects should be used when the old URL has an exact replacement.

---

# 47. SEO Preservation

The new system must maintain or improve:

* `<title>`
* description
* canonical URLs
* Open Graph
* Twitter metadata
* robots rules
* sitemap
* robots.txt
* semantic headings
* image alt attributes

Application pages must generate dynamic metadata from D1.

---

# 48. Sitemap

Dynamic sitemap must include:

* homepage
* applications
* application detail pages
* services
* supported static/legal pages

Draft applications must not appear in public sitemap.

---

# 49. Robots

A public:

`/robots.txt`

must be generated.

Admin routes must not be indexed.

Recommended:

```text
Disallow: /admin
```

---

# 50. Security Requirements

The migration is security-sensitive because the old system is an authenticated CMS.

Mandatory controls:

* HTTPS
* HttpOnly cookies
* Secure cookies
* SameSite cookies
* CSRF protection
* request validation
* output escaping
* SQL parameter binding
* prepared D1 statements
* login rate limiting
* Turnstile on suitable public/admin forms
* secret storage in Cloudflare secrets
* no database credentials in source
* no API keys in browser code
* no private files under publicly accessible source directories
* security headers
* content security policy where compatible
* administrator session expiry
* logout invalidation

---

# 51. SQL Injection Protection

PHP PDO prepared statements must not be translated into string-interpolated SQL.

Every query in the new application must use bound parameters.

Example:

```ts
const result = await db
  .prepare(`
    SELECT *
    FROM apps
    WHERE slug = ?
      AND status = 'published'
  `)
  .bind(slug)
  .first();
```

No user-controlled values may be concatenated into SQL.

---

# 52. XSS Protection

The new application must distinguish:

* plain text
* trusted HTML
* rich content

Database fields such as:

* name
* subject
* developer
* slug
* email
* phone

must be rendered as escaped text.

The current application description uses escaped output and line-break conversion; this behavior must remain safe.

---

# 53. CSRF

All state-changing administrative operations must require CSRF protection.

This includes:

* create
* update
* delete
* duplicate
* password change
* settings update
* message delete
* logout if implemented as state-changing POST

GET requests should not perform destructive operations.

This is an explicit improvement required by the migration because some legacy delete routes currently use GET actions.

---

# 54. Rate Limiting

Rate limiting must be applied especially to:

* admin login
* contact form
* review refresh endpoints
* download endpoint
* sensitive admin APIs

The first implementation should prioritize Cloudflare-native controls and lightweight Worker logic rather than introducing a paid service.

---

# 55. Turnstile

Turnstile can protect:

* admin login
* contact submission
* potentially public abusive endpoints

The Free plan currently supports unlimited challenges, making it appropriate for the project’s anti-bot layer within its documented account limits. ([Cloudflare Docs][4])

---

# 56. Caching Strategy

Caching must be intentionally designed.

## Static assets

Long cache lifetime:

```text
Cache-Control: public, max-age=31536000, immutable
```

when fingerprinted.

## Public application pages

Use Cloudflare caching where safe.

## Dynamic admin pages

Must not be publicly cached.

## Review endpoint

Use application-level D1 cache plus HTTP caching where appropriate.

---

# 57. Performance Requirements

Targets:

* Fast initial HTML response
* Minimal client-side JavaScript
* Server-rendered content for SEO-sensitive pages
* Lazy loading of below-fold images
* optimized image formats
* cache-friendly assets
* pagination if application inventory grows substantially
* no unnecessary external API call on every page view

Astro is well suited to this architecture because static content can remain lightweight while dynamic routes can be server-rendered on Cloudflare Workers. ([docs.astro.build][1])

---

# 58. Client-Side JavaScript

The migration must not blindly reproduce the old PHP page with large client-side JavaScript.

JavaScript should only be used where interaction is required:

* mobile navigation
* theme toggle
* filters
* asynchronous review loading
* form feedback
* admin interactions where necessary

Astro components should remain server-first.

---

# 59. Mobile Navigation

The existing navigation has:

* desktop menu
* mobile hamburger
* mobile open/close
* active menu state

This must be retained.

---

# 60. Theme Preference

The current application stores theme preference in browser LocalStorage.

This can remain because:

* it is non-sensitive
* it is client preference
* it does not require D1
* it does not require authentication

---

# 61. Public Components

Reusable components must include:

```text
Header
Footer
Navigation
MobileMenu
Button
Card
AppCard
Rating
Badge
FilterBar
SearchBar
ServiceCard
ReviewCard
EmptyState
Pagination
FormField
```

---

# 62. Admin Components

Reusable admin components:

```text
AdminLayout
AdminSidebar
AdminHeader
AdminTable
AdminForm
AdminButton
ConfirmDialog
StatusBadge
Pagination
FlashMessage
DashboardCard
```

---

# 63. Admin Layout

Desktop:

```text
┌──────────────┬────────────────────────┐
│ Admin Sidebar│ Header                 │
│              ├────────────────────────┤
│ Dashboard    │                        │
│ Apps         │     Page Content       │
│ Categories   │                        │
│ Services     │                        │
│ Messages     │                        │
│ Settings     │                        │
│ Profile      │                        │
└──────────────┴────────────────────────┘
```

Mobile:

* collapsible sidebar
* touch-friendly controls
* responsive tables
* form stacking

---

# 64. Application Listing UX

The application directory must retain:

* search
* category filter
* sorting
* responsive card grid
* featured indicator
* rating
* description
* details link
* download action

The new implementation should use accessible form controls instead of relying purely on onchange behavior.

---

# 65. Search

Initial search behavior should remain equivalent to the current system.

Search should query relevant application fields.

Minimum:

```text
name
developer
description
category
```

The search implementation must use parameterized SQL.

For a small dataset, SQLite/D1 LIKE-based search is sufficient.

If the dataset later becomes large, SQLite FTS can be introduced.

---

# 66. Sorting

Supported sort states:

```text
latest
popular
rating
```

The sort input must be allowlisted.

Never allow arbitrary SQL column names from the browser.

Example mapping:

```ts
const SORTS = {
  latest: "created_at DESC",
  popular: "downloads DESC",
  rating: "rating DESC"
};
```

---

# 67. Pagination

The current source uses an unpaginated listing.

The migration should preserve the existing behavior for initial parity.

However, the architecture should support:

```text
?page=1
?page=2
```

once the application catalog becomes large.

Pagination is also recommended to reduce D1 reads and response size.

---

# 68. App Status

Public applications must respect:

```text
published
draft
```

Draft applications must not be publicly visible.

Admin users can see and manage both.

---

# 69. Featured Apps

Featured status must remain:

```text
is_featured
```

Featured applications display the existing visual indicator.

Future homepage sections can use this flag without changing the database.

---

# 70. Download Counter

The existing project maintains a download number.

Migration requirements:

* preserve current number
* increment only on valid download/store request
* prevent abuse as much as practical
* do not increment when target URL is empty
* preserve the same business meaning

Important:

The current session-based anti-double-counting behavior must be replaced with a Worker-compatible mechanism.

Possible strategy:

```text
secure visitor cookie
+
short-lived download event key
+
D1 verification
```

The implementation must be designed so that normal users do not inflate counts merely by refreshing a page.

---

# 71. Website Settings Resolution

Public layout should obtain settings from D1 through a centralized repository.

Example:

```text
getWebsiteSettings()
```

This prevents individual pages from issuing unnecessary queries.

The result can also be cached briefly at the Worker edge.

---

# 72. Settings Cache

Because website settings change rarely:

* D1 remains source of truth.
* Worker cache may hold the resolved settings.
* Admin changes should invalidate the cache.

This reduces repeated D1 reads.

---

# 73. Database Repository Layer

No SQL should be scattered throughout `.astro` UI files.

Use repositories:

```text
AppRepository
CategoryRepository
ServiceRepository
ContactRepository
AdminRepository
SettingsRepository
ReviewRepository
```

For example:

```text
src/lib/db/apps.ts
src/lib/db/categories.ts
src/lib/db/services.ts
src/lib/db/messages.ts
src/lib/db/admins.ts
src/lib/db/settings.ts
src/lib/db/reviews.ts
```

---

# 74. Validation Layer

Validation should be centralized.

Example:

```text
src/lib/validation/app.ts
src/lib/validation/category.ts
src/lib/validation/service.ts
src/lib/validation/contact.ts
src/lib/validation/auth.ts
```

Validation requirements:

* required fields
* string lengths
* email format
* URL format
* enum values
* numeric ranges
* slug validity

---

# 75. Slug Rules

Application, category and service slugs must:

* be unique
* be URL-safe
* use deterministic normalization
* be checked before insert/update

Duplicate slugs must be rejected gracefully.

---

# 76. Admin Form Handling

All admin writes should follow:

```text
Browser
  ↓
POST
  ↓
Authentication
  ↓
CSRF verification
  ↓
Input validation
  ↓
Authorization
  ↓
D1 transaction where needed
  ↓
Activity log
  ↓
Response
```

---

# 77. Activity Logging

The current project does not have a fully implemented logging table, but the new platform should introduce a lightweight `admin_activity_logs` table because Worker-based authentication and administration benefit from auditable operations.

Minimum fields:

```text
id
admin_id
action
entity_type
entity_id
metadata
created_at
```

Sensitive information such as passwords must never be stored.

---

# 78. Transactions

D1 supports transactional database work.

Transactions should be used where multiple writes must remain consistent.

Examples:

### Duplicate application

```text
INSERT copied app
+
new slug
```

### Delete category

If dependent application behavior requires explicit handling, use a transaction where necessary.

### Password migration

Use atomic update semantics.

---

# 79. Error Handling

Production output must never expose:

* SQL error details
* stack traces
* secret values
* Cloudflare bindings
* password hashes

Public response:

```text
Something went wrong. Please try again.
```

Developer logs:

* request ID
* route
* error type
* timestamp
* sanitized context

---

# 80. Environment Configuration

Sensitive configuration must use Cloudflare environment variables/secrets.

Example:

```text
TURNSTILE_SECRET_KEY
TURNSTILE_SITE_KEY
SESSION_SECRET
GOOGLE_REVIEW_API_URL
INDUS_REVIEW_API_URL
SITE_URL
```

No secret should be committed to Git.

The supplied old project contains a `private/credentials.md` file; this must **not** be migrated into the production Astro repository.

---

# 81. Secrets Policy

The migrated project must explicitly exclude:

```text
credentials
passwords
private API keys
database passwords
session secrets
Turnstile private keys
provider tokens
```

from Git.

Use:

```text
.env.example
```

for documentation only.

Actual secrets remain in Cloudflare secret/environment configuration.

---

# 82. Cloudflare Configuration

Target `wrangler.jsonc` should contain bindings for the required resources.

Conceptual structure:

```json
{
  "name": "techily-fly-apps",
  "compatibility_date": "YYYY-MM-DD",
  "d1_databases": [
    {
      "binding": "DB",
      "database_name": "techily-fly-apps",
      "database_id": "..."
    }
  ],
  "r2_buckets": [
    {
      "binding": "MEDIA",
      "bucket_name": "techily-fly-media"
    }
  ]
}
```

The actual compatibility date must be set to the deployment environment date according to Astro/Cloudflare guidance. ([docs.astro.build][1])

---

# 83. Astro Configuration

Target Astro configuration:

```text
Astro
+
@astrojs/cloudflare
+
server/on-demand rendering
```

The official adapter currently supports on-demand routes and Cloudflare runtime features; current documentation identifies Cloudflare Workers as the preferred deployment path. ([docs.astro.build][6])

---

# 84. Deployment Architecture

Recommended deployment:

```text
GitHub
   ↓
Cloudflare Workers Builds / deployment
   ↓
astro build
   ↓
wrangler deploy
   ↓
Cloudflare Worker
```

Astro’s current Cloudflare deployment documentation supports this build/deploy workflow. ([docs.astro.build][1])

---

# 85. No PHP Production Runtime

The final system must contain:

* no PHP execution
* no Apache PHP routing
* no PHP sessions
* no PDO
* no MySQL connection
* no phpMyAdmin dependency

phpMyAdmin is only a legacy data-management tool and must not be part of the new runtime.

---

# 86. No MySQL Production Database

After successful migration:

```text
MySQL/MariaDB → D1
```

The production website must use D1 as the database source of truth.

The original SQL dump should be retained separately as a migration backup/archive.

---

# 87. Data Migration Process

Migration stages:

### Stage 1 — Backup

Create verified backups of:

* original `apps/` project
* original SQL dump
* media files
* external URL inventory

### Stage 2 — Schema conversion

Convert MySQL schema to SQLite/D1.

### Stage 3 — Data transformation

Convert:

* enums
* timestamps
* booleans
* decimals
* foreign keys

### Stage 4 — Import

Insert all records into D1.

### Stage 5 — Verification

Compare:

```text
record count
IDs
slugs
settings
URLs
statuses
ratings
download counts
review cache
dates
administrator records
```

---

# 88. Data Integrity Requirement

The migrated database must produce zero unexplained data loss.

For each table:

```text
Source count
=
Target count
```

unless a documented transformation is explicitly approved.

---

# 89. ID Preservation

Existing numeric IDs must be preserved whenever possible.

This is important for:

* application references
* category relations
* review cache
* admin records
* historical links

Do not unnecessarily regenerate IDs.

---

# 90. Current Database Record Summary

The supplied SQL contains records for:

### Admins

At least one existing administrator record.

### Apps

The dump contains the current published application data, including the Techily Fly “TF Plans” application.

### Categories

The current live database includes the `Productivity` category.

### Services

The current database contains:

* Mobile App Development
* Web App Development
* UI/UX Design

### Website settings

The current database contains website branding/contact/social settings.

### Contact messages

The table exists and is managed by the admin panel.

All of this must be migrated.

---

# 91. App Store Link Rules

Each store link has an associated active flag.

The migration must preserve this exact relationship:

```text
link exists
+
active flag
=
button visible/active
```

The application detail page must not display a dead link as an operational button.

---

# 92. Empty-Link Behavior

Current application behavior includes user-friendly messages such as:

* APK not available yet
* Play Store not available yet
* App Store not available yet
* Indus Appstore not available yet
* Amazon Appstore not available yet

Equivalent behavior must remain.

---

# 93. External Links

Store links should open externally using safe target behavior.

Where `target="_blank"` is used, use:

```text
rel="noopener noreferrer"
```

for additional security.

---

# 94. Public Accessibility

The new website must provide:

* semantic HTML
* keyboard navigation
* visible focus
* accessible labels
* meaningful button text
* alt text
* adequate contrast using the approved palette
* responsive form controls
* no mouse-only critical functionality

---

# 95. Responsive Design

Required:

* mobile
* tablet
* laptop
* desktop
* large desktop

The existing responsive intent must be preserved.

---

# 96. Browser Support

Target modern browsers:

* Chrome
* Edge
* Firefox
* Safari

Older unsupported browsers should receive a normal graceful degradation rather than JavaScript-dependent blank pages.

---

# 97. Admin Mobile Support

Admin must also work on mobile.

Required:

* responsive forms
* horizontally scrollable data tables where required
* mobile navigation
* readable buttons
* touch-friendly controls
* confirmation dialogs

---

# 98. Static/Legal Pages

Current generic page routing supports:

```text
privacy-policy
terms-conditions
refund-policy
faq
pricing
```

Migration must preserve these routes and their current page behavior.

Target:

```text
/page/privacy-policy
/page/terms-conditions
/page/refund-policy
/page/faq
/page/pricing
```

Legacy URLs must redirect appropriately.

---

# 99. Newsletter Behavior

The current footer contains a newsletter-looking form but it is currently front-end-only and displays a success alert; there is no newsletter database table in the implemented current schema.

Therefore:

## Parity requirement

Do not falsely represent it as a persisted newsletter system.

Either:

1. preserve the existing front-end interaction exactly, or
2. explicitly add a newsletter feature as a later enhancement.

Do not silently introduce a new database feature during migration.

---

# 100. Icon Strategy

The current project uses Boxicons.

Because the requested visual system restricts fonts, icons should remain independent vector/icon assets and must not introduce another font family as a typography system.

Recommended migration approach:

* preserve Boxicons initially if free/open-source compatibility is confirmed
* otherwise replace with inline SVG icons

No icon choice may introduce new visual brand colors.

---

# 101. API Architecture

Public endpoints:

```text
GET  /api/apps
GET  /api/apps/[id]
GET  /api/apps/slug/[slug]
GET  /api/apps/[id]/reviews
POST /api/contact
GET  /api/download/[id]/[type]
```

Admin endpoints:

```text
POST /api/auth/login
POST /api/auth/logout
GET  /api/admin/session

POST /api/admin/apps
PUT  /api/admin/apps/[id]
DELETE /api/admin/apps/[id]
POST /api/admin/apps/[id]/duplicate

POST /api/admin/categories
PUT  /api/admin/categories/[id]
DELETE /api/admin/categories/[id]

POST /api/admin/services
PUT  /api/admin/services/[id]
DELETE /api/admin/services/[id]

GET /api/admin/messages
GET /api/admin/messages/[id]
DELETE /api/admin/messages/[id]

PUT /api/admin/settings
PUT /api/admin/profile
```

---

# 102. API Response Standard

JSON endpoints should have a consistent pattern:

Success:

```json
{
  "success": true,
  "data": {}
}
```

Error:

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid request."
  }
}
```

Never return stack traces to clients.

---

# 103. API Security

Every admin API must verify authentication on the server.

The frontend must never be considered an authorization boundary.

Example:

```text
Browser says:
"I am admin."

Worker says:
"Prove it using a valid secure session."
```

---

# 104. Authorization Middleware

Use:

```text
src/middleware.ts
```

for global request processing, including:

* session retrieval
* admin route protection
* security headers
* request context
* legacy redirects where appropriate

---

# 105. Admin Route Rule

Any route below:

```text
/admin/*
```

except:

```text
/admin/login
```

must require a valid authenticated administrator session.

---

# 106. Cache Invalidation

When admin changes:

* app
* category
* service
* website settings

the application should invalidate relevant cached content.

Examples:

```text
App update
→ invalidate /apps/{slug}

Settings update
→ invalidate public layout cache

Service update
→ invalidate /services
```

---

# 107. Database Query Optimization

D1 charges/limits are based on rows read/written, making inefficient queries undesirable.

Design rules:

* select only needed columns when practical
* avoid N+1 queries
* join category information with apps
* cache website settings
* cache reviews
* avoid unnecessary dashboard queries
* paginate growing tables

Cloudflare currently includes 5 million D1 rows-read/day and 100,000 rows-written/day on Workers Free. ([Cloudflare Docs][5])

---

# 108. Worker Free Limit Considerations

Cloudflare Workers Free currently provides:

* 100,000 requests/day
* 10 ms CPU time/invocation
* 128 MB memory
* 50 subrequests/request

These constraints must be respected. ([Cloudflare Docs][7])

Therefore:

* avoid heavy synchronous scraping
* avoid CPU-heavy processing
* cache review providers
* don't resize huge images inside request handlers
* don't generate large files synchronously inside Worker requests
* keep administrative operations small

---

# 109. Review Scraping Constraint

The old review system uses Playwright through an external service for Indus App Store.

The new Astro Worker itself should not attempt to execute a full Chromium browser in the Worker request path.

Reasons:

* high CPU/memory requirements
* Worker runtime constraints
* request latency
* unreliable external site scraping

The Worker should consume normalized review API data instead.

---

# 110. R2 and APK Storage

If APK files are eventually stored in R2:

* object name must be non-guessable where appropriate
* public/private access must be deliberate
* metadata should be stored in D1
* large downloads should not be routed through expensive application logic unnecessarily
* use direct or optimized R2 delivery where appropriate

R2's current free storage/operation allocations should be monitored. ([Cloudflare Docs][3])

---

# 111. File Upload Security

For future admin uploads:

* validate MIME type
* validate extension
* validate actual file signature where appropriate
* enforce size limits
* generate safe filenames
* never trust original filename
* store uploads outside application code
* use R2
* prevent executable file types from being interpreted

APK, ZIP and document uploads need special attention.

---

# 112. Admin Delete Confirmation

Every destructive action must require a clear confirmation.

However, the final request should be a POST action and include CSRF verification.

---

# 113. Audit Trail

Administrative actions should be optionally logged:

```text
ADMIN_LOGIN
ADMIN_LOGOUT
APP_CREATE
APP_UPDATE
APP_DELETE
APP_DUPLICATE
CATEGORY_CREATE
CATEGORY_UPDATE
CATEGORY_DELETE
SERVICE_CREATE
SERVICE_UPDATE
SERVICE_DELETE
MESSAGE_DELETE
SETTINGS_UPDATE
PROFILE_UPDATE
PASSWORD_CHANGE
```

---

# 114. Logging

Use Cloudflare/Worker logging for runtime failures.

Application logs must not expose:

* passwords
* session tokens
* full contact message contents unnecessarily
* private secrets

Cloudflare Workers Free currently includes Worker Logs with documented free allowances. ([Cloudflare Docs][2])

---

# 115. Development Environment

Recommended local environment:

```text
Node.js
npm
Astro
Wrangler
Cloudflare local emulation
SQLite/D1 local database
Git
VS Code
```

The local application should not require:

* Apache
* XAMPP
* PHP
* MySQL
* phpMyAdmin

for normal development.

A legacy PHP environment may still be retained temporarily for side-by-side comparison during migration.

---

# 116. Side-by-Side Migration

Recommended migration process:

```text
OLD PHP/MySQL
      │
      │ reference
      ▼
NEW Astro/Cloudflare
```

Both systems should remain available during acceptance testing.

The old production site must not be destroyed until:

* data comparison
* feature comparison
* URL comparison
* security testing
* visual testing
* admin testing
* download testing

are completed.

---

# 117. Migration Phases

## Phase 0 — Discovery

* inspect complete PHP project
* inspect SQL dump
* identify routes
* identify forms
* identify queries
* identify external APIs
* identify assets
* identify current business rules

**Output:** migration inventory.

---

# 118. Phase 1 — Target Foundation

Create:

```text
Astro
TypeScript
Cloudflare adapter
Wrangler
D1 binding
R2 binding
environment configuration
```

The official Astro Cloudflare adapter is the supported integration for this deployment model. ([docs.astro.build][6])

---

# 119. Phase 2 — Database Migration

Convert:

```text
MySQL SQL
→ SQLite/D1 migration files
```

Load:

```text
admins
apps
app_categories
contact_messages
services
website_settings
```

Then validate record-by-record.

---

# 120. Phase 3 — Public UI

Migrate:

* header
* footer
* homepage
* apps list
* app details
* services
* contact
* legal pages

Do not redesign functionality.

---

# 121. Phase 4 — Admin UI

Migrate:

* login
* dashboard
* apps
* categories
* services
* messages
* settings
* profile

---

# 122. Phase 5 — Business Logic

Migrate:

* app filtering
* sorting
* search
* download redirect
* download count
* status rules
* featured logic
* contact handling
* review caching
* admin workflows

---

# 123. Phase 6 — Security

Implement:

* CSRF
* Turnstile
* session security
* rate limiting
* secure cookies
* validation
* security headers
* secret management

---

# 124. Phase 7 — Assets

Optionally move controlled media:

```text
Old uploads
→ R2
```

while preserving external URLs during the first parity release.

---

# 125. Phase 8 — SEO and Legacy URLs

Implement:

* sitemap
* robots
* canonical
* metadata
* Open Graph
* redirects
* legacy route compatibility

---

# 126. Phase 9 — QA

Run complete parity testing against the old system.

---

# 127. Phase 10 — Cutover

Recommended sequence:

```text
Backup
↓
Freeze content edits
↓
Final D1 sync
↓
Final functional test
↓
DNS/route cutover
↓
Monitor
↓
Keep old system as emergency rollback
```

---

# 128. Functional Acceptance Criteria

The migration is not complete until all of the following pass.

## Public

* Home loads
* Apps page loads
* Search works
* Category filter works
* Sort works
* App cards render
* Featured state renders
* Detail pages resolve by slug
* Store links work
* APK links work
* Download counts update
* Reviews load
* Review cache works
* Services display
* Contact form stores messages
* Legal pages work

---

# 129. Admin Acceptance Criteria

* Admin login works
* Existing admin account works
* Logout works
* Dashboard works
* Apps CRUD works
* Duplicate works
* Categories CRUD works
* Services CRUD works
* Messages list works
* Message view works
* Message deletion works
* Settings update works
* Profile update works
* Password update works

---

# 130. Security Acceptance Criteria

* Invalid login fails
* repeated login abuse is rate limited
* unauthenticated admin requests are rejected
* direct admin APIs reject unauthenticated requests
* CSRF attacks fail
* SQL injection tests fail safely
* XSS payloads are escaped
* sensitive cookies are HttpOnly/Secure/SameSite
* secrets are absent from frontend bundles
* database credentials are absent from source

---

# 131. Data Acceptance Criteria

For every migrated table:

```text
source row count = target row count
```

IDs must match.

For every app:

```text
name
slug
developer
version
logo
banner
description
requirements
ratings
downloads
store links
flags
status
dates
cached reviews
```

must match the legacy source.

---

# 132. Visual Acceptance Criteria

The migrated UI must:

* preserve the information architecture
* preserve major interactions
* remain responsive
* use only the required palette
* use only Manrope and Geist Mono
* avoid visual drift
* avoid adding unrelated colors
* avoid introducing another typography family

---

# 133. Accessibility Acceptance Criteria

* keyboard navigation works
* forms have labels
* buttons have accessible names
* links are understandable
* images have alt text
* focus states are visible
* headings follow logical hierarchy
* mobile controls can be operated without a mouse

---

# 134. SEO Acceptance Criteria

For published app:

```text
title exists
description exists
canonical exists
OpenGraph exists
correct slug works
```

No draft application should be indexed.

---

# 135. Performance Acceptance Criteria

Target:

* minimal JS
* cacheable static assets
* no blocking review API call for initial page rendering unless required
* no unnecessary database queries
* optimized HTML
* responsive images

---

# 136. Free-Tier Cost Policy

The project is designed to operate on Cloudflare’s free allowances where practical.

The architecture must not intentionally depend on paid services.

However, the following principle is mandatory:

> **Free tier ≠ unlimited usage.**

Current official Cloudflare documentation establishes usage limits for Workers, D1 and R2. ([Cloudflare Docs][2])

When a limit is reached:

* application behavior must fail gracefully
* there must be no silent data corruption
* D1 daily-limit exhaustion must not create misleading success messages
* review provider exhaustion must not break application pages
* monitoring must make capacity issues visible

---

# 137. Cloudflare Services Selection

## Mandatory

### Astro

Main application framework.

### Cloudflare Workers

Application runtime.

### Cloudflare D1

Primary database.

### Wrangler

Development/deployment CLI.

### Cloudflare DNS/CDN

Domain and edge delivery.

---

# 138. Recommended

### Cloudflare R2

Media/object storage.

### Cloudflare Turnstile

Anti-bot protection.

### Cloudflare Cache

Public response/static caching.

---

# 139. Optional

### Workers KV

May be used only where it provides a clear benefit.

Because the Free plan has daily KV operation limits, D1-backed persistence should remain the default for business-critical data. Current Workers Free KV limits include 100,000 reads/day and 1,000 writes/deletes/day. ([Cloudflare Docs][2])

### Durable Objects

Not required for the initial website.

Do not add architectural complexity without a real requirement.

---

# 140. Why D1 Instead of Another Database

D1 is the closest Cloudflare-native replacement for the current relational MySQL structure.

The current project is relational and relatively small.

It requires:

* tables
* joins
* filtering
* sorting
* foreign keys
* CRUD
* transactions
* indexed lookup by slug

D1 fits these requirements.

---

# 141. Why Astro Instead of a Full SPA

The project is primarily:

* content-driven
* SEO-sensitive
* database-driven
* server-renderable
* admin-oriented
* relatively lightweight

Astro allows the site to remain server-first without turning the entire application into a large client-side SPA.

---

# 142. Why Workers Instead of Pages

Current Astro Cloudflare guidance recommends Workers for new projects, and the current Astro Cloudflare adapter documentation points toward Workers deployment. ([docs.astro.build][1])

Therefore:

> **Target = Cloudflare Workers, not legacy Cloudflare Pages architecture.**

---

# 143. No Tailwind Requirement

Tailwind is not required.

Because the design system is intentionally narrow, plain CSS with:

* design tokens
* reusable classes
* component-scoped styles

can produce a smaller and more controlled UI.

This also reduces unnecessary dependencies.

---

# 144. No Bootstrap Requirement

Bootstrap should not be added.

The current migration should not introduce a generic UI framework that could cause visual drift.

---

# 145. Component Design System

All visual elements should derive from:

```text
TF Graphite
Signal Coral
Cloud Surface
Manrope
Geist Mono
```

Buttons, cards, tables and form controls should share consistent spacing and states.

---

# 146. Spacing System

A predictable spacing scale should be introduced, for example:

```text
4
8
12
16
24
32
48
64
80
```

Use CSS variables rather than arbitrary one-off values.

---

# 147. Border Radius

The project should use a consistent radius system.

Recommended:

```text
small
medium
large
pill
```

Avoid dozens of arbitrary corner-radius values.

---

# 148. Shadows

Use restrained shadows derived from the approved palette.

Avoid colorful shadows that introduce additional colors.

---

# 149. Motion

Animations should be subtle and functional.

Required:

* mobile menu animation
* button hover state
* loading state
* page feedback
* optional card reveal

Avoid animation that harms accessibility.

Respect:

```css
prefers-reduced-motion
```

---

# 150. Admin Table UX

Tables should support:

* responsive scrolling
* clear columns
* status badges
* action buttons
* consistent alignment
* accessible action names

---

# 151. Flash Messages

Admin actions should show:

* success
* validation error
* authorization error
* generic server error

These messages should be visually derived only from the approved palette.

---

# 152. Empty States

Required for:

* no apps
* no services
* no categories
* no messages
* no reviews

Empty states should remain informative rather than appearing as broken pages.

---

# 153. Loading States

Async operations such as reviews should provide a visible loading state.

If the request fails:

```text
Reviews are temporarily unavailable.
```

The application page must still remain usable.

---

# 154. Review Data Normalization

All providers must map to:

```ts
interface AppReview {
  reviewer_name: string;
  rating: number;
  review_text: string;
  date: string;
  source: string;
  avatar?: string;
}
```

This preserves the existing frontend contract.

---

# 155. Review Security

Third-party review content must be treated as untrusted.

Never inject remote review HTML directly into the DOM.

Use text rendering.

---

# 156. External API Timeout

Review providers must have aggressive timeouts.

The website must not wait indefinitely for a remote provider.

---

# 157. Review Failure Strategy

If provider failure occurs:

```text
Cached review exists?
   ↓
YES → show cache
NO  → show graceful empty state
```

Never display a raw API exception.

---

# 158. Admin Settings Color Policy

The current database contains a `primary_color` setting, but the new design system explicitly mandates fixed brand colors.

Therefore:

* the field may remain in the migration database for compatibility,
* but it must not override the new visual system,
* the new application must always use the mandated:

  * `#212121`
  * `#FF7759`
  * `#FAFAFA`

The design system is therefore authoritative.

---

# 159. Data Migration Caveat — Duplicate Settings

The supplied SQL contains more than one `website_settings` record.

The current application specifically uses:

```text
WHERE id = 1
```

for administration.

The migration must preserve the data first and reproduce the current behavior exactly.

A later cleanup may convert the table to a singleton settings record, but that should only happen after the parity phase.

---

# 160. Legacy Documentation Handling

The supplied Git repository itself contains historical project documentation.

Not all historical documentation describes the current executable application.

Therefore:

```text
Executable code
+
current SQL
=
source of truth
```

Historical PRDs and future-feature documents are references, not evidence that the corresponding feature currently exists.

---

# 161. Git Migration Strategy

The new repository should not blindly copy:

```text
.git/
```

from the legacy ZIP.

Instead:

1. create a clean repository
2. copy only required source/assets
3. create new commit history
4. add `.gitignore`
5. exclude secrets/private documentation
6. create documented migration commits

---

# 162. `.gitignore`

Must include:

```text
node_modules/
dist/
.wrangler/
.env
.env.*
!.env.example
.DS_Store
*.log
private/
secrets/
```

Actual required exclusions may be expanded based on the final project.

---

# 163. Testing Strategy

Testing must be divided into:

### Unit testing

* validation
* slug functions
* database repositories
* authorization
* utility functions

### Integration testing

* D1 CRUD
* authentication
* contact submission
* download endpoint
* review caching

### End-to-end testing

* public journeys
* admin journeys

### Regression testing

Compare old vs new behavior.

---

# 164. Critical End-to-End Test Cases

## Public

### Test 1

Open home.

Expected:

* site loads
* correct settings
* correct navigation

### Test 2

Search for known app.

Expected:

* correct app returned

### Test 3

Filter by Productivity.

Expected:

* correct category results

### Test 4

Sort by Rating.

Expected:

* correct order

### Test 5

Open app detail.

Expected:

* correct record

### Test 6

Click APK.

Expected:

* counter/business rule executes
* final URL works

### Test 7

Open services.

Expected:

* active services only

### Test 8

Submit contact.

Expected:

* saved in D1
* confirmation shown

---

# 165. Admin End-to-End Tests

### Login

Expected:

* existing admin logs in

### Invalid login

Expected:

* access denied

### Create app

Expected:

* record appears publicly if published

### Draft app

Expected:

* hidden publicly

### Duplicate app

Expected:

* unique slug
* draft state

### Edit category

Expected:

* filter updates

### Delete service

Expected:

* service disappears from public list

### Message

Expected:

* admin can view and delete

### Settings

Expected:

* public header/footer changes

### Password

Expected:

* new password works
* old password stops working

---

# 166. Rollback Plan

Rollback must remain possible until migration is proven stable.

Architecture:

```text
Old PHP/MySQL
       +
New Astro/D1
```

The old system remains intact during the validation phase.

If migration fails:

```text
DNS / route
→ Old system
```

No original database should be deleted until final sign-off.

---

# 167. Backup Policy

At minimum before cutover:

* original PHP project ZIP
* original SQL dump
* migrated D1 export/backup
* R2 asset manifest
* configuration manifest

---

# 168. Disaster Recovery

The migration should document:

```text
How to recreate Worker
How to recreate D1
How to restore data
How to configure secrets
How to reconnect R2
How to redeploy Astro
How to restore DNS
```

---

# 169. Documentation Deliverables

The final project must contain:

```text
README.md
DEPLOYMENT.md
DATABASE_MIGRATION.md
ENVIRONMENT.md
SECURITY.md
ARCHITECTURE.md
LEGACY_ROUTES.md
TESTING.md
```

No production secrets.

---

# 170. Deployment Commands

Conceptual workflow:

```bash
npm install
npm run dev
```

Build:

```bash
npm run build
```

Cloudflare preview:

```bash
wrangler dev
```

Deployment:

```bash
wrangler deploy
```

The precise scripts shall be defined in `package.json`.

Astro's current Cloudflare documentation uses Astro build plus Wrangler deployment for Workers. ([docs.astro.build][1])

---

# 171. Database Deployment

Migration files should be versioned.

Example:

```text
migrations/
  0001_initial.sql
  0002_admin_sessions.sql
  0003_activity_logs.sql
```

D1 migration state must be reproducible.

No production-only hand edits.

---

# 172. Seed Data

A separate seed process should reproduce:

* website settings
* categories
* services
* admin data

but production migration should import real current data rather than development dummy records.

---

# 173. Migration Script

A dedicated script should:

1. Parse source SQL/data.
2. Convert records.
3. generate D1-compatible inserts.
4. preserve IDs.
5. validate counts.
6. optionally export a migration report.

Example:

```text
scripts/migrate-data/
```

---

# 174. Migration Report

The migration process should output something like:

```text
Admins:
Source: 1
Target: 1
PASS

Apps:
Source: X
Target: X
PASS

Categories:
Source: X
Target: X
PASS

Services:
Source: X
Target: X
PASS

Contact Messages:
Source: X
Target: X
PASS

Website Settings:
Source: X
Target: X
PASS
```

No deployment should proceed with unexplained mismatches.

---

# 175. Production Domain

The existing domain should point to Cloudflare.

DNS should be managed in Cloudflare.

Cloudflare should provide:

* DNS
* HTTPS
* edge caching
* Worker routing

---

# 176. Production Environment Separation

Use at least:

```text
development
preview
production
```

Each environment should have its own appropriate bindings/resources.

Do not point local development directly at production D1.

---

# 177. D1 Database Separation

Recommended:

```text
techily-fly-apps-dev
techily-fly-apps-preview
techily-fly-apps-production
```

This avoids accidental production writes.

---

# 178. R2 Bucket Separation

Recommended:

```text
techily-fly-media-dev
techily-fly-media-preview
techily-fly-media-production
```

---

# 179. Review Provider Separation

Provider URLs should be environment-configured.

Development can use:

```text
mock provider
```

so local development does not repeatedly trigger real external services.

---

# 180. Security of Review Proxy

The public browser should preferably call:

```text
/api/apps/{id}/reviews
```

rather than directly exposing third-party provider architecture.

This allows:

* caching
* validation
* provider replacement
* error handling
* rate control

---

# 181. No Hidden Dependency

The core website must continue functioning when:

* Google review provider is down
* Indus review provider is down
* R2 asset is temporarily unavailable
* review cache is empty

Only the affected feature should degrade.

---

# 182. Production Readiness Definition

The migration is production-ready only when:

```text
Functional parity
+
Data parity
+
Security testing
+
URL compatibility
+
Responsive UI
+
Cloudflare deployment
+
Error handling
+
Backup/rollback
=
PASS
```

---

# 183. Non-Goals for Version 1

The following are explicitly outside the first migration unless separately approved:

* customer accounts
* customer dashboard
* crypto payments
* subscriptions
* e-commerce
* portfolio CMS
* blog CMS
* newsletter database
* quote management
* public registration
* multi-admin roles
* full analytics dashboard
* AI integration
* mobile app
* PWA
* CRM
* affiliate system
* multilingual system
* payment gateway

These can be layered onto the new architecture later.

---

# 184. Future Expansion Strategy

The new architecture should make future modules additive rather than requiring another technology migration.

Possible later additions:

```text
User authentication
RBAC
Blog
Portfolio
Testimonials
FAQ CMS
Newsletter
Quote requests
Media manager
SEO CMS
Analytics
Notifications
REST API
PWA
AI features
Developer APIs
```

---

# 185. Final Target Stack

## Frontend

```text
Astro
TypeScript
HTML
CSS
minimal JavaScript
```

## Typography

```text
Manrope
Geist Mono
```

## Design tokens

```text
#212121
#FF7759
#FAFAFA
```

## Backend/runtime

```text
Cloudflare Workers
Astro Cloudflare Adapter
```

## Database

```text
Cloudflare D1
```

## File/object storage

```text
Cloudflare R2
```

## Security

```text
Cloudflare Turnstile
HttpOnly cookies
CSRF
server-side validation
prepared D1 statements
rate limiting
security headers
```

## Deployment

```text
Wrangler
Cloudflare Workers
Cloudflare DNS
GitHub
```

No PHP.

No MySQL.

No Apache.

No shared PHP hosting.

No paid CMS.

---

# 186. Final Architecture Summary

```text
                         TECHILY FLY APPS
                                │
                                ▼
                    ┌──────────────────────┐
                    │  Cloudflare DNS/CDN  │
                    └──────────┬───────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │ Astro + Worker       │
                    │ TypeScript Runtime   │
                    └──────┬──────┬────────┘
                           │      │
                ┌──────────┘      └─────────────┐
                ▼                               ▼
       ┌────────────────┐              ┌────────────────┐
       │ Cloudflare D1  │              │ Cloudflare R2  │
       │ relational DB  │              │ media/storage  │
       └────────────────┘              └────────────────┘
                │
                ▼
       ┌─────────────────────┐
       │ Cache / Review Data │
       └──────────┬──────────┘
                  │
        ┌─────────┴─────────┐
        ▼                   ▼
 Google Review API    Indus Review API

                +

             Turnstile

                +

       Secure Admin Sessions
```

---

# 187. Definition of Done

The project is considered successfully migrated when all of the following are true:

* [ ] Current PHP website has been fully inventoried.
* [ ] Current SQL dump has been converted to D1 schema.
* [ ] Existing data has been imported.
* [ ] Existing IDs are preserved where possible.
* [ ] Public homepage works.
* [ ] Applications listing works.
* [ ] Search works.
* [ ] Category filtering works.
* [ ] Sorting works.
* [ ] Application detail pages work.
* [ ] Download/store routing works.
* [ ] Download counts work.
* [ ] Review caching works.
* [ ] Services page works.
* [ ] Contact form works.
* [ ] Admin login works with the existing account.
* [ ] Admin sessions are secure.
* [ ] Admin dashboard works.
* [ ] Application CRUD works.
* [ ] Application duplication works.
* [ ] Category CRUD works.
* [ ] Service CRUD works.
* [ ] Message management works.
* [ ] Website settings work.
* [ ] Admin profile works.
* [ ] Password change works.
* [ ] Legacy URLs are handled.
* [ ] SEO metadata exists.
* [ ] Sitemap works.
* [ ] Robots.txt works.
* [ ] Mobile navigation works.
* [ ] Light/dark mode works.
* [ ] Only approved brand colors are used.
* [ ] Only Manrope and Geist Mono are used.
* [ ] No PHP remains in production runtime.
* [ ] No MySQL remains in production runtime.
* [ ] Secrets are protected.
* [ ] CSRF is implemented.
* [ ] Turnstile protection is implemented where required.
* [ ] Rate limiting is implemented for sensitive endpoints.
* [ ] D1 data has passed parity checks.
* [ ] R2 assets, where used, have passed validation.
* [ ] Production deployment works through Cloudflare Workers.
* [ ] Rollback procedure has been tested.
* [ ] Documentation has been completed.

---

# 188. Final Product Principle

The migration should follow this rule throughout the project:

> **Do not rebuild the website from memory. Reproduce the existing product from its actual source code and database, then replace only the underlying technology.**

The result should feel like the same Techily Fly Apps website to the visitor and the same management system to the administrator, while underneath it has moved from:

```text
PHP + MySQL + PHP Sessions + Shared Hosting
```

to:

```text
Astro + TypeScript
        +
Cloudflare Workers
        +
Cloudflare D1
        +
Cloudflare R2
        +
Cloudflare Turnstile
        +
Wrangler
```

with the mandatory design system:

```text
TF Graphite   #212121
Signal Coral  #FF7759
Cloud Surface #FAFAFA

Manrope
Geist Mono
```

This architecture provides a clean foundation for keeping the current application intact while allowing future Techily Fly products and modules to be added without another complete platform rewrite.

---

## 189. Migration Priority Order

The implementation team should execute the work in exactly this priority:

```text
P0 — Source audit
P0 — D1 schema/data migration
P0 — Authentication
P0 — Public pages
P0 — Admin CRUD
P0 — Download system
P0 — Contact system
P0 — Review/cache system
P0 — Security
P0 — Legacy URL compatibility

P1 — R2 asset migration
P1 — SEO improvements
P1 — Performance tuning
P1 — Activity logging
P1 — Admin UX improvements

P2 — Future CMS modules
P2 — Public user accounts
P2 — Advanced analytics
P2 — APIs
P2 — PWA/mobile features
```

---

# 190. Technology Decision

**Approved target architecture for this migration:**

> **Astro + TypeScript + Cloudflare Workers + Cloudflare D1 + Cloudflare R2 + Cloudflare Turnstile + Wrangler, using only Manrope and Geist Mono and only #212121, #FF7759 and #FAFAFA as the core visual palette.**

The supplied application should be migrated as a **functional parity project first**, followed by controlled modernization and future feature expansion.

[1]: https://docs.astro.build/en/guides/deploy/cloudflare/?utm_source=chatgpt.com "Deploy your Astro Site to Cloudflare | Docs"
[2]: https://developers.cloudflare.com/workers/platform/pricing/?utm_source=chatgpt.com "Pricing · Cloudflare Workers docs"
[3]: https://developers.cloudflare.com/r2/pricing/?utm_source=chatgpt.com "Pricing · Cloudflare R2 docs"
[4]: https://developers.cloudflare.com/turnstile/plans/?utm_source=chatgpt.com "Cloudflare Turnstile plans · Cloudflare Turnstile docs"
[5]: https://developers.cloudflare.com/d1/platform/pricing/?utm_source=chatgpt.com "Pricing · Cloudflare D1 docs"
[6]: https://docs.astro.build/en/guides/integrations-guide/cloudflare/?utm_source=chatgpt.com "@astrojs/cloudflare | Docs"
[7]: https://developers.cloudflare.com/workers/platform/limits/?utm_source=chatgpt.com "Limits · Cloudflare Workers docs"
