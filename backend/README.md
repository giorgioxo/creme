# Creme Backend API

Express + TypeScript backend for Creme Bakery website.

## Features

- RESTful API for background image management
- MySQL database integration
- Image upload with Multer
- TypeScript for type safety

## Project Structure

```
backend/
├── src/
│   ├── config/
│   │   └── database.ts      # MySQL connection pool
│   ├── controllers/
│   │   └── image.controller.ts  # Image business logic
│   ├── middleware/
│   │   └── upload.middleware.ts  # File upload config
│   ├── routes/
│   │   └── image.routes.ts      # API routes
│   └── server.ts                # Express app entry
├── database/
│   └── schema.sql               # MySQL schema
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

### 2. Configure Environment
```bash
cp .env.example .env
# Edit .env with your database credentials
```

### 3. Setup Database
```bash
mysql -u root -p < database/schema.sql
```

### 4. Run Development Server
```bash
npm run dev
```

### 5. Build for Production
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
- `DB_HOST` - MySQL host
- `DB_PORT` - MySQL port
- `DB_USER` - MySQL username
- `DB_PASSWORD` - MySQL password
- `DB_NAME` - Database name
- `UPLOAD_DIR` - Directory for uploaded files
- `MAX_FILE_SIZE` - Max file size in bytes

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

