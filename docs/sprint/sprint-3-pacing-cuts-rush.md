# Sprint 3: Pacing, Cuts, and Rush (Tanner) + Analytics Begins (Kedi)

**Goal:** Tanner builds the pacing governor, cut execution, and rush enforcement. With the cut recommendation and VIP hold already done in Sprint 2, his lane here is lighter, so Kedi starts the analytics work (no-show tracking and the analytics dashboard) in parallel rather than waiting for Sprint 4. The cut approval flow is a shared seam — most integration risk lives here.

**⚠ Highest integration risk in the whole plan is here: C-02.**

---

## Tanner's lane — Pacing + Cuts

- [ ] **P-01** — Pacing governor: compute the floor load index and kitchen load index from the event stream.
  *Why:* These drive the decision to slow seating before service collapses.
  Depends on: F-16, E-09 · Est: 2d · Priority: High
  Done when: Indices computed live as a background job.
  **⚠ M-04 (Kedi's lane) depends on this — order it before M-04.**

- [ ] **P-02** — Hold recommendation: when an index crosses its threshold, suggest a hold the host accepts or declines. Respects the rush flag. Never auto-holds.
  *Why:* Pacing protects service but the host stays in control.
  Depends on: P-01, H-03, **R-01** · Est: 1.5d · Priority: High
  Done when: Recommendation only, suspended during rush, logged.

- [ ] **C-03** — Cut execution: the cut server stops getting tables, finishes their own, and cleared tables route to the nearest active server as pickups.
  *Why:* Nobody has to run the room, and the closer advantage is preserved.
  Depends on: C-02 · Est: 2d · Priority: High
  Done when: Pickup re-routing works on a synthetic night.

- [ ] **D-SEAT** — Double seat protection within a short window, suspended while the rush flag is on.
  *Why:* Prevents accidentally burying a server.
  Depends on: E-07, R-01 · Est: 1d · Priority: Medium
  Done when: Two near-simultaneous parties to one server are prevented outside rush.

## Kedi's lane — Rush toggle + Analytics start

- [ ] **C-04** — Cut cost visibility: a manager view of recommendations vs. approvals and time kept on past the recommendation.
  *Why:* So the business can see money spent keeping staff on longer than needed.
  Depends on: C-01 · Est: 1.5d · Priority: Medium
  Done when: Manager can see spend on labour kept beyond recommended cut.

- [ ] **R-01** — Rush mode toggle and indicator: sets the rush flag and tags seats made during the rush. *(Frontend, moved to Kedi. Suspension itself is enforced by P-02 and D-SEAT reading this flag.)*
  *Why:* Lets the host load the floor fast in a surge. Depends on decision D-04 — see `open-decisions.md`.
  Depends on: D-04 · Est: 1.5d · Priority: High
  Done when: Toggle sets the flag, rushed seats are tagged out of baselines.

- [ ] **M-03** — No-show tracking: per-guest no-show history, reservation status surfacing, manager review.
  *Why:* Pulled into Sprint 3 so Kedi has analytics work here while Tanner finishes pacing and cuts — its only prerequisite (F-09) is long done.
  Depends on: F-09 · Est: 1.5d · Priority: Medium
  Done when: No-show counts accrue per guest.

- [ ] **M-04** — Server and guest analytics for the location: covers, pacing history, per-server performance over a shift or period.
  *Why:* Pulled into Sprint 3 to balance Kedi's lane. **Order it after P-01** since it reads the pacing history P-01 produces.
  Depends on: M-02, **P-01** · Est: 2.5d · Priority: Medium
  Done when: Dashboard reads from the decision and pacing logs.

## Shared

- [ ] **C-02** — **SHARED SEAM.** Cut approval flow. Host flags ready, manager approves with a code or device tap, then the engine executes.
  *Why:* Spans both surfaces, only a manager can approve, and the contract must be shared.
  Depends on: C-01, M-01 · Est: 2d · **CRITICAL PATH** · Owner: Kedi + Tanner
  Done when: Head host cannot self-approve, pop-up hits host and manager at once.

## Sync notes

Highest integration risk in the whole plan. C-02 (cut approval) is a shared seam spanning both surfaces. Handoffs: Tanner's P-02 consumes Kedi's R-01 (rush flag) and H-03, and Kedi's M-04 reads the pacing history P-01 produces, so order P-01 before M-04.
