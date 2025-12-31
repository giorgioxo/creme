# Creme Deployment Guide

Complete step-by-step guide to deploy Angular + Express + MySQL on VPS.

## Prerequisites

- VPS with Ubuntu 22.04 (Hetzner Cloud)
- Domain name: creme.ge
- SSH access to VPS

---

## Step 1: VPS Initial Setup

### 1.1 Connect to VPS
```bash
ssh root@your-vps-ip
```

### 1.2 Update System
```bash
apt update && apt upgrade -y
```

### 1.3 Create Non-Root User (Recommended)
```bash
adduser creme
usermod -aG sudo creme
su - creme
```

---

## Step 2: Install Node.js

### 2.1 Install Node.js 20.x
```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
```

### 2.2 Verify Installation
```bash
node --version  # Should show v20.x.x
npm --version
```

---

## Step 3: Install MySQL

### 3.1 Install MySQL
```bash
sudo apt install mysql-server -y
```

### 3.2 Secure MySQL
```bash
sudo mysql_secure_installation
```
Follow prompts:
- Set root password
- Remove anonymous users: Yes
- Disallow root login remotely: Yes
- Remove test database: Yes
- Reload privilege tables: Yes

### 3.3 Create Database and User
```bash
sudo mysql -u root -p
```

In MySQL:
```sql
CREATE DATABASE creme_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'creme_user'@'localhost' IDENTIFIED BY 'your_secure_password';
GRANT ALL PRIVILEGES ON creme_db.* TO 'creme_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

### 3.4 Import Database Schema
```bash
mysql -u creme_user -p creme_db < backend/database/schema.sql
```

---

## Step 4: Install Nginx

### 4.1 Install Nginx
```bash
sudo apt install nginx -y
```

### 4.2 Start and Enable Nginx
```bash
sudo systemctl start nginx
sudo systemctl enable nginx
```

---

## Step 5: Deploy Backend

### 5.1 Clone Repository (or upload files)
```bash
cd /var/www
sudo mkdir creme
sudo chown $USER:$USER creme
cd creme
# Upload your backend folder here
```

### 5.2 Install Backend Dependencies
```bash
cd backend
npm install
```

### 5.3 Configure Environment
```bash
cp .env.example .env
nano .env
```

Update `.env`:
```env
PORT=3000
NODE_ENV=production

DB_HOST=localhost
DB_PORT=3306
DB_USER=creme_user
DB_PASSWORD=your_secure_password
DB_NAME=creme_db

UPLOAD_DIR=/var/www/creme/backend/uploads
MAX_FILE_SIZE=5242880
```

### 5.4 Create Uploads Directory
```bash
mkdir -p uploads
chmod 755 uploads
```

### 5.5 Build Backend
```bash
npm run build
```

### 5.6 Install PM2
```bash
sudo npm install -g pm2
```

### 5.7 Start Backend with PM2
```bash
pm2 start dist/server.js --name creme-api
pm2 save
pm2 startup
```

---

## Step 6: Deploy Frontend

### 6.1 Build Angular App
On your local machine:
```bash
cd /path/to/creme
npm run build
```

### 6.2 Upload to VPS
```bash
scp -r dist/creme/browser/* creme@your-vps-ip:/var/www/creme/frontend/
```

Or use Git:
```bash
# On VPS
cd /var/www/creme
git clone your-repo-url .
cd frontend
npm install
npm run build
```

### 6.3 Set Permissions
```bash
sudo chown -R www-data:www-data /var/www/creme/frontend
```

---

## Step 7: Configure Nginx

### 7.1 Create Nginx Config
```bash
sudo nano /etc/nginx/sites-available/creme.ge
```

Paste this configuration:
```nginx
server {
    listen 80;
    server_name creme.ge www.creme.ge;

    # Frontend (Angular)
    root /var/www/creme/frontend;
    index index.html;

    # Serve Angular app
    location / {
        try_files $uri $uri/ /index.html;
    }

    # API Proxy
    location /api {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }

    # Serve uploaded images
    location /uploads {
        alias /var/www/creme/backend/uploads;
        expires 30d;
        add_header Cache-Control "public, immutable";
    }

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
}
```

### 7.2 Enable Site
```bash
sudo ln -s /etc/nginx/sites-available/creme.ge /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

---

## Step 8: Domain Setup

### 8.1 Configure DNS
In your domain registrar (creme.ge), add A records:
```
Type: A
Name: @
Value: your-vps-ip
TTL: 3600

Type: A
Name: www
Value: your-vps-ip
TTL: 3600
```

### 8.2 Wait for DNS Propagation
```bash
# Test DNS
nslookup creme.ge
```

---

## Step 9: SSL with Let's Encrypt

### 9.1 Install Certbot
```bash
sudo apt install certbot python3-certbot-nginx -y
```

### 9.2 Get SSL Certificate
```bash
sudo certbot --nginx -d creme.ge -d www.creme.ge
```

Follow prompts:
- Email: your email
- Agree to terms: Yes
- Redirect HTTP to HTTPS: Yes

### 9.3 Auto-Renewal
Certbot sets up auto-renewal automatically. Test:
```bash
sudo certbot renew --dry-run
```

---

## Step 10: Firewall Configuration

### 10.1 Configure UFW
```bash
sudo ufw allow OpenSSH
sudo ufw allow 'Nginx Full'
sudo ufw enable
sudo ufw status
```

---

## Step 11: Verify Deployment

### 11.1 Check Services
```bash
# Check Nginx
sudo systemctl status nginx

# Check PM2
pm2 status
pm2 logs creme-api

# Check MySQL
sudo systemctl status mysql
```

### 11.2 Test API
```bash
curl http://localhost:3000/api/health
```

### 11.3 Test Frontend
Visit: `https://creme.ge`

---

## Maintenance Commands

### Restart Backend
```bash
pm2 restart creme-api
```

### View Backend Logs
```bash
pm2 logs creme-api
```

### Restart Nginx
```bash
sudo systemctl restart nginx
```

### Update Frontend
```bash
cd /var/www/creme/frontend
git pull
npm install
npm run build
sudo systemctl reload nginx
```

### Update Backend
```bash
cd /var/www/creme/backend
git pull
npm install
npm run build
pm2 restart creme-api
```

---

## Troubleshooting

### Backend not starting
```bash
pm2 logs creme-api
# Check .env file
# Check database connection
```

### Nginx 502 Bad Gateway
- Check if backend is running: `pm2 status`
- Check backend logs: `pm2 logs creme-api`
- Verify port 3000 is not blocked

### Database connection error
- Verify MySQL is running: `sudo systemctl status mysql`
- Check credentials in `.env`
- Test connection: `mysql -u creme_user -p creme_db`

---

## File Structure on VPS

```
/var/www/creme/
├── backend/
│   ├── dist/
│   ├── uploads/
│   ├── .env
│   └── ...
├── frontend/
│   ├── index.html
│   ├── assets/
│   └── ...
└── ...
```

---

## Security Checklist

- [ ] Strong database password
- [ ] Firewall enabled (UFW)
- [ ] SSL certificate installed
- [ ] Non-root user for deployment
- [ ] PM2 auto-start configured
- [ ] Regular backups configured
- [ ] Environment variables secured

---

## Next Steps

1. Test the API endpoint: `GET /api/background-image`
2. Upload a background image: `POST /api/background-image`
3. Update Angular to fetch from API
4. Monitor logs and performance

