#!/bin/bash

echo "===================================="
echo "  Creme Project - Start Script"
echo "===================================="
echo ""

echo "[1/2] Starting Backend..."
cd backend
npm run dev &
BACKEND_PID=$!
cd ..

sleep 3

echo "[2/2] Starting Frontend..."
npm start &
FRONTEND_PID=$!

echo ""
echo "===================================="
echo "  Both servers are starting!"
echo "===================================="
echo "  Backend:  http://localhost:3000"
echo "  Frontend: http://localhost:4200"
echo "===================================="
echo ""
echo "Press Ctrl+C to stop both servers"

# Wait for user interrupt
wait

