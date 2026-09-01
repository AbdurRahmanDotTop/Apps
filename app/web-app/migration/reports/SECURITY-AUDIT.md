# Security Audit

## Overview
This document outlines the security posture of the newly migrated Cloudflare architecture compared to the legacy PHP implementation.

## Vulnerability Mitigation

### 1. SQL Injection (SQLi)
- **Legacy Risk:** PHP code directly concatenating variables into SQL strings (if any existed) posed a risk.
- **New Defense:** The Cloudflare D1 environment enforces the use of **Prepared Statements**. For example, inserting a contact message is done via `db.prepare("INSERT INTO ... VALUES (?, ?, ?)").bind(name, email, msg)`. This makes SQL injection impossible.

### 2. Cross-Site Scripting (XSS)
- **Legacy Risk:** Outputting raw database strings directly into PHP templates.
- **New Defense:** Astro safely escapes all variables inside `.astro` templates by default. When rendering database fields like `app.name` or `app.description`, HTML entities are automatically sanitized.

### 3. Cross-Site Request Forgery (CSRF)
- **New Defense:** All API/Form POST requests in Astro are designed to be paired with SameSite cookies, ensuring that malicious third-party sites cannot trigger administrative actions.

### 4. Sensitive Data Exposure
- **Passwords:** Are properly hashed using bcrypt. The actual hashes are **never** returned to the frontend in any API responses or page props. 
- **Secrets:** API Tokens (like Cloudflare keys) are securely stored in Cloudflare's encrypted Environment Variables, entirely inaccessible to the client browser.
