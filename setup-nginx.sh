#!/bin/bash

# Nginx კონფიგურაციის სკრიპტი

DOMAIN="creme.ge"
NGINX_CONFIG="/etc/nginx/sites-available/$DOMAIN"

echo "===================================="
echo "  Nginx კონფიგურაცია"
echo "===================================="
echo ""

# Nginx კონფიგურაციის შექმნა
cat > $NGINX_CONFIG <<EOF
server {
    listen 80;
    listen [::]:80;
    server_name $DOMAIN www.$DOMAIN;

    # Upload size limit
    client_max_body_size 10M;

    # Backend API
    location /api {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
    }

    # Uploads
    location /uploads {
        proxy_pass http://localhost:3000;
        proxy_set_header Host \$host;
    }

    # Frontend (Angular)
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

echo "✓ Nginx კონფიგურაცია შექმნილია: $NGINX_CONFIG"

# საიტის აქტივაცია
ln -sf $NGINX_CONFIG /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

# კონფიგურაციის ტესტი
if nginx -t; then
    echo "✓ Nginx კონფიგურაცია სწორია"
    systemctl reload nginx
    echo "✓ Nginx გადატვირთულია"
else
    echo "✗ Nginx კონფიგურაციაში შეცდომაა!"
    exit 1
fi

echo ""
echo "===================================="
echo "  Nginx კონფიგურაცია დასრულებულია!"
echo "===================================="
echo ""
echo "შემდეგი ნაბიჯი:"
echo "certbot --nginx -d $DOMAIN -d www.$DOMAIN"
echo ""

