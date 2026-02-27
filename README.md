# PocketRead - Cross-Platform Novel Reader

A high-performance, self-hosted cross-platform novel reader with seamless sync across devices. Built with Flutter and Cloudflare Workers.

## Project Structure

This is a monorepo containing both the client application and the serverless backend.

- `app/`: Flutter application (Mobile: iOS/Android, Web, Desktop).
- `server/`: Cloudflare Workers backend (API, D1 Database, R2 Storage).
- `docs/`: Project documentation and planning.

## Key Requirements & Validation

Based on the project plan (`docs/跨平台小说阅读器项目规划书.md`) and user validation:

- **Target Audience**: Technical/Geek Users (Self-Hosted). Users will deploy their own backend instance.
- **Sync Strategy**: Last Write Wins (LWW) for MVP conflict resolution.
- **Performance**: Qualitative metrics (smooth experience) for MVP phase.
- **Data Privacy**: All data is stored in user's own Cloudflare D1/R2 instance.

## Prerequisites

- **Flutter SDK**: Required for building the client app.
- **Node.js & npm**: Required for server development.
- **Wrangler CLI**: Required for deploying Cloudflare Workers.

## Getting Started

### Server (Cloudflare Workers)

```bash
cd server
npm install
npm run deploy
```

### Client (Flutter)

```bash
cd app
flutter run
```

For detailed documentation, please refer to the `docs/` directory.
