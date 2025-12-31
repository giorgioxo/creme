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
print_success "Build დასრულებულია"

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

echo ""
echo "===================================="
print_success "დეპლოიმენტი დასრულებულია!"
echo "===================================="
echo ""
echo "შემდეგი ნაბიჯები:"
echo "1. დაარედაქტირეთ $PROJECT_DIR/backend/.env ფაილი"
echo "2. დაამატეთ DNS რეკორდები domenebi.ge-ზე"
echo "3. დააყენეთ SSL: certbot --nginx -d creme.ge -d www.creme.ge"
echo "4. შეამოწმეთ: pm2 status"
echo ""

