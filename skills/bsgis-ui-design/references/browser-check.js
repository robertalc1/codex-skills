// Playwright CLI: first open assets/auth.html through a local static server,
// then run-code --filename=<skill>/references/browser-check.js.
async page => {
  const base = page.url().replace(/[^/]*$/, '');
  const results = [];
  const errors = [];
  const onError = error => errors.push(error.message);
  page.on('pageerror', onError);
  const check = (name, ok) => {
    if (!ok) throw new Error(name);
    results.push(name);
  };
  try {
    for (const path of ['auth.html','dashboard.html']) {
      for (const [width,height] of [[2560,1080],[1440,900],[1024,768],[801,900],[800,900],[768,900],[390,844],[320,568],[844,390]]) {
        await page.setViewportSize({width,height});
        await page.goto(base+path);
        check(`${path} fits ${width}x${height}`, await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth));
        if (path === 'auth.html') {
          const geometry = await page.evaluate(() => {
            const card = document.querySelector('.auth-card').getBoundingClientRect();
            const header = document.querySelector('.auth-header').getBoundingClientRect();
            const footer = document.querySelector('.auth-footer').getBoundingClientRect();
            const input = document.querySelector('#username').getBoundingClientRect();
            const feature = getComputedStyle(document.querySelector('.auth-feature'));
            return card.width <= 400 && card.top >= header.bottom && card.bottom <= footer.top && input.height === 44 && (innerWidth > 800 ? feature.display !== 'none' : feature.display === 'none');
          });
          check(`auth geometry ${width}x${height}`, geometry);
        }
      }
    }
    await page.setViewportSize({width:1440,height:900});
    await page.goto(base+'auth.html');
    await page.locator('#username').fill('example');
    await page.locator('#password').fill('example-only');
    await page.locator('#toggle-password').click();
    check('password reveal', await page.locator('#password').getAttribute('type') === 'text');
    await page.locator('#toggle-password').click();
    check('password conceal', await page.locator('#password').getAttribute('type') === 'password');
    await page.locator('button[type=submit]').click();
    check('demo form explains no authentication', await page.locator('#demo-status').isVisible());
    const button = page.locator('button[type=submit]');
    await page.mouse.move(0,0);
    await page.waitForTimeout(230);
    const before = await button.boundingBox();
    check('light off at rest', await button.evaluate(el => getComputedStyle(el,'::before').opacity === '0'));
    await button.hover();
    await page.waitForTimeout(230);
    const after = await button.boundingBox();
    check('light on without layout change', await button.evaluate(el => getComputedStyle(el,'::before').opacity === '1') && JSON.stringify(before) === JSON.stringify(after));
    await page.mouse.down();
    await page.waitForTimeout(230);
    check('press light opacity', await button.evaluate(el => getComputedStyle(el,'::before').opacity === '0.3'));
    await page.mouse.up();
    await button.evaluate(el => {el.disabled=true;});
    await page.waitForTimeout(230);
    check('disabled light off', await button.evaluate(el => getComputedStyle(el,'::before').opacity === '0'));
    await button.evaluate(el => {el.disabled=false;el.setAttribute('aria-disabled','true');});
    await page.waitForTimeout(230);
    check('aria-disabled light off', await button.evaluate(el => getComputedStyle(el,'::before').opacity === '0'));
    await button.evaluate(el => el.removeAttribute('aria-disabled'));
    await page.emulateMedia({reducedMotion:'reduce'});
    check('reduced motion', await button.evaluate(el => parseFloat(getComputedStyle(el,'::before').transitionDuration) < 0.001));
    await page.emulateMedia({reducedMotion:'no-preference'});
    check('checkbox not stretched', await page.evaluate(() => {
      const input=document.createElement('input');input.type='checkbox';
      document.querySelector('.auth-form').append(input);
      const r=input.getBoundingClientRect();input.remove();return r.width===18 && r.height===18;
    }));
    check('host root font does not change control text', await page.evaluate(() => {
      document.documentElement.style.fontSize='20px';
      const size=getComputedStyle(document.querySelector('.btn')).fontSize;
      document.documentElement.style.fontSize='';return size==='14px';
    }));
    await page.goto(base+'dashboard.html');
    await page.locator('#filter').fill('not-present');
    check('empty search state', await page.locator('#filter-empty').isVisible());
    await page.locator('#filter').fill('');
    await page.locator('#open-dialog').click();
    await page.locator('[name=title]').fill('Exemplu nou');
    await page.locator('#example-form button[type=submit]').click();
    check('demo row addition', await page.locator('#layer-rows tr').count() === 4 && !(await page.locator('dialog').isVisible()));
    check('dialog focus restored', await page.locator('#open-dialog').evaluate(el => el === document.activeElement));
    await page.locator('#open-dialog').click();
    await page.keyboard.press('Escape');
    check('dialog Escape', !(await page.locator('dialog').isVisible()));
    await page.setViewportSize({width:320,height:568});
    check('narrow import/settings grids', await page.evaluate(() => {
      const content=document.querySelector('.dashboard-main');
      for(const cls of ['import-cards','settings-form']) {
        const grid=document.createElement('div');grid.className=cls;
        const child=document.createElement('div');child.textContent='Example';grid.append(child);content.append(grid);
        if(child.getBoundingClientRect().right > innerWidth) return false;
        grid.remove();
      }
      return true;
    }));
    check('no JavaScript exceptions', errors.length===0);
    return {passed:results.length,results};
  } finally {
    page.off('pageerror',onError);
    await page.emulateMedia({reducedMotion:'no-preference'});
  }
}
