@echo off
echo ====================================
echo   Creme Production Build
echo ====================================
echo.

REM Build Frontend
echo [1/3] Building Frontend...
call npm run build
if %ERRORLEVEL% NEQ 0 (
    echo Frontend build failed!
    exit /b 1
)
echo Frontend build complete
echo.

REM Build Backend
echo [2/3] Building Backend...
cd backend
call npm run build
if %ERRORLEVEL% NEQ 0 (
    echo Backend build failed!
    exit /b 1
)
cd ..
echo Backend build complete
echo.

REM Copy frontend dist to backend
echo [3/3] Copying frontend to backend...
xcopy /E /I /Y dist\* backend\dist\ >nul 2>&1
echo Files copied
echo.

echo ====================================
echo   Build Complete!
echo ====================================
echo.
echo Next steps:
echo 1. Configure backend\.env file
echo 2. Start with: pm2 start ecosystem.config.js
echo.

