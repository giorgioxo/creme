# Database Setup - Step by Step

## Quick Setup Guide

### Step 1: Open MySQL Command Line

```bash
mysql -u root -p
```
Enter your MySQL root password when prompted.

### Step 2: Create Database and User

Copy and paste these commands in MySQL:

```sql
-- Create database
CREATE DATABASE creme_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create user
CREATE USER 'creme_user'@'localhost' IDENTIFIED BY 'creme_password_123';

-- Grant privileges
GRANT ALL PRIVILEGES ON creme_db.* TO 'creme_user'@'localhost';

-- Apply changes
FLUSH PRIVILEGES;

-- Verify
SHOW DATABASES;
```

You should see `creme_db` in the list.

### Step 3: Exit MySQL

```sql
EXIT;
```

### Step 4: Import Database Schema

From the `backend` folder:

```bash
mysql -u creme_user -p creme_db < database/schema.sql
```

Enter password: `creme_password_123` (or whatever you set)

### Step 5: Update .env File

Open `backend/.env` and make sure it has:

```env
DB_HOST=localhost
DB_PORT=3306
DB_USER=creme_user
DB_PASSWORD=creme_password_123
DB_NAME=creme_db
```

**Important:** Replace `creme_password_123` with the password you used in Step 2!

### Step 6: Restart Backend

```bash
# Stop current server (Ctrl+C)
# Then restart:
npm run dev
```

You should now see:
```
✅ Database connected successfully
```

---

## Verify It Works

### Test 1: Check Database Connection
Backend should show: `✅ Database connected successfully`

### Test 2: Test API
```bash
curl http://localhost:3000/api/background-image
```

Should return:
```json
{"imageUrl":null,"message":"No background image set"}
```

This means database is working! ✅

---

## Troubleshooting

### "Access denied" error?
- Check `.env` file has correct password
- Verify user exists: `SELECT User FROM mysql.user WHERE User='creme_user';`
- Try recreating user (see Step 2)

### "Database doesn't exist" error?
- Run: `CREATE DATABASE creme_db;` again
- Check: `SHOW DATABASES;`

### "Table doesn't exist" error?
- Import schema: `mysql -u creme_user -p creme_db < database/schema.sql`
- Verify: `USE creme_db; SHOW TABLES;`

---

## Windows Specific Notes

If `mysql` command doesn't work:

1. **Find MySQL path:**
   - Usually: `C:\Program Files\MySQL\MySQL Server 8.0\bin\`
   - Or: `C:\xampp\mysql\bin\`

2. **Add to PATH or use full path:**
   ```bash
   "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p
   ```

3. **Or use MySQL Workbench** (GUI tool):
   - Open MySQL Workbench
   - Connect to localhost
   - Run SQL commands from Step 2
   - Import schema file: File → Run SQL Script → select `schema.sql`

---

## Quick Copy-Paste Commands

**For MySQL command line:**
```sql
CREATE DATABASE creme_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'creme_user'@'localhost' IDENTIFIED BY 'creme_password_123';
GRANT ALL PRIVILEGES ON creme_db.* TO 'creme_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

**For terminal (after MySQL setup):**
```bash
cd backend
mysql -u creme_user -p creme_db < database/schema.sql
# Password: creme_password_123
```

