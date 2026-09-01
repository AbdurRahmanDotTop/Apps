import type { APIRoute } from 'astro';

const VALID_TYPES = ['playstore', 'appstore', 'indus', 'amazon', 'apk'];

export const GET: APIRoute = async ({ params, locals }) => {
  const { id, type } = params;

  if (!id || !type || !VALID_TYPES.includes(type)) {
    return new Response("Invalid request", { status: 400 });
  }

  // @ts-ignore
  const db = locals.runtime.env.DB;

  try {
    // 1. Fetch the app record
    const app = await db
      .prepare(`SELECT * FROM apps WHERE id = ? AND status = 'published'`)
      .bind(id)
      .first();

    if (!app) {
      return new Response("App not found", { status: 404 });
    }

    // 2. Check if the specific download type is active and get the URL
    let destinationUrl = '';
    
    switch(type) {
      case 'playstore':
        if (!app.is_play_store_active || !app.play_store_link) return new Response("Not available", { status: 404 });
        destinationUrl = app.play_store_link;
        break;
      case 'appstore':
        if (!app.is_app_store_active || !app.app_store_link) return new Response("Not available", { status: 404 });
        destinationUrl = app.app_store_link;
        break;
      case 'indus':
        if (!app.is_indus_store_active || !app.indus_store_link) return new Response("Not available", { status: 404 });
        destinationUrl = app.indus_store_link;
        break;
      case 'amazon':
        if (!app.is_amazon_store_active || !app.amazon_store_link) return new Response("Not available", { status: 404 });
        destinationUrl = app.amazon_store_link;
        break;
      case 'apk':
        if (!app.is_apk_active || !app.apk_download_link) return new Response("Not available", { status: 404 });
        destinationUrl = app.apk_download_link;
        break;
    }

    // 3. Increment the download counter for the app
    await db
      .prepare(`UPDATE apps SET downloads = downloads + 1 WHERE id = ?`)
      .bind(id)
      .run();

    // 4. Redirect to the final URL
    return new Response(null, {
      status: 302,
      headers: {
        Location: destinationUrl
      }
    });

  } catch (err) {
    console.error("Download router error", err);
    return new Response("Internal Server Error", { status: 500 });
  }
};
