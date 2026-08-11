# Host deferred / unfinished work

Living checklist of what Host P0–P2 did **not** do. Update as items land.
Source docs: seating spec, system overview, glossary, `docs/sprint/`, Host1–4 screenshots.

---

## Done in P0

- Domain models + seed for Host Pre-shift / Confirmations / Floor
- Persist confirmation outcomes (`pending` + `no_answer` = pending counter)
- Approve all section assignments (soft lock; seating not hard-blocked)
- Confirm seat via `Seating::AssignmentEngine`
- Pacing confirm / decline + hold gate + **clear hold**
- Cut PIN via **Manager** records (multiple PINs); records who approved
- Switch role + Host tab nav

---

## Done in P1

- **Adjust section** — simple modal; reassign server on shift
- **Offer alternate** — legal options; **reason required**; `overridden` + `override_reason`
- **Rush mode** — floor-wide (**D-04**); suspends pacing holds; `parties.rush_tagged`

---

## Done in P2

- **Live metrics** — Pre-shift / Floor KPIs from shift seed + aggregations (`Host::Metrics`)
- **Host Decisions** — `decision_events` list (accept, override, pacing, cut, pickup)
- **Book detail** — click row → modal with existing fields (no guest history yet)
- **Engine closer to six-check** — cut protection + section fit (incl. combinable); soft scores fairness (15%), idle (8m), projected availability, efficiency (equal weights). VIP/capability hard filters still off (**D-01** / hustle)
- **Mock cut pickup** — “Mock clear → pickup” on cut server’s seated tables; nearest by section position

---

## Explicitly not done (carry forward)

| Item | Notes |
|------|--------|
| **VIP / HNW / recovery hard filters + table holds** | Blocked on **D-01** / self-baseline hustle |
| **Server self-baseline / hustle** | Self-vs-self nightly measure before capability gates |
| **Full F-11 stage audit / Q-01 replay** | Host Decisions is a simple list; not pool→eliminations→score replay |
| **Real POS table-clear events** | Mock pickup only until **DEP-01** |
| **Cut pickup geometry** | Nearest = section position proximity; no floor map distances |
| **Adjust section UX polish** | Refine if hosts give feedback |
| **Greeter-limited Host** | Out of head-host scope |
| **Manager surface** | Out of Host track |
| **New-server rotation (D-05)** / **strong erosion (D-06)** | Still open |

### Open decisions (do not assume)

- **D-01** Skill/capability formula — VIP/large-party gates still off
- **D-05 / D-06** — rotation insertion / strong erosion
- **DEP-01** POS event availability

---

## Progress log

- **2026-07-29** — Host P0 on `feature/host-p0`
- **2026-07-29** — Clarifications: multi-manager PINs; clear hold; hustle = self-vs-self
- **2026-08-05** — Host P1: rush, offer alternate, adjust section. D-04 floor-wide
- **2026-08-10** — Host P2: live metrics, decisions list, book modal, six-check engine pass (D-02/D-03 locked), mock cut pickup. Pinned `image_processing` back to `~> 1.2` (2.x needs ruby-vips at boot)
