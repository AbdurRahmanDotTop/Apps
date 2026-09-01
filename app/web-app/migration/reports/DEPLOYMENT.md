# Deployment Documentation

## Overview
This document explains the final deployment pipeline and Cloudflare architecture for the migrated application.

## Cloudflare Pages Integration
The application is hosted on **Cloudflare Pages** using the Astro framework and the `@astrojs/cloudflare` adapter. 

### Architecture
```text
Browser 
   ↓
Cloudflare Global Edge Network
   ↓
Cloudflare Pages Worker (Astro SSR)
   ↓
Cloudflare D1 (Database)
```

### Deployment Pipeline
The deployment is entirely automated using the `wrangler` CLI.
1. Code changes are built using `npm run build`.
2. Astro compiles the `.astro` files and generates a serverless Worker bundle in `dist/client/_worker.js`.
3. `npx wrangler pages deploy dist/client --project-name apps` pushes the bundle directly to the Cloudflare Edge network.

### Environment & Bindings
- **Database Binding:** The D1 database is bound to the Astro worker using the variable `DB`. This allows the serverless functions to query SQLite directly via `env.DB.prepare()`.
- **API Tokens:** `CLOUDFLARE_ACCOUNT_ID` and `CLOUDFLARE_API_TOKEN` are utilized by Wrangler for seamless terminal-based deployments.
