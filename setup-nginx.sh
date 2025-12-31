#!/bin/bash

# Nginx Configuration Script

DOMAIN="creme.ge"
NGINX_CONFIG="/etc/nginx/sites-available/$DOMAIN"

echo "===================================="
echo "  Nginx Configuration"
echo "===================================="
echo ""

# Create Nginx configuration
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

echo "✓ Nginx configuration created: $NGINX_CONFIG"

# Enable site
ln -sf $NGINX_CONFIG /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

# Test configuration
if nginx -t; then
    echo "✓ Nginx configuration is valid"
    systemctl reload nginx
    echo "✓ Nginx reloaded"
else
    echo "✗ Nginx configuration error!"
    exit 1
fi

echo ""
echo "===================================="
echo "  Nginx Configuration Complete!"
echo "===================================="
echo ""
echo "Next step:"
echo "certbot --nginx -d $DOMAIN -d www.$DOMAIN"
echo ""

