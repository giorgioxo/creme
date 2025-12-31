@echo off
echo ====================================
echo   Creme Database Setup
echo ====================================
echo.

echo Step 1: Opening MySQL...
echo Please run these commands in MySQL:
echo.
echo CREATE DATABASE creme_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
echo CREATE USER 'creme_user'@'localhost' IDENTIFIED BY 'creme_password_123';
echo GRANT ALL PRIVILEGES ON creme_db.* TO 'creme_user'@'localhost';
echo FLUSH PRIVILEGES;
echo EXIT;
echo.
pause

echo.
echo Step 2: Importing schema...
mysql -u creme_user -p creme_db < database\schema.sql

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ====================================
    echo   Database setup complete!
    echo ====================================
    echo.
    echo Now update backend\.env file:
    echo DB_PASSWORD=creme_password_123
    echo.
) else (
    echo.
    echo ====================================
    echo   Error importing schema
    echo ====================================
    echo.
    echo Check:
    echo 1. MySQL is running
    echo 2. User 'creme_user' exists
    echo 3. Password is correct
    echo.
)

pause

