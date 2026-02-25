# Boonhlua Bot Installation Script for Windows (Stable Version)
$ErrorActionPreference = "Stop"

# 0. Check for Administrator Privileges
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "❌ Error: Please run PowerShell as Administrator!" -ForegroundColor Red
    pause; exit
}
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

Write-Host "`n🚀 Starting Boonhlua Bot Installation..." -ForegroundColor Cyan
Write-Host "---------------------------------------------------"

# 1. Check for Node.js and Git
$rebootRequired = $false

if (!(Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "📥 Node.js not found! Installing..." -ForegroundColor Yellow
    winget install --id OpenJS.NodeJS.LTS -e --source winget
    $rebootRequired = $true
}

if (!(Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "📥 Git not found! Installing..." -ForegroundColor Yellow
    winget install --id Git.Git -e --source winget
    $rebootRequired = $true
}

if ($rebootRequired) {
    Write-Host "`n✅ Base tools installed successfully!" -ForegroundColor Green
    Write-Host "⚠️  Please CLOSE this window and OPEN a new PowerShell to refresh system paths." -ForegroundColor Yellow
    pause; exit
}

# 2. Setup Working Directory
$botPath = "C:\boonhlua_bot"
if (!(Test-Path $botPath)) { 
    New-Item -Path $botPath -ItemType Directory | Out-Null
    Write-Host "📂 Creating directory at: $botPath" -ForegroundColor Gray
}
Set-Location $botPath

# 3. Download Bot Files
Write-Host "📥 Fetching latest files from GitHub..." -ForegroundColor Cyan
try {
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/boonluea/bot_youtybe/main/bunlua.js" -OutFile "bunlua.js" -ErrorAction Stop
} catch {
    Write-Host "❌ Download failed!" -ForegroundColor Red
    pause; exit
}

# 4. Install Dependencies
Write-Host "📦 Installing required libraries (Playwright)..." -ForegroundColor Yellow
if (!(Test-Path "package.json")) { npm init -y | Out-Null }
& npm install playwright --save
& npx playwright install chromium

# 5. Create Executable (.bat)
$batContent = "@echo off`ntitle Boonhlua Bot - Running`ncd /d `"$botPath`"`nnode bunlua.js`npause"
$batContent | Out-File -FilePath "$botPath\start_bot.bat" -Encoding ASCII

# 6. Create Shortcuts (Desktop & Startup)
Write-Host "🖥️  Creating Shortcuts and Auto-start..." -ForegroundColor Yellow
try {
    $WshShell = New-Object -ComObject WScript.Shell
    
    # --- Desktop Shortcut ---
    $DesktopPath = [System.IO.Path]::Combine([Environment]::GetFolderPath("Desktop"), "BoonhluaBot.lnk")
    $ShortcutDesktop = $WshShell.CreateShortcut($DesktopPath)
    $ShortcutDesktop.TargetPath = "$botPath\start_bot.bat"
    $ShortcutDesktop.WorkingDirectory = $botPath
    $ShortcutDesktop.IconLocation = "shell32.dll,13" # Global/Web icon
    $ShortcutDesktop.Save()
    Write-Host "✅ Shortcut created on Desktop." -ForegroundColor Green

    # --- Startup Shortcut (Auto-run) ---
    $StartupPath = [System.IO.Path]::Combine([Environment]::GetFolderPath("Startup"), "BoonhluaBot.lnk")
    $ShortcutStartup = $WshShell.CreateShortcut($StartupPath)
    $ShortcutStartup.TargetPath = "$botPath\start_bot.bat"
    $ShortcutStartup.WorkingDirectory = $botPath
    $ShortcutStartup.Save()
    Write-Host "✅ Auto-start set for Windows Startup." -ForegroundColor Green
} catch {
    Write-Host "⚠️  Warning: Failed to create shortcuts." -ForegroundColor Yellow
}

Write-Host "`n✨ Installation Finished Successfully!" -ForegroundColor Green
Write-Host "📍 Bot Folder: $botPath"
Write-Host "🚀 You can now run the bot from your Desktop!" -ForegroundColor White
Write-Host "---------------------------------------------------"
pause