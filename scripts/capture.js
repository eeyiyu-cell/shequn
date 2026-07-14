// 配置驱动的 Playwright 截图脚本 —— 红魔方社群积分系统三端原型重截
// 用法: node scripts/capture.js scripts/shots.json
// 依赖: 项目 node_modules/playwright + chromium-1228
const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');

const ROOT = path.resolve(__dirname, '..');
const OUT = path.join(ROOT, 'output', 'prd_assets_v3');
fs.mkdirSync(OUT, recursiveOpt());
function recursiveOpt() { return { recursive: true }; }

function fileUrl(rel) {
  const p = path.join(ROOT, rel).replace(/\\/g, '/');
  return 'file:///' + encodeURI(p);
}

(async () => {
  const cfgPath = process.argv[2] || path.join(__dirname, 'shots.json');
  const shots = JSON.parse(fs.readFileSync(cfgPath, 'utf-8'));
  const browser = await chromium.launch();
  let ok = 0, fail = 0;
  for (const s of shots) {
    const ctx = await browser.newContext({
      viewport: { width: s.width || 1440, height: s.height || 900 },
      deviceScaleFactor: s.dsf || 2,
    });
    const page = await ctx.newPage();
    try {
      await page.goto(fileUrl(s.file), { waitUntil: s.waitUntil || 'networkidle', timeout: 60000 });
      await page.waitForTimeout(600);
      if (s.js) {
        // 传语句串, 用 new Function 包成真调用, 规避"箭头函数字符串不执行"坑
        await page.evaluate((code) => { (new Function(code))(); }, s.js);
      }
      await page.waitForTimeout(s.wait || 700);
      const outPath = path.join(OUT, s.name + '.png');
      if (s.clip) {
        const el = await page.$(s.clip);
        if (!el) throw new Error('clip selector not found: ' + s.clip);
        await el.screenshot({ path: outPath });
      } else {
        await page.screenshot({ path: outPath, fullPage: s.fullPage !== false });
      }
      console.log('OK  ', s.name);
      ok++;
    } catch (e) {
      console.log('FAIL', s.name, '::', e.message);
      fail++;
    }
    await ctx.close();
  }
  await browser.close();
  console.log(`\n== done: ${ok} ok, ${fail} fail ==`);
})();
