# Manager deferred / unfinished work

Living checklist for the Manager track. UI shells (Manager1–5) ship first; functionality follows.

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
| Wire KPIs / floor / servers to live shift data | Reuse `Host::Metrics`, sections, server_shifts |
| Manager-side cut approve (C-02) | Host PIN path exists; Manager Approve cut still inert |
| Accept pre-shift staffing plan | No model yet |
| Real guest / no-show persistence | Needs guest models; VIP gates blocked on D-01 / hustle |
| Net sales / avg turn from POS | DEP-01 |
| Realtime floor channel (X-01 / F-14) | |
| Session auth (F-12) | GM-only guest screen not gated |
| OPEN FLOOR PLAN / ON THE PASS drill-ins | Links are decorative |

---

## Progress log

- **2026-08-13** — Manager UI-only shells on `feature/manager-ui-shells` (mock data, no services).
