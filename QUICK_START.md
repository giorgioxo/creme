# Quick Start Guide - Creme Project

## 🚀 Local Development Setup

### Step 1: Frontend Setup

```bash
# Install dependencies
npm install

# Start development server
npm start

# Open http://localhost:4200
```

### Step 2: Backend Setup

```bash
# Navigate to backend
cd backend

# Install dependencies
npm install

# Copy environment file
cp env.example .env

# Edit .env file with your settings
# At minimum, set DB_PASSWORD
```

### Step 3: Database Setup

```bash
# Login to MySQL
mysql -u root -p

# Create database and user
CREATE DATABASE creme_db;
CREATE USER 'creme_user'@'localhost' IDENTIFIED BY 'your_password';
GRANT ALL PRIVILEGES ON creme_db.* TO 'creme_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;

# Import schema
mysql -u creme_user -p creme_db < database/schema.sql
```

### Step 4: Start Backend

```bash
# From backend directory
npm run dev

# API will run on http://localhost:3000
```

### Step 5: Test API

```bash
# Health check
curl http://localhost:3000/api/health

# Get background image
curl http://localhost:3000/api/background-image
```

## 📁 Project Structure

```
creme/
├── src/                    # Angular frontend source
│   ├── app/
│   │   ├── feature/        # Feature modules
│   │   ├── shared/         # Shared components
│   │   └── core/           # Core services
│   └── assets/             # Static assets
│
├── backend/                 # Express API
│   ├── src/
│   │   ├── config/         # Database config
│   │   ├── controllers/    # Business logic
│   │   ├── routes/         # API routes
│   │   └── middleware/     # Middleware
│   ├── database/           # SQL schemas
│   └── uploads/            # Uploaded images
│
└── .github/workflows/      # CI/CD pipelines
```

## 🔧 Configuration Files

### Frontend
- `angular.json` - Angular configuration
- `package.json` - Dependencies
- `src/styles.scss` - Global styles with `$cremefont` variable

### Backend
- `backend/.env` - Environment variables (create from env.example)
- `backend/tsconfig.json` - TypeScript config
- `backend/package.json` - Backend dependencies

## 🧪 Testing Locally

1. **Frontend**: `npm start` → http://localhost:4200
2. **Backend**: `cd backend && npm run dev` → http://localhost:3000
3. **Database**: MySQL running on localhost:3306

## 📦 Production Build

### Frontend
```bash
npm run build
# Output: dist/creme/browser/
```

### Backend
```bash
cd backend
npm run build
# Output: dist/
npm start
```

## 🚢 Deployment

See [DEPLOYMENT.md](./DEPLOYMENT.md) for complete VPS deployment guide.

Quick deployment checklist:
- [ ] VPS with Ubuntu 22.04
- [ ] Domain DNS configured (creme.ge)
- [ ] Node.js, MySQL, Nginx installed
- [ ] Backend running with PM2
- [ ] Frontend built and served by Nginx
- [ ] SSL certificate (Let's Encrypt)

## 🐛 Troubleshooting

### Backend won't start
- Check `.env` file exists and has correct values
- Verify MySQL is running: `sudo systemctl status mysql`
- Test database connection: `mysql -u creme_user -p creme_db`

### Frontend build errors
- Clear cache: `rm -rf node_modules/.cache`
- Reinstall: `rm -rf node_modules && npm install`

### API connection errors
- Check CORS settings in backend
- Verify API URL in frontend
- Check backend logs: `pm2 logs creme-api`

## 📚 Next Steps

1. ✅ Frontend structure ready
2. ✅ Backend API ready
3. ✅ Database schema ready
4. ⏳ Connect frontend to API
5. ⏳ Deploy to VPS
6. ⏳ Configure domain

