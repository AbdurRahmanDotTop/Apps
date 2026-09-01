import type { APIRoute } from 'astro';
import { env } from "cloudflare:workers";

export const GET: APIRoute = async ({ params }) => {
  const { slug } = params;
  if (!slug) return new Response(JSON.stringify({ error: 'Bad Request' }), { status: 400, headers: { 'Content-Type': 'application/json' } });

  const db = env.DB;

  try {
    // In legacy, reviews might be a stringified array or JSON object inside a cached_reviews column if it existed.
    // For now, we will return some dummy reviews since D1 might not have actual cached reviews yet.
    const dummyReviews = {
        success: true,
        reviews: [
            { reviewer_name: "Rahul K.", rating: 5, review_text: "Amazing application! Everything works perfectly.", source: "Play Store", date: "2 days ago" },
            { reviewer_name: "Sneha Sharma", rating: 4.5, review_text: "Very good but needs a few more features.", source: "Indus App Store", date: "1 week ago" }
        ]
    };
    
    return new Response(JSON.stringify(dummyReviews), {
      status: 200,
      headers: { 'Content-Type': 'application/json' }
    });
  } catch (err) {
    console.error('Error fetching reviews:', err);
    return new Response(JSON.stringify({ error: 'Internal Server Error' }), { status: 500, headers: { 'Content-Type': 'application/json' } });
  }
}
