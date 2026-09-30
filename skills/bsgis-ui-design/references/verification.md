# Verification checklist

Use the project's browser tooling; no special MCP or skill dependency is required. Test the real integration, not just this static template. Do not add runtime test dependencies solely for screenshots when browser tooling is already available.

For the bundled examples, [browser-check.js](browser-check.js) runs 44 checks. Open `assets/auth.html` through a local static server in Playwright CLI, then run `playwright-cli run-code --filename=<skill-path>/references/browser-check.js`. The script derives the base URL from the open page; it does not submit anything to a backend. A configured browser is required. For a real app, adapt selectors and use its existing test fixtures.

Release validation: 44/44 example checks passed in Chromium on 2026-09-30. Skill frontmatter, local resource links and JavaScript syntax validated. An independent skill-use pass preserved the host palette and authentication, and generated button-only CSS without changing existing pill geometry. This is not a claim of backend authentication, real CAPTCHA, iOS-device or cross-browser coverage.

## Layout

Check 2560×1080, 1440×900, 1024×768, 801×900, 800×900, 768×900, 390×844, 320×568 and 844×390. Confirm:

- No document horizontal overflow; tables scroll inside their container.
- Login form max-width 400px, input/submit 44px, radius 8px; equal columns above 800px.
- Form begins below the header and ends above its footer. Centering remains balanced with an error paragraph, existing CAPTCHA and registration confirmation field.
- Mobile viewport can scroll on short screens; no fixed-height clipping.
- Dashboard wraps actions, cards and the header; long usernames/titles cannot expand the grid.
- Dialog fits the viewport, body scrolls, keyboard focus is retained and restored.

## Interaction

- At rest the light pseudo-element opacity is 0; hovered it is 1 after 200ms; pressed .3; leave returns 0.
- Compare the button rectangle and text before/after hover: no movement or size change.
- Disabled and aria-disabled controls never illuminate or execute actions. Keyboard focus is visible.
- Under reduced motion, the overlay changes immediately; no recurring skeleton motion. With coarse pointer/hover-none, no false hover effect after tapping.
- Existing password toggle preserves value; submitting, validation, errors and language switching still work. Demo handlers are never substituted for actual authentication.

## Evidence

Capture matching viewport/browser states before and after. Pixel diff is meaningful only with equal copy, data, fonts and viewport; do not claim Cloudflare pixel fidelity from this adaptation. Build/lint and relevant existing tests must pass; record warnings and any backend, CAPTCHA, assistive-technology or real-device checks not exercised.
