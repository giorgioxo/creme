#!/bin/bash

# Production Build Script for Creme
echo "===================================="
echo "  Creme Production Build"
echo "===================================="
echo ""

# Build Frontend
echo "[1/3] Building Frontend..."
npm run build
if [ $? -ne 0 ]; then
    echo "❌ Frontend build failed!"
    exit 1
fi
echo "✅ Frontend build complete"
echo ""

# Build Backend
echo "[2/3] Building Backend..."
cd backend
npm run build
if [ $? -ne 0 ]; then
    echo "❌ Backend build failed!"
    exit 1
fi
cd ..
echo "✅ Backend build complete"
echo ""

# Copy frontend dist to backend (for serving)
echo "[3/3] Copying frontend to backend/dist..."
if [ ! -d "backend/dist" ]; then
    mkdir -p backend/dist
fi
cp -r dist/* backend/dist/ 2>/dev/null || true
echo "✅ Files copied to backend/dist"
echo ""

echo "===================================="
echo "  Build Complete! ✅"
echo "===================================="
echo ""
echo "Next steps:"
echo "1. Configure backend/.env file"
echo "2. Start with: pm2 start ecosystem.config.js"
echo ""

