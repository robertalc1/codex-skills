# Button light: exact effect

The reference is a surface lit from above. The top edge becomes lighter, fading down into the unchanged blue. The text, dimensions and position remain fixed. This is **not** an opening panel, moving shine, glow outside the button or scale effect.

For button-only requests, adapt these selectors to the existing button class. The `.bsg-ui` wrapper is optional in that mode if the host already scopes the component. Check whether `::before` is occupied; use `::after` or a dedicated decorative child instead, maintaining the same stacking and pointer behavior.

```css
.top-lit {
  position: relative;
  isolation: isolate;
}
.top-lit::before {
  content: '';
  position: absolute;
  inset: 0;
  z-index: -1;
  border-radius: inherit;
  background: linear-gradient(180deg,
    rgb(255 255 255 / 32%),
    rgb(255 255 255 / 8%) 42%,
    transparent 72%);
  box-shadow: inset 0 1px 0 rgb(255 255 255 / 65%);
  opacity: 0;
  pointer-events: none;
  transition: opacity 200ms ease;
}
@media (hover: hover) and (pointer: fine) {
  .top-lit:not(:disabled):not([disabled]):not([aria-disabled='true']):hover::before {
    opacity: 1;
  }
  .top-lit:not(:disabled):not([disabled]):not([aria-disabled='true']):active::before {
    opacity: 0.3;
  }
}
@media (prefers-reduced-motion: reduce) {
  .top-lit::before { transition-duration: 0.001ms; }
}
```

Keep the host's focus ring and press feedback. Remove a competing primary `:hover` rule that darkens the whole surface when applying this exact BSGIS effect. Use `:disabled` for native buttons. For `aria-disabled` links/custom controls, the host must also prevent activation; ARIA and styling do not disable behavior.

Default full-design primary surface: `linear-gradient(to bottom, color-mix(in srgb, var(--blue), white 13%), var(--blue))`; 1px `--blue-hover` border; inset top line at 20% white; small 6% black shadow. The layer goes behind text using a negative z-index **inside** the isolated button. Without isolation it may disappear behind the page. Without negative stacking it can wash out text.

The secondary white button receives a more subtle light; its neutral border and subtle gray hover remain visible. Never increase opacity simply to make white-on-white look like the blue primary.
