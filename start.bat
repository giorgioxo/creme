@echo off
echo ====================================
echo   Creme Project - Start Script
echo ====================================
echo.

echo [1/2] Starting Backend...
start "Creme Backend" cmd /k "cd backend && npm run dev"

timeout /t 3 /nobreak >nul

echo [2/2] Starting Frontend...
start "Creme Frontend" cmd /k "npm start"

echo.
echo ====================================
echo   Both servers are starting!
echo ====================================
echo   Backend:  http://localhost:3000
echo   Frontend: http://localhost:4200
echo ====================================
echo.
pause

