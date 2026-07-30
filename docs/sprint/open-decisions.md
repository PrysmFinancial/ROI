# Open Decisions

These block specific engine tasks across sprints, so they're tracked here rather than buried in one sprint file — most of them need to be resolved *before* the sprint that needs them, not during it. Owner is Kedi (product judgement) unless noted. Resolve in parallel with sprint work — most of these block Tanner's engine.

- [ ] **D-01** — The single skill score formula (strong is ≥70, weak is <40) used the same way for section sizing, large-party restriction, and the VIP pre-filter.
  *Why it blocks:* The engine cannot run the large-party restriction or VIP routing without a concrete strong/weak number to compare against.
  Blocks: **E-04** (Sprint 1) · Owner: Kedi

- [ ] **D-02** — Fairness band percent (spec suggests 15%) for how far ahead a server can get before a penalty applies.
  *Why it blocks:* Sets when the fairness score starts re-ranking. Lives in config but still needs a starting value.
  Blocks: **E-08** (Sprint 2) · Owner: Kedi

- [ ] **D-03** — Availability idle threshold (spec says 8 minutes) before an idle server is boosted.
  *Why it blocks:* Drives the availability score — needs a confirmed default to compute against.
  Blocks: **E-08** (Sprint 2) · Owner: Kedi

- [ ] **D-04** — Rush mode scope: floor-wide or targeted at one server.
  *Why it blocks:* Changes how the rush toggle is built and how rush tagging is scoped in R-01.
  Blocks: **R-01** (Sprint 3) · Owner: Kedi

- [ ] **D-05** — New server rotation insertion: confirm a newly-started server takes the very next table, then resumes the normal cycle.
  *Why it blocks:* Determines the rotation pointer behaviour in E-05.
  Blocks: **E-05** (Sprint 1) · Owner: Kedi

- [ ] **D-06** — Strong server erosion guardrail: keep at least one combinable strong section until last seating.
  *Why it blocks:* Affects the cut logic — risk of no strong section left for a late VIP or large party.
  Blocks: **C-01, C-03** (Sprints 2–3) · Owner: Kedi + Tanner

- [ ] **D-07** — Dayforce read: confirm how the roster and start times are pulled. Manual entry is acceptable for MVP1.
  *Why it blocks:* Affects the roster import shape in I-02. Manual entry is the MVP1 fallback, so this doesn't hard-block, just shapes the implementation.
  Blocks: **I-02** (Sprint 1) · Owner: Kedi

- [ ] **DEP-01** — Squirrel or Omnivore: can it emit the table lifecycle stream, and do `food_delivered` and `table_available` exist in it?
  *Why it blocks:* Critical path for real data. MVP1 runs on synthetic events regardless, but pilot data quality depends on this answer.
  Blocks: **PILOT-02** (Sprint 4) · Owner: Kedi
  *Status (2026-07-29):* Still undefined — Host P0 runs on seed/mock floor state. See also `docs/host-deferred.md`.

## Host P0 follow-ups (tracked in `docs/host-deferred.md`)

- [ ] Seating engine redesign beyond the simplified P0 stub
- [ ] Cut pickup routing when a cut server’s tables clear
- [ ] Server self-baseline hustle measure (vs themselves nightly) — not implementing capability gates yet

## Related open items from the seating engine spec

Cross-referenced from `docs/specs/ROI_Seating Spec & Explanation.docx` — Part 2, section 11 ("Open dependencies"). Same underlying questions as above, phrased from the spec's own framing:

- Squirrel API / event availability — critical path. Does it emit the table-lifecycle stream? *(= DEP-01)*
- Existence of `food_delivered` and `table_available` events in that stream specifically. *(= part of DEP-01)*
- Rush mode scope (floor-wide vs. targeted) and confirmation of rush-period data tagging. *(= D-04)*
- Exact values: availability threshold (currently 8 min), fairness band percentage, and the single `capability_score` formula shared across section sizing, large-party restriction, and the VIP pre-filter. *(= D-01, D-02, D-03)*
- New-server rotation insertion: confirm a newly-started server takes the immediate next table, then resumes normal cycle. *(= D-05)*
