# Manager deferred / unfinished work

Living checklist for the Manager track. UI shells (Manager1–5) ship first; functionality follows.

---

## Done — Phase 1 live dashboard (`feature/manager-p0`)

`/manager` reads the current shift via `ManagerDashboard`:

- KPIs: seated covers, covers/hr, servers on, waitlist from the shift; net sales / avg turn / prior-Friday deltas from seeded shift snapshot fields.
- Floor: seated / bill / held / open table counts (bill is a seeded table status).
- Servers on: `server_shifts.active` with vs-baseline, weeds/light badges.
- Cut strip: open `CutRecommendation` or hidden.
- Tonight feed: seeded `pass_note` decision events (plus live Host decisions).
- Rush toggle: same `Host::ToggleRush` as Floor (`return_to=/manager`).
- Kitchen load / late demand: seeded on `shifts`.

Staffing / performance / guests / no-shows still use `ManagerDemo`.

---

## Done — UI shells (feature/manager-ui-shells)

Static ERB pages matching screenshots, hardcoded via `ManagerDemo`:

| Route | Screenshot |
|-------|------------|
| `/manager` | Manager1 + Manager5 dashboard + tools grid |
| `/manager/staffing` | Manager4 tonight’s staffing |
| `/manager/performance` | Manager3 floor team |
| `/manager/guests` | Manager2 guest intelligence |
| `/manager/no_shows` | Tools card (no dedicated PNG) |

Non-functional: Rush toggle, Accept plan, Approve cut (buttons present, no POST). “Review” and tools cards navigate only.

---

## Not done (functionality)

| Item | Notes |
|------|--------|
| Manager-side cut approve (C-02) | Host PIN path exists; Manager Approve cut still inert |
| Accept pre-shift staffing plan | No model yet |
| Real guest / no-show persistence | Needs guest models; VIP gates blocked on D-01 / hustle |
| Net sales / avg turn from POS | Seeded snapshot on `shifts` until DEP-01 |
| Realtime floor channel (X-01 / F-14) | |
| Session auth (F-12) | GM-only guest screen not gated |
| OPEN FLOOR PLAN / ON THE PASS drill-ins | Links are decorative |

---

## Progress log

- **2026-08-13** — Manager UI-only shells on `feature/manager-ui-shells` (mock data, no services).
- **2026-08-17** — Manager P0: live dashboard + rush on `feature/manager-p0`.
