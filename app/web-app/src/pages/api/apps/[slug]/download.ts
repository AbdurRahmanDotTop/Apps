import type { APIRoute } from 'astro';
import { env } from "cloudflare:workers";

export const GET: APIRoute = async ({ params, request, redirect, cookies }) => {
  const { slug } = params;
  if (!slug) return new Response('Bad Request', { status: 400 });

  const url = new URL(request.url);
  const type = url.searchParams.get('type') || 'apk';
  const db = env.DB;

  try {
    const app = await db.prepare("SELECT id, apk_download_link, play_store_link, app_store_link, indus_store_link, custom_stores FROM apps WHERE slug = ?").bind(slug).first();
    
    if (!app) return new Response('Not Found', { status: 404 });
    
    let redirectUrl = '';
    let platformColumn = '';
    
    switch (type) {
        case 'playstore': 
          redirectUrl = app.play_store_link as string; 
          platformColumn = 'play_store_downloads';
          break;
        case 'appstore': 
          redirectUrl = app.app_store_link as string; 
          platformColumn = 'app_store_downloads';
          break;
        case 'indus': 
          redirectUrl = app.indus_store_link as string; 
          platformColumn = 'indus_store_downloads';
          break;
        case 'apk': 
          redirectUrl = app.apk_download_link as string; 
          platformColumn = 'apk_downloads';
          break;
        default:
          if (type.startsWith('custom_')) {
            const index = parseInt(type.split('_')[1], 10);
            try {
              const customStores = JSON.parse((app.custom_stores as string) || '[]');
              if (customStores[index]) {
                redirectUrl = customStores[index].url;
                platformColumn = ''; // No dedicated column for custom stores, but 'downloads' will still increment
              }
            } catch(e) {}
          }
          if (!redirectUrl) {
            redirectUrl = app.apk_download_link as string;
            platformColumn = 'apk_downloads';
          }
          break;
    }

    if (!redirectUrl) {
        return new Response('Download link not configured for this store.', { status: 404 });
    }
    
    // Cookie-based tracking to prevent duplicates
    let visitorId = cookies.get('tf_visitor_id')?.value;
    
    if (!visitorId) {
      visitorId = crypto.randomUUID();
      // Set cookie for 1 year
      cookies.set('tf_visitor_id', visitorId, { 
        path: '/', 
        maxAge: 60 * 60 * 24 * 365, 
        httpOnly: true, 
        secure: true,
        sameSite: 'lax'
      });
    }

    // Try to record unique download
    const insertResult = await db.prepare(
      "INSERT OR IGNORE INTO app_downloads_tracking (app_id, platform, visitor_id) VALUES (?, ?, ?)"
    ).bind(app.id, type, visitorId).run();

    // If it was a new unique download, increment the stats in the apps table
    if (insertResult.meta.changes > 0) {
      if (platformColumn) {
        await db.prepare(`UPDATE apps SET downloads = downloads + 1, ${platformColumn} = ${platformColumn} + 1 WHERE id = ?`).bind(app.id).run();
      } else {
        await db.prepare(`UPDATE apps SET downloads = downloads + 1 WHERE id = ?`).bind(app.id).run();
      }
    }

    // Redirect to the actual APK file or external link
    return redirect(redirectUrl, 302);
  } catch (err) {
    console.error('Error tracking download:', err);
    return new Response('Internal Server Error', { status: 500 });
  }
}
