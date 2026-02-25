$ErrorActionPreference = "Stop"
$botPath = "C:\boonhlua_bot"
$DesktopPath = [System.IO.Path]::Combine([Environment]::GetFolderPath("Desktop"), "BoonhluaBot.lnk")
$StartupPath = [System.IO.Path]::Combine([Environment]::GetFolderPath("Startup"), "BoonhluaBot.lnk")

Write-Host "--- Step 1: Cleaning old installation ---" -ForegroundColor Yellow

# Remove old files if exists
if (Test-Path $botPath) { 
    Remove-Item -Path $botPath -Recurse -Force 
    Write-Host "[+] Removed old bot folder" 
}
if (Test-Path $DesktopPath) { 
    Remove-Item -Path $DesktopPath -Force 
}
if (Test-Path $StartupPath) { 
    Remove-Item -Path $StartupPath -Force 
}

Write-Host "--- Step 2: Checking Requirements ---" -ForegroundColor Cyan

# Check for Node.js
if (!(Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "Node.js not found. Installing..." -ForegroundColor Yellow
    winget install --id OpenJS.NodeJS.LTS -e --source winget
    Write-Host "Please restart PowerShell and run this script again." -ForegroundColor Cyan
    exit
}

# 4. Create Folder and Download
New-Item -Path $botPath -ItemType Directory | Out-Null
Set-Location $botPath
Write-Host "Downloading latest bunlua.js..." -ForegroundColor Cyan
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/boonluea/bot_youtybe/main/bunlua.js" -OutFile "bunlua.js"

# 5. Install Dependencies
Write-Host "Installing Playwright..." -ForegroundColor Yellow
npm init -y | Out-Null
npm install playwright --save
npx playwright install chromium

# 6. Create Start File and Shortcuts
$batContent = "@echo off`ntitle Boonhlua Bot`ncd /d `"$botPath`"`nnode bunlua.js`npause"
$batContent | Out-File -FilePath "$botPath\start_bot.bat" -Encoding ASCII

$WshShell = New-Object -ComObject WScript.Shell
# Desktop Link
$S1 = $WshShell.CreateShortcut($DesktopPath)
$S1.TargetPath = "$botPath\start_bot.bat"
$S1.WorkingDirectory = $botPath
$S1.Save()
# Startup Link
$S2 = $WshShell.CreateShortcut($StartupPath)
$S2.TargetPath = "$botPath\start_bot.bat"
$S2.WorkingDirectory = $botPath
$S2.Save()

Write-Host "--- Clean Installation Finished! ---" -ForegroundColor Green
Write-Host "Check your Desktop for BoonhluaBot shortcut."
pause