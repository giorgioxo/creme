#!/bin/bash

# Creme Bakery Deployment Script for Hetzner
# ეს სკრიპტი ავტომატურად აყენებს პროექტს სერვერზე

set -e  # შეცდომის შემთხვევაში გაჩერება

echo "===================================="
echo "  Creme Bakery Deployment Script"
echo "===================================="
echo ""

# ფერები
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# ფუნქციები
print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${YELLOW}ℹ${NC} $1"
}

# 1. სისტემის განახლება
print_info "სისტემის განახლება..."
apt update && apt upgrade -y
print_success "სისტემა განახლებულია"

# 2. Node.js დაყენება
if ! command -v node &> /dev/null; then
    print_info "Node.js დაყენება..."
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
    apt install -y nodejs
    print_success "Node.js დაყენებულია: $(node --version)"
else
    print_success "Node.js უკვე დაყენებულია: $(node --version)"
fi

# 3. PM2 დაყენება
if ! command -v pm2 &> /dev/null; then
    print_info "PM2 დაყენება..."
    npm install -g pm2
    print_success "PM2 დაყენებულია"
else
    print_success "PM2 უკვე დაყენებულია"
fi

# 4. Nginx დაყენება
if ! command -v nginx &> /dev/null; then
    print_info "Nginx დაყენება..."
    apt install -y nginx
    systemctl enable nginx
    systemctl start nginx
    print_success "Nginx დაყენებულია"
else
    print_success "Nginx უკვე დაყენებულია"
fi

# 5. Firewall კონფიგურაცია
print_info "Firewall კონფიგურაცია..."
ufw allow OpenSSH
ufw allow 'Nginx Full'
ufw allow 3000/tcp
ufw --force enable
print_success "Firewall კონფიგურირებულია"

# 6. Git დაყენება
if ! command -v git &> /dev/null; then
    print_info "Git დაყენება..."
    apt install -y git
    print_success "Git დაყენებულია"
else
    print_success "Git უკვე დაყენებულია"
fi

# 7. პროექტის დირექტორია
PROJECT_DIR="/var/www/creme"
if [ ! -d "$PROJECT_DIR" ]; then
    print_info "პროექტის დირექტორიის შექმნა..."
    mkdir -p $PROJECT_DIR
    print_success "დირექტორია შექმნილია: $PROJECT_DIR"
fi

# 8. დამოკიდებულებების დაყენება
if [ -f "$PROJECT_DIR/package.json" ]; then
    print_info "დამოკიდებულებების დაყენება..."
    cd $PROJECT_DIR
    npm install
    cd backend
    npm install
    print_success "დამოკიდებულებები დაყენებულია"
else
    print_error "package.json ვერ მოიძებნა $PROJECT_DIR-ში"
    print_info "გთხოვთ, პირველად ატვირთოთ პროექტი სერვერზე"
    exit 1
fi

# 9. .env ფაილის შემოწმება
if [ ! -f "$PROJECT_DIR/backend/.env" ]; then
    print_info ".env ფაილის შექმნა..."
    if [ -f "$PROJECT_DIR/backend/env.example" ]; then
        cp $PROJECT_DIR/backend/env.example $PROJECT_DIR/backend/.env
        print_success ".env ფაილი შექმნილია env.example-დან"
        print_info "გთხოვთ, დაარედაქტიროთ $PROJECT_DIR/backend/.env ფაილი"
    else
        print_error "env.example ვერ მოიძებნა"
    fi
else
    print_success ".env ფაილი უკვე არსებობს"
fi

# 10. Build
print_info "პროექტის build-ი..."
cd $PROJECT_DIR
npm run build:all

# Copy frontend dist to backend/dist (if not already done)
if [ -d "$PROJECT_DIR/dist" ] && [ ! -f "$PROJECT_DIR/backend/dist/index.html" ]; then
    print_info "Frontend dist-ის კოპირება backend/dist-ში..."
    cp -r $PROJECT_DIR/dist/* $PROJECT_DIR/backend/dist/ 2>/dev/null || true
fi
print_success "Build დასრულებულია"

# 10.1. Logs და Uploads დირექტორიები
print_info "Logs და Uploads დირექტორიების შექმნა..."
mkdir -p $PROJECT_DIR/logs
mkdir -p $PROJECT_DIR/backend/uploads
chmod 755 $PROJECT_DIR/backend/uploads
print_success "დირექტორიები შექმნილია"

# 11. PM2-ით გაშვება
print_info "PM2-ით გაშვება..."
cd $PROJECT_DIR
pm2 stop creme-backend 2>/dev/null || true
pm2 delete creme-backend 2>/dev/null || true
pm2 start ecosystem.config.js
pm2 save
print_success "PM2-ით გაშვებულია"

# 12. PM2 startup
print_info "PM2 startup კონფიგურაცია..."
pm2 startup | tail -1 | bash || true
print_success "PM2 startup კონფიგურირებულია"

# 13. Nginx კონფიგურაცია
print_info "Nginx კონფიგურაცია..."
if [ -f "$PROJECT_DIR/setup-nginx.sh" ]; then
    chmod +x $PROJECT_DIR/setup-nginx.sh
    sudo bash $PROJECT_DIR/setup-nginx.sh
    print_success "Nginx კონფიგურირებულია"
else
    print_error "setup-nginx.sh ვერ მოიძებნა"
fi

echo ""
echo "===================================="
print_success "დეპლოიმენტი დასრულებულია!"
echo "===================================="
echo ""
echo "შემდეგი ნაბიჯები:"
echo "1. დაარედაქტირეთ $PROJECT_DIR/backend/.env ფაილი:"
echo "   NODE_ENV=production"
echo "   DOMAIN=creme.ge"
echo "   FRONTEND_URL=https://creme.ge"
echo ""
echo "2. AWS Route 53-ზე DNS რეკორდები უკვე გაკეთებულია ✓"
echo ""
echo "3. SSL სერტიფიკატის დაყენება:"
echo "   sudo certbot --nginx -d creme.ge -d www.creme.ge"
echo ""
echo "4. შემოწმება:"
echo "   pm2 status"
echo "   pm2 logs creme-backend"
echo "   curl http://localhost:3000/api/health"
echo ""

