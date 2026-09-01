import type { APIRoute } from 'astro';
import { env } from 'cloudflare:workers';

export const POST: APIRoute = async ({ params, cookies, redirect }) => {
  const session = cookies.get('admin_session')?.value;
  if (!session) {
    return redirect('/admin/login');
  }

  const { id } = params;
  if (!id) {
    return redirect('/admin/web-apps');
  }

  const db = env.DB;
  
  try {
    await db.prepare("DELETE FROM web_apps WHERE id = ?").bind(id).run();
  } catch (e) {
    console.error("Failed to delete web app:", e);
  }

  return redirect('/admin/web-apps');
};
