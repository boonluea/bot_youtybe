#!/bin/bash

echo "🚀 กำลังเริ่มการติดตั้ง กองทัพอ้ายบุญเหลือ..."

# 1. อัปเดตระบบและติดตั้ง Node.js
echo "📦 1/5 อัปเดตระบบและติดตั้ง Node.js..."
sudo apt update && sudo apt upgrade -y
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs build-essential

# 2. ติดตั้ง Playwright และส่วนประกอบ
echo "🎭 2/5 ติดตั้ง Playwright และ Browser..."
mkdir -p ~/boonhlua_bot
cd ~/boonhlua_bot
npm init -y
npm install playwright
sudo npx playwright install-deps
npx playwright install chromium

# 3. สร้างไฟล์สคริปต์ bunlua.js
echo "📝 3/5 สร้างไฟล์สคริปต์ bunlua.js..."
cat << 'EOF' > bunlua.js
const { chromium } = require('playwright');

async function startWatching(loopCount) {
  console.log(`\n--- 🚀 เริ่มรอบที่ ${loopCount} ---`);
  
  const browser = await chromium.launch({ 
    headless: false,
    args: [
      '--disable-blink-features=AutomationControlled',
      '--no-sandbox',
      '--disable-setuid-sandbox',
      '--disable-http2',
      '--disable-features=WebRtcHideLocalIpsWithMdns', 
      '--disable-quic', 
      '--lang=th-TH,th'
    ]
  });

  const context = await browser.newContext({
    userAgent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36',
    locale: 'th-TH',
    timezoneId: 'Asia/Bangkok'
  });

  const page = await context.newPage();

  try {
    await page.goto('https://api.ipify.org', { timeout: 20000 });
    const myIp = await page.innerText('body');
    console.log(`🌍 ออกเน็ตด้วย IP: ${myIp.trim()}`);

    await page.goto('https://www.google.com', { waitUntil: 'networkidle' });
    await page.waitForTimeout(Math.random() * 2000 + 1000);

    console.log("📺 เข้า YouTube...");
    await page.goto('https://www.youtube.com', { waitUntil: 'domcontentloaded', timeout: 60000 });
    
    await page.mouse.wheel(0, 500);
    await page.waitForTimeout(2000);

    const searchBox = page.locator('input[name="search_query"]');
    await searchBox.waitFor({ state: 'visible' });
    await searchBox.click();
    
    const searchText = 'แสดงสุดท้าย อ้ายบุญเหลือ สุดหล่อ';
    for (const char of searchText) {
        await page.keyboard.type(char, { delay: Math.random() * 100 + 50 });
    }
    await page.keyboard.press('Enter');

    await page.waitForSelector('#video-title', { timeout: 20000 });
    const video = page.locator('a#video-title').first();
    await video.click();
    console.log("✅ เริ่มรับชมผลงานอ้ายบุญเหลือ...");

    const watchMinutes = Math.floor(Math.random() * 3) + 3; 
    const endTime = Date.now() + (watchMinutes * 60 * 1000);

    while (Date.now() < endTime) {
        const remainingSec = Math.floor((endTime - Date.now()) / 1000);
        console.log(`   🕒 เหลือเวลาดูอีก ${remainingSec} วินาที...`);
        if (Math.random() > 0.6) await page.mouse.wheel(0, Math.random() * 800 + 400);
        await page.waitForTimeout(25000); 
    }
    console.log(`✅ จบรอบที่ ${loopCount} สำเร็จ!`);

  } catch (err) {
    console.log("❌ ติดปัญหา: ", err.message);
  }

  await browser.close();
  const sleepTime = Math.floor(Math.random() * 25000) + 20000;
  console.log(`💤 พักเครื่อง ${sleepTime/1000} วินาทีก่อนเริ่มรอบใหม่...`);
  await new Promise(res => setTimeout(res, sleepTime));
  startWatching(loopCount + 1);
}

startWatching(1);
EOF

# 4. ตั้งค่า Auto-start (Desktop Entry)
echo "🖥️ 4/5 ตั้งค่าให้รันอัตโนมัติเมื่อเข้า Desktop..."
mkdir -p ~/.config/autostart
cat << EOF > ~/.config/autostart/bunlua.desktop
[Desktop Entry]
Type=Application
Exec=gnome-terminal -- /bin/bash -c "cd ~/boonhlua_bot && node bunlua.js; exec bash"
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=BoonhluaBot
Comment=เริ่มปั๊มวิวทันทีที่เปิดเครื่อง
EOF

# 5. เสร็จสิ้น
echo "✅ 5/5 การติดตั้งเสร็จสมบูรณ์!"
echo "📍 ไฟล์บอทอยู่ที่: ~/boonhlua_bot"
echo "♻️ ลอง Restart เครื่องดูได้เลยครับอ้าย!"