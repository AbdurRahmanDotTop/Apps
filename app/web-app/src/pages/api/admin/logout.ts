import type { APIRoute } from 'astro';

export const GET: APIRoute = async ({ cookies, redirect }) => {
  // Clear the admin_session cookie
  cookies.delete('admin_session', { path: '/' });
  
  // Redirect to login page
  return redirect('/admin/login', 302);
}

// Support POST as well just in case
export const POST: APIRoute = async ({ cookies, redirect }) => {
  cookies.delete('admin_session', { path: '/' });
  return redirect('/admin/login', 302);
}
