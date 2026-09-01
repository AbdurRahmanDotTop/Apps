import { defineMiddleware } from 'astro:middleware';

export const onRequest = defineMiddleware(async (context, next) => {
  const url = new URL(context.request.url);

  // Protect all /admin routes except /admin/login
  if (url.pathname.startsWith('/admin') && url.pathname !== '/admin/login') {
    const adminSession = context.cookies.get('admin_session');
    
    // Check if the cookie exists and equals 'authenticated' (Basic implementation)
    // For production, this should be a JWT or a session ID validated against a DB
    if (!adminSession || adminSession.value !== 'authenticated') {
      return context.redirect('/admin/login');
    }
  }

  // Redirect authenticated users away from the login page
  if (url.pathname === '/admin/login') {
    const adminSession = context.cookies.get('admin_session');
    if (adminSession && adminSession.value === 'authenticated') {
      return context.redirect('/admin');
    }
  }

  return next();
});
