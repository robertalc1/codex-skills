# Geometry and visual specification

## Source and precedence

These are the final BSGIS values from the centered-login/top-light revision. They supersede the earlier 354px form, 42px fields and top-aligned login. CSS assets are the executable reference. They are scoped adaptations, with standalone dependencies included; no access to the BSGIS repository is required.

## Color, type and rhythm

| Role | Value |
|---|---|
| Surface / alternate / inset | `#fff` / `#f8f9fa` / `#f1f3f4` |
| Text / secondary / muted | `#202124` / `#3c4043` / `#5f6368` |
| Line / soft line | `#dadce0` / `#e8eaed` |
| Accent / hover border / pressed | `#1a73e8` / `#1b66c9` / `#185abc` |
| Accent tint / text on tint | `#e8f0fe` / `#185abc` |
| Success / danger / warning tint | `#e6f4ea` / `#fce8e6` / `#fef7e0` |
| Font | Arial, -apple-system, BlinkMacSystemFont, Segoe UI, sans-serif |
| Body / label / control | 14px; body line-height 1.5; regular 400 |
| Small supporting text | 12px; avoid using faint text for critical labels |
| Emphasis | 600; buttons remain 400 |
| Spacing scale | 4, 8, 12, 16, 24, 32, 40, 48, 64, 80, 120px |
| Card / field / button radius | 8px |
| Status chips | Pill-shaped; pills are not the button shape |

## Login framing

| Element | Exact contract |
|---|---|
| Page | `min-height:100svh`; 50/50 `minmax(0,1fr)` columns |
| Desktop header | Absolute; 96px high; inline padding `clamp(24px,2.5vw,48px)` |
| Left pane | Grid rows `minmax(min-content,1fr) auto`; padding `112px 40px 32px`; center items |
| Form group | Width 100%, max 400px; align-self center; no card border/shadow |
| Title | 24px/30px, 600, tracking -0.5px, centered; bottom gap 32px |
| Form | Vertical flex; 20px gap; label-to-field gap 8px |
| Input and submit | 44px tall; field horizontal padding 16px; radius 8px |
| Password toggle | 45px wide; inset 1px; 1px left divider; input right padding 48px |
| CAPTCHA | Center existing widget; reserve minimum 65px when present |
| Submit offset | 4px additional top margin |
| Account/help text | 28px above; 14px/24px; centered |
| Footer | Separate grid row; max 400px; 48px top padding; 12px/18px |
| Right pane | Center content; padding `112px clamp(40px,4vw,80px) 96px` |
| Right content | Width 100%, max 440px; left-aligned |
| Eyebrow | 13px/20px monospace, tracking .5px; 16px below |
| Feature title | Max 420px; `clamp(32px,2.5vw,40px)`; line-height 1.15; weight 600; tracking -.8px; balanced wrapping |
| Feature description | Max 390px; 15px/24px; 24px vertical margin |
| Blue panel | `linear-gradient(100deg,var(--blue-press),var(--blue) 65%)` |
| Decoration | 132deg 7px diagonal repeats; ellipse inset `8% -18% 8% 8%`; opacity .55; mask left→right; pointer-events none |

Center the whole form group including title and help. Keep the legal/access footer separate. Do not put fixed `top:50%` offsets or an arbitrary `margin-top` on the form. Both short-height and narrow-width rules matter.

## Responsive contract

- At ≤900px: left inline padding 28px; right inline padding 32px; header action gap 8px.
- At ≤800px: one column; decorative panel hidden; header in normal flow at 76px; header inline padding 20px; brand text/secondary header CTA hidden; form pane min-height `calc(100svh - 76px)` and padding `40px 24px 24px`; heading 23px.
- At height ≤650px: desktop form top padding 104px, footer top padding 32px. At width ≤800px too, form top padding is 24px. The document can scroll.
- At 320px width the 24px side gutters leave 272px. If a host CAPTCHA needs more, use its supported responsive/compact mode; never clip or scale its security iframe. The demo does not embed CAPTCHA.
- A full-width primary control is 44px even though desktop toolbar buttons are 38px. Preserve readable field text and native zoom; never disable user scaling. On iOS, use a host-specific 16px input override if needed to avoid focus zoom, and report this deliberate platform adaptation.

## Shared controls and data surfaces

- Regular button 38px, small 32px, login 44px; inline padding 12px, icon gap 8px (small 4px), icons 18px (small 16px). Default 1px border, 8px radius, no tracking.
- General fields 38px, 1px border, 16px inline padding; focus uses accent border plus inset 1px accent line. Checkbox/radio 18px. Every control has a label or accessible name.
- Cards: white with soft 1px border and 8px radius. Standard card padding 32px; import card padding 24px. No giant radii or permanent heavy shadows on cards.
- Tabs: 32px gap, 16px vertical padding, 14px text, active 3px underline. Implement keyboard tab behavior if using tab semantics.
- Tables: 14px body; cells 12px × 16px padding; sticky header; horizontal overflow inside wrapper; fine row separators. Status chips use the supplied success/warning/danger text/tint pair and text labels, not color alone.
- Errors: 12px × 16px padding, red tint and dark red text, 8px corners; announce dynamic errors. Loading/disabled states keep control width stable.
- Modal reference: max 1040px, 8px corners, max height viewport minus 96px; 24px × 32px header padding, 32px body padding; scroll body, preserve focus trap/Escape/restore focus in host. Native dialog demo is only an example.

## Workspace and dashboard extension

Retain the established host navigation. BSGIS workspace uses a 60px header and 280px sidebar. At ≤900px its map sidebar stacks above content; at ≤600px the header wraps. Do not impose a navigation rewrite just to make it resemble a reference image.

The standalone dashboard demo uses those dimensions with a centered content maximum of 1200px, 48px desktop padding (24px tablet, 16px mobile), flexible toolbar, card grid, table and native dialog. This content layout is an explicit reusable extension rather than a measured copy of the original Cloudflare dashboard.
