
export interface Env {
  DB: D1Database;
  BUCKET: R2Bucket;
}

interface ReadingProgress {
  book_id: string;
  chapter_index: number;
  cfi?: string;
  anchor_text?: string;
  percentage: number;
  device_id: string;
  updated_at: number; // Unix timestamp in seconds or milliseconds
}

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const url = new URL(request.url);
    const path = url.pathname;

    // CORS Headers
    const corsHeaders = {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type, Authorization',
    };

    if (request.method === 'OPTIONS') {
      return new Response(null, { headers: corsHeaders });
    }

    // Basic health check endpoint
    if (path === '/api/status') {
      return new Response(JSON.stringify({ 
        status: 'ok', 
        message: 'PocketRead Server is running',
        timestamp: new Date().toISOString()
      }), {
        headers: { 'content-type': 'application/json', ...corsHeaders },
      });
    }

    // Sync endpoint
    if (path === '/api/sync') {
      if (request.method === 'POST') {
        try {
          const body = await request.json() as { progress: ReadingProgress[] };
          const progressList = body.progress;
          
          if (!progressList || !Array.isArray(progressList)) {
             return new Response('Invalid body', { status: 400, headers: corsHeaders });
          }

          const results = [];
          
          for (const item of progressList) {
            // LWW (Last Write Wins) strategy
            // Check existing timestamp
            const existing = await env.DB.prepare(
              'SELECT updated_at FROM reading_progress WHERE book_id = ?'
            ).bind(item.book_id).first<{ updated_at: number }>();

            if (!existing || item.updated_at > existing.updated_at) {
               await env.DB.prepare(
                `INSERT OR REPLACE INTO reading_progress 
                 (book_id, chapter_index, cfi, anchor_text, percentage, device_id, updated_at) 
                 VALUES (?, ?, ?, ?, ?, ?, ?)`
              ).bind(
                item.book_id, 
                item.chapter_index, 
                item.cfi || null, 
                item.anchor_text || null, 
                item.percentage, 
                item.device_id, 
                item.updated_at
              ).run();
              results.push({ book_id: item.book_id, status: 'updated' });
            } else {
              results.push({ book_id: item.book_id, status: 'skipped_older' });
            }
          }

          return new Response(JSON.stringify({ success: true, results }), {
            headers: { 'content-type': 'application/json', ...corsHeaders },
          });

        } catch (e: any) {
          return new Response(JSON.stringify({ error: e.message }), { status: 500, headers: corsHeaders });
        }
      } else if (request.method === 'GET') {
        // Get all progress or specific book
        const bookId = url.searchParams.get('book_id');
        let query = 'SELECT * FROM reading_progress';
        let stmt;
        
        if (bookId) {
          query += ' WHERE book_id = ?';
          stmt = env.DB.prepare(query).bind(bookId);
        } else {
          stmt = env.DB.prepare(query);
        }

        const { results } = await stmt.all();
        return new Response(JSON.stringify({ progress: results }), {
            headers: { 'content-type': 'application/json', ...corsHeaders },
        });
      }
    }
    
    // Books endpoint
    if (path === '/api/books') {
      if (request.method === 'GET') {
         // Return list of books from D1
         const { results } = await env.DB.prepare('SELECT * FROM books ORDER BY updated_at DESC').all();
         return new Response(JSON.stringify({ books: results }), {
            headers: { 'content-type': 'application/json', ...corsHeaders },
         });
      }
      // TODO: Implement POST for uploading books (metadata to D1, file to R2)
      return new Response(JSON.stringify({ status: 'not_implemented', message: 'Books upload not ready' }), {
        headers: { 'content-type': 'application/json', ...corsHeaders },
      });
    }

    return new Response('Not Found', { status: 404, headers: corsHeaders });
  },
};
