$ErrorActionPreference = "Stop"
$botPath = "C:\boonhlua_bot"
$DesktopPath = [System.IO.Path]::Combine([Environment]::GetFolderPath("Desktop"), "BoonhluaBot.lnk")
$StartupPath = [System.IO.Path]::Combine([Environment]::GetFolderPath("Startup"), "BoonhluaBot.lnk")

Write-Host "--- Cleaning old installation ---" -ForegroundColor Yellow

# 1. ลบของเก่า (ถ้ามี)
if (Test-Path $botPath) { 
    Remove-Item -Path $botPath -Recurse -Force 
    Write-Host "[+] Removed old bot folder" 
}
if (Test-Path $DesktopPath) { 
    Remove-Item -Path $DesktopPath -Force 
    Write-Host "[+] Removed old Desktop shortcut" 
}
if (Test-Path $StartupPath) { 
    Remove-Item -Path $StartupPath -Force 
    Write-Host "[+] Removed old Startup shortcut" 
}

Write-Host "--- Starting Clean Installation ---" -ForegroundColor Cyan

# 2. เช็คสิทธิ์ Admin
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Error: Please run as Administrator!" -ForegroundColor Red
    pause; exit
}

# 3. ตรวจสอบ Node.js/Git (ถ้ามีแล้วจะข้าม)
if (!(Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Node.js..." -ForegroundColor Yellow
    winget install --id OpenJS.NodeJS.LTS -e --source winget
    Write-Host "Please restart PowerShell and run again." -ForegroundColor Cyan
    exit
}

# 4. สร้างโฟลเดอร์ใหม่และโหลดไฟล์
New-Item -Path $botPath -ItemType Directory | Out-Null
Set-Location $botPath
Write-Host "Downloading latest bunlua.js..." -ForegroundColor Cyan
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/boonluea/bot_youtybe/main/bunlua.js" -OutFile "bunlua.js"

# 5. ลง Dependencies ใหม่ทั้งหมด
Write-Host "Installing Playwright (Clean)..." -ForegroundColor Yellow
npm init -y | Out-Null
npm install playwright --save
npx playwright install chromium

# 6. สร้างไฟล์รันและ Shortcut ใหม่
$batContent = "@echo off`ntitle Boonhlua Bot`ncd /d `"$botPath`"`nnode bunlua.js`npause"
$batContent | Out-File -FilePath "$botPath\start_bot.bat" -Encoding ASCII

$WshShell = New-Object -ComObject WScript.Shell
# Shortcut หน้าจอ
$S1 = $WshShell.CreateShortcut($DesktopPath)
$S1.TargetPath = "$botPath\start_bot.bat"
$S1.WorkingDirectory = $botPath
$S1.Save()
# Shortcut Startup
$S2 = $WshShell.CreateShortcut($StartupPath)
$S2.TargetPath = "$botPath\start_bot.bat"
$S2.WorkingDirectory = $botPath
$S2.Save()

Write-Host "--- Clean Installation Finished! ---" -ForegroundColor Green
Write-Host "Bot is ready at: $botPath"
pause