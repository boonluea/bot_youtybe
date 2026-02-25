# Boonhlua Bot Installation Script for Windows (Stable Version)
$ErrorActionPreference = "Stop"

# 0. Check for Administrator Privileges and Set Execution Policy
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "❌ Error: Please run PowerShell as Administrator!" -ForegroundColor Red
    pause; exit
}
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

Write-Host "`n🚀 Starting Boonhlua Bot Installation (Optimized for Node v24)..." -ForegroundColor Cyan
Write-Host "---------------------------------------------------"

# 1. Check for Node.js and Git
$rebootRequired = $false

if (!(Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "📥 Node.js not found! Installing..." -ForegroundColor Yellow
    winget install --id OpenJS.NodeJS.LTS -e --source winget
    $rebootRequired = $true
}

if (!(Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "📥 Git not found! Installing (Required for dependencies)..." -ForegroundColor Yellow
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
    Write-Host "❌ Download failed! Check your internet connection or URL." -ForegroundColor Red
    pause; exit
}

# 4. Install Dependencies
Write-Host "📦 Installing required libraries..." -ForegroundColor Yellow
if (!(Test-Path "package.json")) { 
    npm init -y | Out-Null 
}

# Force installation to ensure path compatibility
& npm install playwright --save
& npx playwright install chromium

# 5. Create Executable (.bat)
$batContent = @"
@echo off
title Boonhlua Bot - Running
cd /d "$botPath"
node bunlua.js
pause
"@
$batContent | Out-File -FilePath "$botPath\start_bot.bat" -Encoding ASCII

# 6. Configure Auto-run on Startup
Write-Host "🖥️  Setting up Windows Startup shortcut..." -ForegroundColor Yellow
try {
    $startupPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\BoonhluaBot.lnk"
    $shell = New-Object -ComObject WScript.Shell
    $shortcut = $shell.CreateShortcut($startupPath)
    $shortcut.TargetPath = "$botPath\start_bot.bat"
    $shortcut.WorkingDirectory = $botPath
    $shortcut.Save()
} catch {
    Write-Host "⚠️  Warning: Could not set up Startup shortcut, but installation is complete." -ForegroundColor Yellow
}

Write-Host "`n✨ Installation Finished Successfully!" -ForegroundColor Green
Write-Host "📍 Location: $botPath"
Write-Host "🚀 Run the bot using: start_bot.bat" -ForegroundColor White
Write-Host "---------------------------------------------------"
pause