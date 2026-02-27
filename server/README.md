# PocketRead Server (Cloudflare Workers)

This is the backend service for PocketRead, built on Cloudflare Workers, D1, and R2.

## Prerequisites

- Node.js (v18+)
- Wrangler CLI (`npm install -g wrangler`)
- Cloudflare Account

## Setup

1. Install dependencies:
   ```bash
   npm install
   ```

2. Create Cloudflare resources:
   ```bash
   # Create D1 Database
   npx wrangler d1 create pocketread-db
   # Note the database_id and update wrangler.toml

   # Create R2 Bucket
   npx wrangler r2 bucket create pocketread-books
   ```

3. Update `wrangler.toml`:
   - Replace `database_id` with your actual D1 database ID.

## Development

```bash
npm run dev
```

## Deployment

```bash
npm run deploy
```

## API Endpoints

- `GET /api/status`: Health check.
- `POST /api/sync`: Sync reading progress (Not Implemented).
- `GET /api/books`: List books (Not Implemented).
