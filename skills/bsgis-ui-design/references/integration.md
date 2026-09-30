# Integration and examples

## Full design

Copy the needed files from `assets/` into the host's style directory. `bsgis-ui.css` imports in order: tokens, primitives, shared UI, admin, auth, layout. Keep those relative files together, or import each through the existing bundler in that order.

Minimal login subset: `tokens.css`, `primitives.css`, `auth.css`. Dashboard subset: `tokens.css`, `primitives.css`, `ui.css`, `admin.css`, `layout.css`; keep the final reduced-motion override from `bsgis-ui.css` after these imports. Shared reset/brand/hidden rules belong to `primitives.css`, not login styles. Text tokens use CSS pixels so changing the host root `font-size` does not silently alter the specified 14px controls; normal browser zoom still works.

Add `.bsg-ui` to a **wrapper around** the themed subtree. For example:

```jsx
import './bsgis/bsgis-ui.css'

export function LoginPage() {
  return <div className="bsg-ui"><div className="auth-page">
    {/* Adapt the complete auth.html markup to existing components. */}
  </div></div>
}
```

The templates are full runnable documents; use them to reproduce the DOM hierarchy, then connect real project components. Replace example wording and identifiers with the host's content. Do not copy BSGIS branding into an unrelated product unless requested.

Tokens live on `.bsg-ui`, not `:root`. Rules are descendant-scoped to avoid unrelated product pages. The host must size the outer application root normally; the standalone demos set body margin to zero. Do not use an unscoped native `button` reset: map zoom controls, editors, CAPTCHA and other embedded controls must keep their own styles.

The reduced-motion override lives last in `bsgis-ui.css` so it also overrides shared skeletons and any subsequent imported transitions. `bsgis-skeleton` is a namespaced keyframe. No remote fonts, scripts, icons or images are required.

For React portals, put a `.bsg-ui` wrapper **inside the portal** (around the dialog) or portal into an existing themed root. A portal mounted directly under an unthemed body will not inherit tokens/scoped rules. Keep the existing focus trap, accessible dialog name, Escape handling and focus restoration.

Preserve form handlers, API calls, route guards and CAPTCHA site keys. Retain the host's busy/validation/error behavior. The demonstration form deliberately prevents submission and sends nothing; replace its demonstration handler when integrating into an application.

## Colors

The exact BSGIS variant requires no overrides. To adapt a requested palette, override the complete accent group on the wrapper after importing styles:

```css
.bsg-ui.project-theme {
  --blue: #0b6b57;
  --blue-hover: #095644;
  --blue-press: #074837;
  --blue-tint: #e5f3ee;
  --blue-text: #074837;
}
```

Keep dimensions and top-light geometry. Check text/focus contrast after recoloring; a single hue swap may make white button labels unreadable. Native selects may render differently by OS, and Arial uses a system fallback where unavailable. Cross-OS pixel identity is not guaranteed.

## Button only

Use the self-contained snippet in `button-light.md`; no full stylesheet import is needed. Apply the class only to intended buttons. Preserve border radius/color/typography of the host if the request is only about hover.

## Preview

Open `assets/auth.html` or `assets/dashboard.html` in a browser, or serve the skill folder using the project's existing local server. Examples work offline; dashboard rows are explicitly demonstration data. They include password visibility, demo form feedback, search, example row addition and a native dialog to exercise actual interactions without a backend.

## Invocation examples

```text
$bsgis-ui-design Aplică exact designul BSGIS: încadrare, fonturi, spații,
login, tabele și butoane iluminate de sus. Păstrează funcționalitatea.

$bsgis-ui-design Adaugă numai efectul de lumină de sus la hover pe
butoanele existente. Nu modifica pagina, culorile sau dimensiunile.
```
