# สคริปต์ติดตั้งกองทัพอ้ายบุญเหลือ สำหรับ Windows (PowerShell)
$ErrorActionPreference = "Stop"
Write-Host "🚀 กำลังเริ่มการติดตั้ง กองทัพอ้ายบุญเหลือ..." -ForegroundColor Cyan

# 1. ตรวจสอบ Node.js
if (!(Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "❌ ไม่พบ Node.js! กำลังติดตั้งผ่าน Winget..." -ForegroundColor Yellow
    winget install OpenJS.NodeJS.LTS
    Write-Host "✅ ติดตั้ง Node.js สำเร็จ (กรุณารันสคริปต์นี้อีกครั้งหลังปิด/เปิด PowerShell ใหม่)" -ForegroundColor Green
    exit
}

# 2. เตรียมโฟลเดอร์ทำงาน
$botPath = "C:\boonhlua_bot"
if (!(Test-Path $botPath)) { 
    New-Item -Path $botPath -ItemType Directory 
    Write-Host "📂 สร้างโฟลเดอร์ $botPath" -ForegroundColor Gray
}
Set-Location $botPath

# 3. ดาวน์โหลดไฟล์บอทจาก GitHub
Write-Host "📥 กำลังดึงไฟล์ล่าสุดจาก GitHub..." -ForegroundColor Cyan
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/boonluea/bot_youtybe/main/bunlua.js" -OutFile "bunlua.js"

# 4. ติดตั้ง Dependencies
Write-Host "📦 กำลังติดตั้ง Playwright และ Browser (อาจใช้เวลาสักครู่)..." -ForegroundColor Yellow
if (!(Test-Path "package.json")) { npm init -y | Out-Null }
npm install playwright | Out-Null
npx playwright install chromium

# 5. สร้างตัวรัน (.bat) เพื่อให้ดับเบิลคลิกง่ายๆ
$batContent = @"
@echo off
title กองทัพอ้ายบุญเหลือ - กำลังทำงาน
cd /d $botPath
node bunlua.js
pause
"@
$batContent | Out-File -FilePath "$botPath\start_bot.bat" -Encoding ASCII

# 6. ตั้งค่าให้รันตอนเปิดเครื่อง (Startup)
Write-Host "🖥️ ตั้งค่าให้รันอัตโนมัติเมื่อเข้า Windows..." -ForegroundColor Yellow
$startupPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\BoonhluaBot.lnk"
$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($startupPath)
$shortcut.TargetPath = "$botPath\start_bot.bat"
$shortcut.WorkingDirectory = $botPath
$shortcut.Save()

Write-Host "`n✅ ติดตั้งเสร็จสมบูรณ์!" -ForegroundColor Green
Write-Host "📍 ตำแหน่งบอท: $botPath"
Write-Host "🚀 เริ่มรันทันทีโดยดับเบิลคลิกไฟล์: C:\boonhlua_bot\start_bot.bat" -ForegroundColor White
pause