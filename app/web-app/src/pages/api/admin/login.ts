import type { APIRoute } from 'astro';
// Note: In a real implementation, you would use a web crypto library for password verification (e.g. bcrypt.js or WebCrypto API)

export const POST: APIRoute = async ({ request, locals, cookies }) => {
  try {
    const formData = await request.formData();
    const username = formData.get('username')?.toString();
    const password = formData.get('password')?.toString();
    const turnstileToken = formData.get('cf-turnstile-response')?.toString();

    if (!username || !password) {
      return new Response("Missing credentials", { status: 400 });
    }

    // Verify Turnstile...

    // @ts-ignore
    const db = locals.runtime.env.DB;

    // Fetch admin user
    const admin = await db
      .prepare(`SELECT * FROM admins WHERE username = ?`)
      .bind(username)
      .first();

    if (!admin) {
      // Return 401 Unauthorized
      return new Response("Invalid credentials", { status: 401 });
    }

    // Verify the existing bcrypt hash
    const isValid = await import('bcrypt-ts').then(bcrypt => bcrypt.compareSync(password, admin.password_hash as string));

    if (isValid) {
      // 1. Generate session token (using crypto.randomUUID for simplicity, real app should use secure RNG)
      const sessionToken = crypto.randomUUID();
      const expiresAt = new Date();
      expiresAt.setHours(expiresAt.getHours() + 12); // 12 hour session

      // 2. Hash token for DB storage
      const tokenHash = sessionToken; // Mock hash

      // 3. Store session in D1
      await db
        .prepare(`
          INSERT INTO admin_sessions (id, admin_id, token_hash, expires_at)
          VALUES (?, ?, ?, ?)
        `)
        .bind(crypto.randomUUID(), admin.id, tokenHash, expiresAt.toISOString())
        .run();

      // 4. Set HttpOnly cookie
      cookies.set('admin_session', sessionToken, {
        path: '/',
        httpOnly: true,
        secure: true,
        sameSite: 'lax',
        expires: expiresAt
      });

      // 5. Redirect to admin dashboard
      return new Response(null, {
        status: 302,
        headers: {
          Location: '/admin'
        }
      });
    } else {
      return new Response("Invalid credentials", { status: 401 });
    }

  } catch (err) {
    console.error("Login error", err);
    return new Response("Internal Server Error", { status: 500 });
  }
};
