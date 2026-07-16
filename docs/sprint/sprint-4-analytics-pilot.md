# Sprint 4: Finish Analytics, Decision Audit View, Hardening, Shadow-Mode Pilot Readiness

**Goal:** Kedi finishes the analytics (the U-shape diagnostic) and the decision audit view. Both devs harden, then prepare for a shadow-mode pilot: ROI recommends, the human host executes, everything logged. This is the lightest sprint by design — a buffer for hardening and pilot onboarding.

---

## Kedi's lane — Analytics + audit view

- [ ] **M-05** — U-shape diagnostic: a nightly covers-by-start-order curve that flags when it goes flat.
  *Why:* A flat curve means the engine is wrongly equalising instead of protecting openers and closers — see the "shape that proves it's working" section of the system overview spec.
  Depends on: M-04 · Est: 1.5d · Priority: Medium
  Done when: The curve renders per night and flags a flat shape.

- [ ] **Q-01** — Decision log audit view (internal): replay any night's decisions step by step, pool → eliminations → score → selection → host action. *(Frontend view, moved to Kedi.)*
  *Why:* Proves the engine is sound during shadow mode.
  Depends on: E-06, H-03 · Est: 2d · Priority: High
  Done when: Any night can be replayed and explained.

- [ ] **PILOT-01** — Shadow mode runbook plus onboarding one real pilot location via ROI Internal, with OpenTable read or manual entry.
  *Why:* A configured real location is the prerequisite for any pilot.
  Depends on: I-01, I-02, I-03b · Est: 2d · Priority: High
  Done when: One real location fully configured.

## Tanner's lane — Resilience + POS confirmation

- [ ] **Q-03** — Offline and disconnect resilience for Host: a kiosk wifi blip must not stop seating, with reconnect and state re-sync.
  *Why:* A kiosk dropping connection cannot be allowed to stop seating.
  Depends on: H-01b · Est: 2d · Priority: High
  Done when: Host recovers cleanly from a dropped connection mid-service.

- [ ] **PILOT-02** — Squirrel or Omnivore confirmation plus the real webhook behind the adapter if available, else continue shadow on synthetic.
  *Why:* Real data improves the pilot, but the adapter means we're not blocked. Depends on DEP-01 — see `open-decisions.md`.
  Depends on: F-17, DEP-01 · Est: 1.5d · Priority: High
  Done when: Real POS drops in behind the adapter, or pilot proceeds without it.

## Shared

- [ ] **Q-02** — **SHARED.** Performance pass: realtime fanout under a full simulated service, an N+1 sweep, a Solid Cable throughput check, decide if Redis is needed.
  *Why:* The floor must stay responsive at peak.
  Depends on: H-01b, M-01 · Est: 2d · Priority: High · Owner: Kedi + Tanner
  Done when: Floor stays responsive under peak synthetic load.

- [ ] **Q-04** — **SHARED.** End-to-end synthetic night acceptance test: a full service from open to close with all features firing.
  *Why:* One scripted full night that exercises every feature and asserts the U-shape and auditability, as a single green run proving the whole system works end to end.
  Depends on: Q-01 · Est: 2d · Priority: High · Owner: Kedi + Tanner
  Done when: One scripted night exercises the whole system green.

## Sync notes

Shared Q-02 (performance pass) and Q-04 (end-to-end night) are done together. Handoff: Tanner's Q-03 (host resilience) builds on Kedi's H-01b live binding. Lightest sprint, a buffer for hardening and pilot onboarding.
