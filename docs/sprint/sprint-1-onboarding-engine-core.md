# Sprint 1: ROI Internal (Onboarding) + Deterministic Engine Core

**Goal:** Kedi builds ROI Internal so a location can be configured, including the drag-and-drop floor plan (split into two parts). Tanner builds the deterministic rule engine — the hard constraints that must never be wrong.

**Sync note:** Lowest-coordination sprint. The engine lane (Tanner) and the ROI Internal lane (Kedi) are almost fully independent. Only link: E-03 reads the floor shape that I-03b produces, so order I-03b before E-03.

---

## Kedi's lane — ROI Internal

- [ ] **I-02** — Roster setup screen: add staff, set role, skill score, and section, in a shape ready for a future Dayforce import.
  *Why:* The rotation and the engine's strong/weak routing both need a real roster with skill scores.
  Depends on: F-07 · Est: 2d · Priority: High
  Done when: A full roster can be entered, skill score editable.

- [ ] **I-03** — Floor plan editor part 1: the drag-and-drop canvas, placing tables, setting seat counts and table types (Stimulus + SVG).
  *Why:* First half of the visual floor editor — split in two so it's easier to manage and review. This is the map the engine and live floor read.
  Depends on: F-08, F-18 · Est: 2d · Priority: High
  Done when: Tables can be placed with seats and types on a saved canvas.

- [ ] **I-03b** — Floor plan editor part 2: grouping tables into sections and marking which tables are combinable.
  *Why:* Split from part 1 so each piece is a clean unit of work.
  Depends on: I-03 · Est: 2d · Priority: High
  Done when: Tables group into sections, combinable tables are flagged.
  **⚠ E-03 (Tanner's lane) depends on this — order it before E-03.**

- [ ] **I-04** — Section size cap derivation from combinable tables, plus validation that no table is orphaned.
  *Why:* Bad floor data would make the engine try to seat parties where they cannot fit.
  Depends on: I-03b · Est: 1.5d · Priority: Medium
  Done when: Every table belongs to a section, combinable logic gives the right cap.

## Tanner's lane — Deterministic Engine

- [ ] **E-01** — Rule engine scaffold: an ordered pipeline that takes a party plus live floor and returns the candidate pool through staged filters, logging each stage.
  *Why:* This is the backbone of the seating decision — the "must never be wrong" core.
  Depends on: F-07, F-08, F-10, F-11 · Est: 2d · **CRITICAL PATH**
  Done when: Pipeline runs end to end on synthetic events, each stage recorded.

- [ ] **E-02** — Hard constraint: shift gate (exclude not-yet-started servers) plus cut protection (exclude flagged servers).
  *Why:* You never seat a server who has not started or is leaving.
  Depends on: E-01 · Est: 1d · Priority: High
  Done when: Off-shift or flagged servers never appear in the pool.

- [ ] **E-03** — Hard constraint: section fit, including combinable table logic for large parties.
  *Why:* A party of eight cannot go to a two-top.
  Depends on: E-01, **I-03b** · Est: 2d · Priority: High
  Done when: A party of N only routes to sections that physically fit.

- [ ] **E-04** — Hard constraint: large party restriction plus VIP, HNW, and recovery pre-filter (restrict to strong servers).
  *Why:* Risk management. **Blocked until the skill score formula (D-01) is decided** — see `open-decisions.md`.
  Depends on: E-01, D-01 · Est: 1.5d · Priority: High
  Done when: Valued and large parties only route to strong servers.

- [ ] **E-05** — Rotation pointer: order by shift start, handle new server insertion, and wrap-around.
  *Why:* Rotation is the fair queue the whole engine is built on. **Depends on decision D-05** — see `open-decisions.md`.
  Depends on: E-01, D-05 · Est: 1.5d · Priority: High
  Done when: New server behaviour matches the D-05 decision.

- [ ] **E-06** — Deterministic engine test harness: scripted synthetic nights asserting pool and selection correctness, with the tiebreak.
  *Why:* The core must be provably correct before it ever runs a real floor.
  Depends on: E-02, E-03, E-04, E-05 · Est: 2d · Priority: High
  Done when: Same input always yields the same, explainable output.
