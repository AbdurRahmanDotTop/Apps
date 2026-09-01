import type { APIRoute } from 'astro';

export const POST: APIRoute = async ({ request, locals }) => {
  try {
    const formData = await request.formData();
    const name = formData.get('name')?.toString();
    const email = formData.get('email')?.toString();
    const subject = formData.get('subject')?.toString() || '';
    const message = formData.get('message')?.toString();
    const turnstileToken = formData.get('cf-turnstile-response')?.toString();

    // Basic validation
    if (!name || !email || !message) {
      return new Response(JSON.stringify({ error: "Name, email, and message are required." }), { status: 400 });
    }

    // In a real implementation: Verify turnstileToken with Cloudflare

    // Get D1 Database binding
    // @ts-ignore
    const db = locals.runtime.env.DB;

    // Store in D1
    await db
      .prepare(`
        INSERT INTO contact_messages (name, email, subject, message, status) 
        VALUES (?, ?, ?, ?, 'unread')
      `)
      .bind(name, email, subject, message)
      .run();

    // Redirect to a thank you page or return success JSON
    // Since this is submitted via form POST, redirect back to contact with success flag
    return new Response(null, {
      status: 302,
      headers: {
        Location: '/contact?success=true'
      }
    });
  } catch (err) {
    console.error("Contact form error", err);
    return new Response(JSON.stringify({ error: "Internal Server Error" }), { status: 500 });
  }
};
