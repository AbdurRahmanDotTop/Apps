import type { APIRoute } from 'astro';

// Cache TTL in seconds (24 hours as per PRD)
const CACHE_TTL = 86400;

export const GET: APIRoute = async ({ params, locals }) => {
  const { id } = params;

  if (!id) {
    return new Response(JSON.stringify({ error: "Missing app ID" }), { status: 400 });
  }

  // @ts-ignore
  const db = locals.runtime.env.DB;

  try {
    const app = await db
      .prepare(`SELECT cached_reviews, reviews_updated_at FROM apps WHERE id = ?`)
      .bind(id)
      .first();

    if (!app) {
      return new Response(JSON.stringify({ error: "App not found" }), { status: 404 });
    }

    const now = new Date();
    const lastUpdate = app.reviews_updated_at ? new Date(app.reviews_updated_at) : new Date(0);
    const ageSeconds = (now.getTime() - lastUpdate.getTime()) / 1000;

    let reviewsData;

    // Check if cache is fresh
    if (app.cached_reviews && ageSeconds < CACHE_TTL) {
      reviewsData = JSON.parse(app.cached_reviews);
    } else {
      // Cache is stale or missing, attempt to fetch from provider API
      try {
        // Mock external API call for scraping/aggregation
        console.log("Fetching fresh reviews for app", id);
        
        // This is a placeholder. In a real scenario, we would call the 
        // external GooglePlayProvider and IndusStoreProvider APIs here.
        reviewsData = {
          average: 4.5,
          total: 1250,
          items: [
            { source: 'playstore', rating: 5, text: "Great app!", author: "User A" }
          ]
        };

        // Update D1 cache
        await db
          .prepare(`UPDATE apps SET cached_reviews = ?, reviews_updated_at = ? WHERE id = ?`)
          .bind(JSON.stringify(reviewsData), now.toISOString(), id)
          .run();
          
      } catch (providerError) {
        console.error("Failed to fetch fresh reviews, falling back to cache", providerError);
        // Fallback to cache even if stale
        if (app.cached_reviews) {
          reviewsData = JSON.parse(app.cached_reviews);
        } else {
          // No cache and provider failed
          reviewsData = { average: 0, total: 0, items: [] };
        }
      }
    }

    return new Response(JSON.stringify(reviewsData), {
      status: 200,
      headers: {
        'Content-Type': 'application/json',
        'Cache-Control': 'public, max-age=3600' // Short HTTP cache as well
      }
    });

  } catch (err) {
    console.error("Reviews API error", err);
    return new Response(JSON.stringify({ error: "Internal Server Error" }), { status: 500 });
  }
};
