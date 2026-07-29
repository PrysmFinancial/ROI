# ROI Design System

The shared visual language for Host, Manager, and ROI Internal (Guest is a separate, not-yet-scheduled product — see `docs/specs/`). Defined in `app/assets/tailwind/application.css` via Tailwind's `@theme`. Extend this file rather than hard-coding one-off colors/fonts in views.

## Core palette

Proven in production on the opening page (`app/views/pages/opening.html.erb`) before being formalized here — this is documentation of what already works, not a new invention.

| Token | Value | Use |
|---|---|---|
| `roi-bg` | `#141210` | Page background — near-black, warm undertone |
| `roi-surface` | `#1f1b18` | Card/panel background |
| `roi-border` | `#3a342e` | Borders on cards, panels, dividers |
| `roi-text` | `#f0ebe3` | Primary text — warm cream, not pure white |
| `roi-muted` | `#9a9188` | Secondary text, labels, captions |

Used as standard Tailwind utilities: `bg-roi-bg`, `text-roi-text`, `border-roi-border`, etc.

## Semantic status colors

**Note on accuracy:** these four were approximated from the design mockups in `docs/screenshots/` (muted/desaturated tones consistent with the core palette, not stock Tailwind brights) — not pixel-extracted from source files, since only rendered PNGs exist. Treat as a reasonable first pass; refine against exact values if a source design file becomes available.

| Token | Approx. value | Seen in mockups as |
|---|---|---|
| `roi-success` | `#8a9a72` (muted sage) | "Open" floor status dot, "on pace"/fairness progress bars, high guest-intelligence score circle (e.g. 94) |
| `roi-warning` | `#c9a227` (muted gold) | "Bill" floor status dot, kitchen load bar, VIP badge, mid guest-intelligence score circle (e.g. 61) |
| `roi-danger` | `#c1694f` (muted terracotta) | "Seated" floor status dot, "at risk"/"in the weeds" badges, low guest-intelligence score circle (e.g. 38) |
| `roi-info` | `#7889a3` (dusty blue) | "Held" floor status dot, "predicted late demand" bar |

These are intentionally desaturated to fit the editorial, dark-luxury aesthetic — avoid swapping in bright/saturated equivalents.

## Typography

| Token | Value | Use |
|---|---|---|
| `font-serif` | Cormorant Garamond | Display headings, hero numbers, page titles — the "editorial" voice |
| `font-sans` | Inter | Body text, UI chrome, labels, buttons |

Loaded via Google Fonts `<link>` tags per-page right now (see `opening.html.erb`'s `content_for :head`) — every page that uses these fonts needs to include that same link block until it's moved into the shared layout (tracked as design-system follow-up work, not yet done).

### The "eyebrow" label pattern

A small, tracked, uppercase, muted label used constantly throughout the mockups (e.g. "OPERATIONAL · IPAD", "SERVER PERFORMANCE · LIVE", "COVERS BOOKED"). Formalized as a Tailwind `@utility`:

```erb
<p class="roi-eyebrow">Operational · iPad</p>
```

This replaces the repeated one-off class string (`text-[0.65rem] font-sans font-medium tracking-[0.2em] text-roi-muted uppercase`) that was already showing up twice in `opening.html.erb`.

**Exception:** the large hero subtitle under the "ROI" wordmark on the opening page uses a wider tracking (`tracking-[0.35em]`) than the standard eyebrow (`0.2em`). That's a deliberate one-off "hero" treatment for that single wordmark moment, not part of the reusable component vocabulary — don't fold it into `roi-eyebrow`.

## What's still one-off, not yet formalized

Tracked as upcoming design-system work, not done in this pass:
- Icons are hand-authored inline SVGs (see `opening.html.erb`) with no shared partial/helper yet
- Google Fonts `<link>` tags are duplicated per-page instead of living in the shared layout
- Card/panel, stat tile, status dot, progress bar, badge, scored circle, button, list row, and modal components (identified from the Host/Manager mockups) don't exist as reusable partials yet
