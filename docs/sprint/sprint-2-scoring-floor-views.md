# Sprint 2: Floor Views (Kedi) + Scoring, Cut-Rec, VIP Holds (Tanner)

**Goal:** Kedi builds the Host floor and seating views and the Manager live view, all reading the same realtime state. Tanner adds heuristic scoring and, to stay busy in parallel rather than idle while the views are built, pulls the cut recommendation (C-01) and VIP hold (V-01) logic forward. First real integration of the two tracks, so settle the X-01 channel contract first.

**⚠ SHARED SEAM — do this first:** **X-01** (below) must be agreed in writing before H-01/H-03/M-01 are built.

---

## Tanner's lane — Scoring + parallel filler

- [ ] **E-07** — Scoring interface: each soft factor is a swappable strategy (heuristic now, Python ML call later) that ranks survivors of the rule pool.
  *Why:* This clean seam is exactly where Phase 2 ML plugs in with no rewrite.
  Depends on: E-06 · Est: 1.5d · Priority: High
  Done when: Interface signature stable, today returns heuristics.

- [ ] **E-08** — Heuristic fairness score (covers vs. floor average, penalty only beyond the band) plus availability score (idle-minutes boost).
  *Why:* Keeps rotation fair without punishing normal variation. Depends on decisions D-02, D-03 — see `open-decisions.md`.
  Depends on: E-07, D-02, D-03 · Est: 1.5d · Priority: High
  Done when: Reads fairness band and idle threshold from config.

- [ ] **E-09** — Heuristic projected availability (fixed turn time by party size) plus efficiency score (covers per hour vs. personal baseline).
  *Why:* Covers per hour, not raw headcount, is the true measure — a fast server is never skipped.
  Depends on: E-07 · Est: 1.5d · Priority: High
  Done when: Cold-start defaults in place, efficiency rewards speed.

- [ ] **C-01** — Cut recommendation service: decide when and how many can safely go home, in strict start order, guarding against a forecast late rush.
  *Why:* Pulled into Sprint 2 so Tanner has engine backend work here while Kedi builds the floor views — its only prerequisite (E-05) is done in Sprint 1.
  Depends on: E-05 · Est: 2d · Priority: High
  Done when: Recommends readiness by start order, every recommendation logged.

- [ ] **V-01** — Reservation table hold: hold a good table for a valued reservation, protect it from walk-ins until 15 minutes past booking, then release.
  *Why:* Pulled into Sprint 2 alongside C-01 to balance Tanner's load — prerequisites (E-04, F-09) already done.
  Depends on: E-04, F-09 · Est: 2d · Priority: High
  Done when: Hold and auto-release at the configured minutes.

## Kedi's lane — Host + Manager views

- [ ] **H-01** — Render the saved floor plan as a live SVG on the Host screen. *(Frontend work, moved to Kedi in the rebalance.)*
  *Why:* The host needs to see the real floor to run it.
  Depends on: F-14, I-03 · Est: 1.25d · Priority: High
  Done when: The saved plan renders on the Host screen.

- [ ] **H-01b** — Bind the floor view to the live channel so table status updates appear in real time.
  *Why:* Split from H-01 so the rendering and the live wiring are clean units.
  Depends on: H-01, F-14 · Est: 1d · Priority: High
  Done when: Table status changes appear live in under a second.

- [ ] **H-02** — Greeter check-in and walk-in flow: the form, party creation, and waitlist entry. *(Moved to Kedi.)*
  *Why:* Walk-ins must enter the system, and the greeter is limited so they cannot bypass seating control.
  Depends on: F-09, F-12 · Est: 1.5d · Priority: Medium
  Done when: Greeter can add walk-ins, cannot seat.

- [ ] **H-03** — Seating recommendation card UI: show the engine's suggested table and server on the Host screen. *(Moved to Kedi.)*
  *Why:* This is the visible half of the core loop. The suggestion itself is produced by Tanner's engine (E-07).
  Depends on: E-07, H-01 · Est: 1.25d · Priority: High
  Done when: The recommended table and server display clearly.

- [ ] **H-03b** — Confirm and override controls plus the override reason modal, recording the host action to the decision log.
  *Why:* Split from H-03 so the display and the interaction are separate units. The logging teaches Phase 2.
  Depends on: H-03 · Est: 1.25d · Priority: High
  Done when: Confirm and override both recorded to the decision log.

- [ ] **M-01** — Manager live floor status: a read-only realtime view of covers, table states, and per-server load.
  *Why:* Gives the GM the realtime picture the product promises.
  Depends on: F-14, H-01 · Est: 2.5d · Priority: High
  Done when: Manager sees the same floor as the host, plus aggregates.

- [ ] **M-02** — Live server load and covers-per-hour panel per shift.
  *Why:* Shows the manager the same fairness signals the engine uses.
  Depends on: F-07, E-09 · Est: 1.5d · Priority: Medium
  Done when: Per-server load and covers per hour visible live.

## Shared

- [ ] **X-01** — **SHARED SEAM.** Agree in writing the Host and Manager floor state channel contract (event names, payload shape).
  *Why:* Prevents the two halves breaking each other during integration.
  Depends on: F-14 · Est: 1d · **CRITICAL PATH** · Owner: Kedi + Tanner
  Done when: A written contract both build against exists.

## Sync notes

Settle X-01 (the floor channel contract) in writing before the views are built. Key handoff: Kedi's H-03 consumes Tanner's E-07 scoring output, so agree that payload early. C-01 and V-01 are Tanner's parallel filler so he is not idle while views are built.
