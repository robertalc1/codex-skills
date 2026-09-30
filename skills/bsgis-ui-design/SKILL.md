---
name: bsgis-ui-design
description: Use when implementing the Black Sea GIS visual design in a login page, dashboard, admin panel, form, or button; when the user asks for BSGIS spacing and page framing, compact Cloudflare-inspired controls in their own colors, or a button lit from its top edge on hover.
---

# BSGIS UI Design

Reproduce the final BSGIS design, including its measured local layout and top-light button effect. This is a reusable design implementation, not a Cloudflare clone or an authentication system. The design values come from the BSGIS implementation; Cloudflare's live CSS was not available. Do not claim pixel identity to Cloudflare.

## Apply the requested scope

- Read the project's existing layout, styles and relevant components. Preserve its stack, routes, handlers, data, branding and authentication providers.
- For the full design, read [the design specification](references/design-spec.md) and [integration notes](references/integration.md). Use the supplied CSS instead of reconstructing dimensions from memory.
- For **only the button effect**, read [the button contract](references/button-light.md). Add its isolated surface overlay to existing buttons; do not restyle the page or install libraries.
- For login, use [auth.html](assets/auth.html) as the DOM contract; for administrative surfaces, use [dashboard.html](assets/dashboard.html). These are offline design demonstrations with explicitly fictional data, not production auth or persistence implementations.

## Visual contract

The default palette is white, light gray and BSGIS blue `#1a73e8`. Keep an explicitly requested project palette by changing accent tokens, not dimensions. Font: Arial, -apple-system, BlinkMacSystemFont, Segoe UI, sans-serif; 14px body/control text; no external font dependency.

Login: equal columns above 800px, centered 400px maximum form, 44px inputs and submit, 8px corners, 20px field gaps, 24px/30px heading. Form and footer occupy separate grid rows. Never simulate centering with a fixed top margin; short viewports must scroll without overlap. At 800px and below, hide the decorative pane and use a 76px header. Exact padding and height-dependent rules are in the assets.

Dashboard: 60px top bar, 280px sidebar, 38px regular controls and 32px small controls, thin neutral borders, 8px cards. Keep existing map/third-party controls in their established locations. The included dashboard content layout is a reusable extension of these primitives, not a new product requirement.

Buttons: `position: relative; isolation: isolate`, a below-label pseudo-element, white top-to-bottom gradient at 32% → 8% (42% stop) → transparent (72% stop), inset top highlight, opacity `0 → 1` over **200ms ease**. No movement, resizing, shine sweeping sideways, bounce, pulse or darkening on primary hover. Gate hover to fine pointers; suppress disabled states; respect reduced motion. Keep focus visible separately.

## Integrate and verify

1. Add a `.bsg-ui` wrapper and import only needed assets in the documented order. Scope portals as described in integration notes. Do not replace all native `button` styling or leak resets outside the wrapper.
2. Connect visual markup to the host's real behavior. Retain labels, password visibility, pending/error/success states and CAPTCHA when already present. Never ship demonstration handlers as a real login, or add unsupported SSO/recovery actions.
3. Compare the implemented page in a browser against the bundled template at matching viewport and browser settings. Run [the QA checklist](references/verification.md): desktop, tablet, narrow and short mobile; hover/press/leave, disabled, keyboard and reduced motion. Report actual results and untested states.

Use newer explicit user preferences over these defaults. Applying this skill does not authorize publishing the host app or changing its business logic.
