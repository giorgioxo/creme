# Database Setup - Quick Fix

## Problem
```
❌ Database connection failed: Access denied for user 'creme_user'@'localhost'
```

## Solution Options

### Option 1: Setup MySQL (Recommended for full functionality)

#### Step 1: Login to MySQL
```bash
mysql -u root -p
# Enter your MySQL root password
```

#### Step 2: Create Database and User
```sql
CREATE DATABASE creme_db;
CREATE USER 'creme_user'@'localhost' IDENTIFIED BY 'your_secure_password';
GRANT ALL PRIVILEGES ON creme_db.* TO 'creme_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

#### Step 3: Import Schema
```bash
mysql -u creme_user -p creme_db < database/schema.sql
```

#### Step 4: Update .env
```env
DB_PASSWORD=your_secure_password
```

### Option 2: Skip Database for Now (API still works!)

The API will work without MySQL, but:
- ✅ Health endpoint works
- ✅ Image upload works (saves file)
- ⚠️ Image URL won't be saved to database
- ⚠️ Can't retrieve image URL from database

**Just ignore the database error for now** - you can test the API endpoints!

### Option 3: Use Root User (Quick Test Only)

**⚠️ Not recommended for production!**

Update `backend/.env`:
```env
DB_USER=root
DB_PASSWORD=your_root_password
```

---

## Verify Database Connection

After setup, restart backend:
```bash
npm run dev
```

You should see:
```
✅ Database connected successfully
```

Instead of:
```
❌ Database connection failed
```

---

## Test API Without Database

Even without database, you can test:

1. **Health Check:**
   ```bash
   curl http://localhost:3000/api/health
   ```

2. **Get Background Image:**
   ```bash
   curl http://localhost:3000/api/background-image
   ```
   Will return: `{"imageUrl":null,"message":"Database not configured..."}`

The API is working! Database is optional for basic testing.

