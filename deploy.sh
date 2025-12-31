#!/bin/bash

# Creme Bakery Deployment Script for Hetzner
# This script automatically deploys the project to the server
# Usage: cd ~/creme && sudo bash deploy.sh

echo "===================================="
echo "  Creme Bakery Deployment Script"
echo "===================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Functions
print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${YELLOW}ℹ${NC} $1"
}

# 1. System update
print_info "Updating system..."
apt update && apt upgrade -y
print_success "System updated"

# 2. Install Node.js
if ! command -v node &> /dev/null; then
    print_info "Installing Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
    apt install -y nodejs
    print_success "Node.js installed: $(node --version)"
else
    print_success "Node.js already installed: $(node --version)"
fi

# 3. Install PM2
if ! command -v pm2 &> /dev/null; then
    print_info "Installing PM2..."
    npm install -g pm2
    print_success "PM2 installed"
else
    print_success "PM2 already installed"
fi

# 4. Install Nginx
if ! command -v nginx &> /dev/null; then
    print_info "Installing Nginx..."
    apt install -y nginx
    systemctl enable nginx
    systemctl start nginx
    print_success "Nginx installed"
else
    print_success "Nginx already installed"
fi

# 5. Firewall configuration
print_info "Configuring firewall..."
ufw allow OpenSSH
ufw allow 'Nginx Full'
ufw allow 3000/tcp
ufw --force enable
print_success "Firewall configured"

# 6. Install Git
if ! command -v git &> /dev/null; then
    print_info "Installing Git..."
    apt install -y git
    print_success "Git installed"
else
    print_success "Git already installed"
fi

# 7. Project directory (current directory or /var/www/creme)
if [ -f "./package.json" ]; then
    PROJECT_DIR="$(pwd)"
    print_info "Project found: $PROJECT_DIR"
elif [ -d "/var/www/creme" ]; then
    PROJECT_DIR="/var/www/creme"
    print_info "Project found: $PROJECT_DIR"
else
    PROJECT_DIR="$(pwd)"
    if [ ! -f "$PROJECT_DIR/package.json" ]; then
        print_error "package.json not found. Please run the script from the project root directory"
        exit 1
    fi
fi
print_success "Project directory: $PROJECT_DIR"

# 8. Install dependencies
if [ -f "$PROJECT_DIR/package.json" ]; then
    print_info "Installing dependencies..."
    cd $PROJECT_DIR
    npm install
    cd backend
    npm install
    print_success "Dependencies installed"
else
    print_error "package.json not found in $PROJECT_DIR"
    print_info "Please upload the project to the server first"
    exit 1
fi

# 9. Create/update .env file (Production configuration)
print_info "Configuring .env file..."
cat > "$PROJECT_DIR/backend/.env" <<EOF
# Server Configuration
PORT=3000
NODE_ENV=production

# Production Domain (for CORS and API URLs)
DOMAIN=creme.ge
FRONTEND_URL=https://creme.ge

# SQLite Database
# Database file will be created automatically at: backend/database.sqlite
# No configuration needed - SQLite works out of the box!

# File Upload
UPLOAD_DIR=./uploads
MAX_FILE_SIZE=5242880
EOF
print_success ".env file configured for production"

# 10. Build
print_info "Building project..."
cd $PROJECT_DIR
npm run build:all

# Copy frontend dist to backend/dist (if not already done)
if [ -d "$PROJECT_DIR/dist" ] && [ ! -f "$PROJECT_DIR/backend/dist/index.html" ]; then
    print_info "Copying frontend dist to backend/dist..."
    cp -r $PROJECT_DIR/dist/* $PROJECT_DIR/backend/dist/ 2>/dev/null || true
fi
print_success "Build completed"

# 10.1. Create Logs and Uploads directories
print_info "Creating Logs and Uploads directories..."
mkdir -p $PROJECT_DIR/logs
mkdir -p $PROJECT_DIR/backend/uploads
chmod 755 $PROJECT_DIR/backend/uploads
print_success "Directories created"

# 11. Start with PM2
print_info "Starting with PM2..."
cd $PROJECT_DIR
pm2 stop creme-backend 2>/dev/null || true
pm2 delete creme-backend 2>/dev/null || true
pm2 start ecosystem.config.js
pm2 save
print_success "Started with PM2"

# 12. PM2 startup
print_info "Configuring PM2 startup..."
pm2 startup | tail -1 | bash || true
print_success "PM2 startup configured"

# 13. Nginx configuration
print_info "Configuring Nginx..."
if [ -f "$PROJECT_DIR/setup-nginx.sh" ]; then
    chmod +x $PROJECT_DIR/setup-nginx.sh
    sudo bash $PROJECT_DIR/setup-nginx.sh
    print_success "Nginx configured"
else
    print_error "setup-nginx.sh not found"
fi

echo ""
echo "===================================="
print_success "Deployment completed!"
echo "===================================="
echo ""
echo "Next steps:"
echo ""
echo "1. Install SSL certificate (optional):"
echo "   sudo apt install certbot python3-certbot-nginx -y"
echo "   sudo certbot --nginx -d creme.ge -d www.creme.ge"
echo ""
echo "2. Verify deployment:"
echo "   pm2 status"
echo "   pm2 logs creme-backend"
echo "   curl http://localhost:3000/api/health"
echo ""
echo "3. Website should be available at: http://creme.ge"
echo ""

