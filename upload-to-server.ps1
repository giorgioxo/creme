# PowerShell Script for Uploading Project to Hetzner Server
# ეს სკრიპტი ატვირთავს პროექტს Hetzner სერვერზე

param(
    [Parameter(Mandatory=$true)]
    [string]$ServerIP,
    
    [Parameter(Mandatory=$false)]
    [string]$ServerUser = "root",
    
    [Parameter(Mandatory=$false)]
    [string]$ProjectName = "creme"
)

Write-Host "====================================" -ForegroundColor Cyan
Write-Host "  Creme Project Upload Script" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""

# შემოწმება: არის თუ არა SCP და SSH
if (-not (Get-Command ssh -ErrorAction SilentlyContinue)) {
    Write-Host "✗ SSH არ არის დაყენებული!" -ForegroundColor Red
    Write-Host "გთხოვთ, დააყენოთ OpenSSH:" -ForegroundColor Yellow
    Write-Host "  Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0" -ForegroundColor Yellow
    exit 1
}

# პროექტის არქივირება
Write-Host "📦 პროექტის არქივირება..." -ForegroundColor Yellow
$archiveName = "$ProjectName-$(Get-Date -Format 'yyyyMMdd-HHmmss').zip"

# .gitignore-ის გათვალისწინებით
$excludeItems = @(
    "node_modules",
    ".git",
    "dist",
    "*.log",
    ".angular",
    "backend/node_modules",
    "backend/dist",
    "backend/database.sqlite*",
    "*.zip"
)

try {
    # PowerShell 5.1-ისთვის
    if ($PSVersionTable.PSVersion.Major -lt 7) {
        # ძველი მეთოდი
        $tempDir = Join-Path $env:TEMP "creme-upload"
        if (Test-Path $tempDir) {
            Remove-Item $tempDir -Recurse -Force
        }
        New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
        
        # ფაილების კოპირება
        Get-ChildItem -Path . -Exclude $excludeItems | Copy-Item -Destination $tempDir -Recurse -Force
        
        # ZIP-ის შექმნა
        Compress-Archive -Path "$tempDir\*" -DestinationPath $archiveName -Force
        Remove-Item $tempDir -Recurse -Force
    } else {
        # PowerShell 7+ - უკეთესი მეთოდი
        Compress-Archive -Path .\* -DestinationPath $archiveName -Force
    }
    
    Write-Host "✓ არქივი შექმნილია: $archiveName" -ForegroundColor Green
} catch {
    Write-Host "✗ არქივირების შეცდომა: $_" -ForegroundColor Red
    exit 1
}

# სერვერზე ატვირთვა
Write-Host ""
Write-Host "📤 სერვერზე ატვირთვა..." -ForegroundColor Yellow
Write-Host "   სერვერი: $ServerUser@$ServerIP" -ForegroundColor Gray

try {
    # სერვერზე დირექტორიის შექმნა
    ssh "$ServerUser@$ServerIP" "mkdir -p /var/www/$ProjectName"
    
    # ფაილის ატვირთვა
    scp $archiveName "${ServerUser}@${ServerIP}:/var/www/$ProjectName/"
    
    Write-Host "✓ ფაილი ატვირთულია" -ForegroundColor Green
} catch {
    Write-Host "✗ ატვირთვის შეცდომა: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "შეამოწმეთ:" -ForegroundColor Yellow
    Write-Host "  1. SSH კავშირი მუშაობს: ssh $ServerUser@$ServerIP" -ForegroundColor Yellow
    Write-Host "  2. IP მისამართი სწორია" -ForegroundColor Yellow
    exit 1
}

# სერვერზე გახსნა
Write-Host ""
Write-Host "📂 სერვერზე გახსნა..." -ForegroundColor Yellow

$extractCommands = @"
cd /var/www/$ProjectName
unzip -o $archiveName -d .
rm $archiveName
chmod +x deploy.sh setup-nginx.sh 2>/dev/null || true
echo '✓ პროექტი გახსნილია'
"@

try {
    ssh "$ServerUser@$ServerIP" $extractCommands
    Write-Host "✓ პროექტი გახსნილია სერვერზე" -ForegroundColor Green
} catch {
    Write-Host "✗ გახსნის შეცდომა: $_" -ForegroundColor Red
    exit 1
}

# ადგილობრივი არქივის წაშლა
Write-Host ""
Write-Host "🧹 ადგილობრივი არქივის წაშლა..." -ForegroundColor Yellow
Remove-Item $archiveName -Force
Write-Host "✓ არქივი წაშლილია" -ForegroundColor Green

Write-Host ""
Write-Host "====================================" -ForegroundColor Cyan
Write-Host "  ატვირთვა დასრულებულია!" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "შემდეგი ნაბიჯები:" -ForegroundColor Yellow
Write-Host "  1. სერვერთან დაკავშირება: ssh $ServerUser@$ServerIP" -ForegroundColor White
Write-Host "  2. დეპლოიმენტის სკრიპტის გაშვება: cd /var/www/$ProjectName && ./deploy.sh" -ForegroundColor White
Write-Host "  3. .env ფაილის რედაქტირება: nano backend/.env" -ForegroundColor White
Write-Host ""

