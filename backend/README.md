# Creme Backend API

Express + TypeScript backend for Creme Bakery website.

## Features

- RESTful API for background image management
- SQLite database (no setup required!)
- Image upload with Multer
- TypeScript for type safety

## Project Structure

```
backend/
├── src/
│   ├── config/
│   │   └── database.ts      # SQLite database connection
│   ├── controllers/
│   │   └── image.controller.ts  # Image business logic
│   ├── middleware/
│   │   └── upload.middleware.ts  # File upload config
│   ├── routes/
│   │   └── image.routes.ts      # API routes
│   └── server.ts                # Express app entry
├── database/
│   └── schema.sql               # SQLite schema (reference)
├── database.sqlite              # SQLite database file (auto-created)
├── uploads/                     # Uploaded images (gitignored)
├── .env.example                 # Environment template
├── package.json
└── tsconfig.json
```

## Setup

### 1. Install Dependencies
```bash
npm install
```

### 2. Run Development Server
```bash
npm run dev
```

**That's it!** SQLite database will be created automatically at `backend/database.sqlite`.

### 3. Build for Production
```bash
npm run build
npm start
```

## API Endpoints

### GET /api/health
Health check endpoint.

**Response:**
```json
{
  "status": "ok",
  "message": "Creme API is running"
}
```

### GET /api/background-image
Get current background image URL.

**Response:**
```json
{
  "imageUrl": "/uploads/background-1234567890.jpg",
  "createdAt": "2024-01-01T00:00:00.000Z"
}
```

### POST /api/background-image
Upload new background image.

**Request:**
- Method: POST
- Content-Type: multipart/form-data
- Body: `image` (file)

**Response:**
```json
{
  "success": true,
  "imageUrl": "/uploads/background-1234567890.jpg",
  "message": "Background image updated successfully"
}
```

## Environment Variables

See `.env.example` for all required variables:

- `PORT` - Server port (default: 3000)
- `UPLOAD_DIR` - Directory for uploaded files (default: ./uploads)
- `MAX_FILE_SIZE` - Max file size in bytes (default: 5242880)

**Note:** SQLite doesn't require any database configuration - it works out of the box!

## Development

```bash
# Watch mode
npm run dev

# Build
npm run build

# Production
npm start
```

## Production Deployment

See `../DEPLOYMENT.md` for complete deployment guide.

Use PM2 to run in production:
```bash
pm2 start dist/server.js --name creme-api
```

