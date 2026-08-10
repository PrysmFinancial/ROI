# Host deferred / unfinished work

Living checklist of what Host P0/P1 did **not** do. Update as items land.
Source docs: seating spec, system overview, glossary, `docs/sprint/`, Host1–4 screenshots.

---

## Done in P0 (for orientation)

- Domain models + seed for Host Pre-shift / Confirmations / Floor
- Persist confirmation outcomes (`pending` + `no_answer` = pending counter)
- Approve all section assignments (soft lock; seating not hard-blocked)
- Confirm seat via simplified `Seating::AssignmentEngine`
- Pacing confirm / decline + hold gate + **clear hold**
- Cut PIN via **Manager** records (multiple PINs); records who approved
- Switch role + Host tab nav

---

## Done in P1

- **Adjust section** — simple modal; reassign server on shift (moves them off any prior section)
- **Offer alternate** — legal options from engine; **reason required**; recommendation status `overridden` + `override_reason`
- **Rush mode** — floor-wide toggle (**D-04 resolved**); clears/suspends pacing holds; tags seats via `parties.rush_tagged`

---

## Explicitly not done (carry forward)

### Engine / floor (later)

| Item | Notes |
|------|--------|
| **Seating engine redesign** | Replace P0 stub with six-check pipeline (hard filters + soft scores). Keep `Seating::AssignmentEngine` boundary. |
| **Cut pickup routing** | After cut, cleared tables hand to nearest active server. Needs table-clear events (mock or POS). |
| **VIP / HNW / recovery routing + table holds** | Spec: route to strong servers; hold table until +15m past booking. Blocked on capability/self-baseline measure (below). |
| **Combinable / large-party fit** | Section fit using combinable flags (ROI Internal floor editor in sprint plan). |
| **Server self-baseline / hustle** | Measure each server vs **themselves** nightly (covers/hr vs personal baseline). Not peer headcount. Do not implement capability gates until this exists. |
| **Live metrics** | Replace remaining hardcoded Floor/Pre-shift KPIs (covers/hr, walk-in forecast, etc.) with aggregations. |
| **Book detail drill-in** | Not in P0/P1. |
| **Decision / recommendation audit UI** | Spec: log declined pacing and unused cut recs; H-03b decision log. Override reason is stored; no audit UI yet. |
| **Adjust section UX polish** | Simple modal shipped; refine if hosts give feedback. |
| **POS / event stream** | Undefined (`DEP-01`). Stay on seed/mock until defined. |
| **Greeter-limited Host** | Separate role; out of current Host head-host scope. |
| **Manager surface** | Out of scope for this Host track. |

### Open decisions (do not assume)

From `docs/sprint/open-decisions.md` + seating spec:

- **D-01** Skill/capability formula — blocks VIP/large-party gates
- **D-02 / D-03** Fairness band % / idle minutes — use doc suggestions when building fuller engine unless docs say otherwise
- **DEP-01** POS event availability — not defined yet

---

## Progress log

- **2026-07-29** — Host P0 landed on `feature/host-p0` (models, confirmations, approve sections, confirm seat, pacing + clear hold, multi-manager cut PIN).
- **2026-07-29** — Clarifications: multi-manager PINs; pending counter OK; engine stub OK with redesign note; screenshots = mock data only; clear hold added; cut pickup deferred; hustle = self-vs-self (not building yet).
- **2026-08-05** — Host P1: floor-wide rush, offer alternate + required reason, simple adjust-section modal. D-04 resolved floor-wide.
