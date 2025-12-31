# MySQL Setup Script - ქართული გაიდი
# ეს script დაგეხმარებათ MySQL-ის კონფიგურაციაში

Write-Host "====================================" -ForegroundColor Cyan
Write-Host "  Creme MySQL Database Setup" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""

# შემოწმება: არსებობს თუ არა XAMPP
$xamppPath = "C:\xampp\mysql\bin\mysql.exe"
$mysqlInstalled = $false
$mysqlPath = ""

if (Test-Path $xamppPath) {
    Write-Host "✅ XAMPP MySQL ნაპოვნია!" -ForegroundColor Green
    $mysqlInstalled = $true
    $mysqlPath = $xamppPath
} else {
    # შემოწმება: არსებობს თუ არა MySQL Server
    $mysqlServerPath = "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe"
    if (Test-Path $mysqlServerPath) {
        Write-Host "✅ MySQL Server ნაპოვნია!" -ForegroundColor Green
        $mysqlInstalled = $true
        $mysqlPath = $mysqlServerPath
    } else {
        Write-Host "❌ MySQL არ არის დაყენებული!" -ForegroundColor Red
        Write-Host ""
        Write-Host "გთხოვთ დააინსტალიროთ:" -ForegroundColor Yellow
        Write-Host "  1. XAMPP: https://www.apachefriends.org/" -ForegroundColor Yellow
        Write-Host "  2. ან MySQL: https://dev.mysql.com/downloads/installer/" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "დეტალური ინსტრუქცია: backend/MYSQL_SETUP_GE.md" -ForegroundColor Cyan
        exit 1
    }
}

Write-Host ""
Write-Host "ნაბიჯი 1: პაროლის შეყვანა" -ForegroundColor Cyan
Write-Host "შეიყვანეთ პაროლი რომელსაც გსურთ MySQL-ისთვის" -ForegroundColor Yellow
Write-Host "(რეკომენდებული: creme123)" -ForegroundColor Gray
$password = Read-Host "პაროლი"

if ([string]::IsNullOrWhiteSpace($password)) {
    $password = "creme123"
    Write-Host "დეფოლტ პაროლი გამოყენებულია: creme123" -ForegroundColor Gray
}

Write-Host ""
Write-Host "ნაბიჯი 2: MySQL-ის გახსნა" -ForegroundColor Cyan
Write-Host "ახლა გაიხსნება MySQL terminal..." -ForegroundColor Yellow
Write-Host ""
Write-Host "ჩასვით ეს ბრძანებები MySQL-ში (copy-paste):" -ForegroundColor Cyan
Write-Host ""
Write-Host "CREATE DATABASE creme_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" -ForegroundColor White
Write-Host "CREATE USER 'creme_user'@'localhost' IDENTIFIED BY '$password';" -ForegroundColor White
Write-Host "GRANT ALL PRIVILEGES ON creme_db.* TO 'creme_user'@'localhost';" -ForegroundColor White
Write-Host "FLUSH PRIVILEGES;" -ForegroundColor White
Write-Host "EXIT;" -ForegroundColor White
Write-Host ""
Write-Host "დააჭირეთ Enter რომ გახსნათ MySQL..." -ForegroundColor Yellow
Read-Host

# გახსნა MySQL (root მომხმარებლით)
Start-Process $mysqlPath -ArgumentList "-u", "root" -NoNewWindow -Wait

Write-Host ""
Write-Host "ნაბიჯი 3: Database Schema-ს იმპორტი" -ForegroundColor Cyan
Write-Host "შეიყვანეთ პაროლი რომელიც ზემოთ მითხარით: $password" -ForegroundColor Yellow

$schemaPath = Join-Path $PSScriptRoot "database\schema.sql"
if (Test-Path $schemaPath) {
    & $mysqlPath -u creme_user -p$password creme_db -e "source $schemaPath"
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "✅ Database schema წარმატებით დაიმპორტა!" -ForegroundColor Green
    } else {
        Write-Host ""
        Write-Host "⚠️  შეიძლება ხელით იმპორტი დასჭირდეს" -ForegroundColor Yellow
        Write-Host "შეასრულეთ: $mysqlPath -u creme_user -p creme_db < database\schema.sql" -ForegroundColor Gray
    }
} else {
    Write-Host "❌ schema.sql ფაილი არ მოიძებნა: $schemaPath" -ForegroundColor Red
}

Write-Host ""
Write-Host "ნაბიჯი 4: .env ფაილის განახლება" -ForegroundColor Cyan

$envPath = Join-Path $PSScriptRoot ".env"
if (Test-Path $envPath) {
    $envContent = Get-Content $envPath
    $envContent = $envContent -replace 'DB_PASSWORD=.*', "DB_PASSWORD=$password"
    $envContent | Set-Content $envPath
    Write-Host "✅ .env ფაილი განახლებულია!" -ForegroundColor Green
    Write-Host "   DB_PASSWORD=$password" -ForegroundColor Gray
} else {
    Write-Host "⚠️  .env ფაილი არ არსებობს, შეიქმნება..." -ForegroundColor Yellow
    $examplePath = Join-Path $PSScriptRoot "env.example"
    if (Test-Path $examplePath) {
        Copy-Item $examplePath $envPath
        $envContent = Get-Content $envPath
        $envContent = $envContent -replace 'DB_PASSWORD=.*', "DB_PASSWORD=$password"
        $envContent | Set-Content $envPath
        Write-Host "✅ .env ფაილი შექმნილია!" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "====================================" -ForegroundColor Green
Write-Host "  Setup დასრულდა!" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Green
Write-Host ""
Write-Host "ახლა გაუშვით backend სერვერი:" -ForegroundColor Cyan
Write-Host "  cd backend" -ForegroundColor White
Write-Host "  npm run dev" -ForegroundColor White
Write-Host ""
Write-Host "უნდა ნახოთ: ✅ Database connected successfully" -ForegroundColor Green
Write-Host ""

