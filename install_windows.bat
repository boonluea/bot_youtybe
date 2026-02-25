@echo off
title กองทัพอ้ายบุญเหลือ Installer
chcp 65001 > nul

echo 🚀 กำลังเริ่มการติดตั้ง กองทัพอ้ายบุญเหลือ สำหรับ Windows...

:: 1. สร้างโฟลเดอร์เก็บโปรเจกต์
echo 📦 1/5 กำลังสร้างโฟลเดอร์ที่ C:\boonhlua_bot...
if not exist "C:\boonhlua_bot" mkdir "C:\boonhlua_bot"
cd /d "C:\boonhlua_bot"

:: 2. เตรียม Node.js โปรเจกต์
echo 🎭 2/5 ติดตั้ง Playwright และ Browser...
call npm init -y
call npm install playwright

:: ติดตั้ง Browser Chromium
npx playwright install chromium
echo ✅ ติดตั้ง Browser สำเร็จ!

:: 3. สร้างไฟล์สคริปต์ bunlua.js
echo 📝 3/5 สร้างไฟล์สคริปต์ bunlua.js...
(
echo const { chromium } = require('playwright'^);
echo.
echo async function startWatching(loopCount^) {
echo   console.log(`\n--- 🚀 เริ่มรอบที่ ${loopCount} ---`^);
echo   const browser = await chromium.launch({ 
echo     headless: false,
echo     args: [
echo       '--disable-blink-features=AutomationControlled',
echo       '--no-sandbox',
echo       '--disable-setuid-sandbox',
echo       '--disable-http2',
echo       '--disable-features=WebRtcHideLocalIpsWithMdns', 
echo       '--disable-quic', 
echo       '--lang=th-TH,th'
echo     ]
echo   }^);
echo.
echo   const context = await browser.newContext({
echo     userAgent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64^) AppleWebKit/537.36 (KHTML, like Gecko^) Chrome/122.0.0.0 Safari/537.36',
echo     locale: 'th-TH',
echo     timezoneId: 'Asia/Bangkok'
echo   }^);
echo.
echo   const page = await context.newPage(^);
echo.
echo   try {
echo     await page.goto('https://api.ipify.org', { timeout: 20000 }^);
echo     const myIp = await page.innerText('body'^);
echo     console.log(`🌍 ออกเน็ตด้วย IP: ${myIp.trim()}`^);
echo.
echo     await page.goto('https://www.google.com', { waitUntil: 'networkidle' }^);
echo     await page.waitForTimeout(Math.random(^) * 2000 + 1000^);
echo.
echo     console.log("📺 เข้า YouTube..."^);
echo     await page.goto('https://www.youtube.com', { waitUntil: 'domcontentloaded', timeout: 60000 }^);
echo.
echo     await page.mouse.wheel(0, 500^);
echo     await page.waitForTimeout(2000^);
echo.
echo     const searchBox = page.locator('input[name="search_query"]'^);
echo     await searchBox.waitFor({ state: 'visible' }^);
echo     await searchBox.click(^);
echo.
echo     const searchText = 'แสดงสุดท้าย อ้ายบุญเหลือ สุดหล่อ';
echo     for (const char of searchText^) {
echo         await page.keyboard.type(char, { delay: Math.random(^) * 100 + 50 }^);
echo     }
echo     await page.keyboard.press('Enter'^);
echo.
echo     await page.waitForSelector('#video-title', { timeout: 20000 }^);
echo     const video = page.locator('a#video-title').first(^);
echo     await video.click(^);
echo     console.log("✅ เริ่มรับชมผลงานอ้ายบุญเหลือ..."^);
echo.
echo     const watchMinutes = Math.floor(Math.random(^) * 3^) + 3; 
echo     const endTime = Date.now(^) + (watchMinutes * 60 * 1000^);
echo.
echo     while (Date.now(^) < endTime^) {
echo         const remainingSec = Math.floor((endTime - Date.now(^)^) / 1000^);
echo         console.log(`   🕒 เหลือเวลาดูอีก ${remainingSec} วินาที...`^);
echo         if (Math.random(^) > 0.6^) await page.mouse.wheel(0, Math.random(^) * 800 + 400^);
echo         await page.waitForTimeout(25000^); 
echo     }
echo     console.log(`✅ จบรอบที่ ${loopCount} สำเร็จ!`^);
echo.
echo   } catch (err^) {
echo     console.log("❌ ติดปัญหา: ", err.message^);
echo   }
echo.
echo   await browser.close(^);
echo   const sleepTime = Math.floor(Math.random(^) * 25000^) + 20000;
echo   console.log(`💤 พักเครื่อง ${sleepTime/1000} วินาทีก่อนเริ่มรอบใหม่...`^);
echo   await new Promise(res =^> setTimeout(res, sleepTime^)^);
echo   startWatching(loopCount + 1^);
echo }
echo.
echo startWatching(1^);
) > bunlua.js

:: 4. ตั้งค่า Auto-start (สร้าง Shortcut ใน Startup)
echo 🖥️ 4/5 ตั้งค่าให้รันอัตโนมัติเมื่อเปิด Windows...
set SCRIPT_PATH=C:\boonhlua_bot\run_bot.bat
(
echo @echo off
echo cd /d C:\boonhlua_bot
echo node bunlua.js
echo pause
) > "%SCRIPT_PATH%"

:: สร้าง Shortcut ไปยังโฟลเดอร์ Startup
set STARTUP_DIR=%AppData%\Microsoft\Windows\Start Menu\Programs\Startup
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%STARTUP_DIR%\BoonhluaBot.lnk');$s.TargetPath='%SCRIPT_PATH%';$s.Save()"

:: 5. เสร็จสิ้น
echo ✅ 5/5 การติดตั้งเสร็จสมบูรณ์!
echo 📍 ไฟล์อยู่ที่: C:\boonhlua_bot
echo ♻️  เปิดโปรแกรมครั้งแรกโดยการรันไฟล์ C:\boonhlua_bot\run_bot.bat หรือ Restart คอมได้เลย!
pause