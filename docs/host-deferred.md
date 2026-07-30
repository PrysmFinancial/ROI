# Host deferred work

Notes from Host P0 follow-ups. Not blocking current Host loops.

## Seating engine redesign (come back)

P0 ships a **simplified** `Seating::AssignmentEngine`:

- Hard: exclude cut servers; require an open table that fits party size
- Soft: prefer sections with more open tables, then lower covers, then start order

We still need a fuller redesign later that implements the seating-spec six-check model (fairness band, idle boost, projected availability, efficiency / covers-per-hour vs personal baseline, VIP/recovery pre-filter, combinable large-party fit). Keep the service boundary so Host UI does not need to change when the engine deepens.

## Cut pickup routing (come back)

When a cut is approved, the server stops getting new tables and finishes current ones. **Not yet implemented:** as each of their tables clears (`table_available`), automatically hand that table/section work to the nearest active server (pickup tables). Track and build after the POS/event backbone or a mock event publisher exists.

## Server self-baseline / hustle (not yet)

`capability_score` / strong-vs-weak routing is **deferred**. Product intent: measure each server against **themselves** night over night (covers/hr vs personal baseline) to see who is hustling — not a blunt peer headcount race. Do not implement VIP/large-party capability gates until this measure is defined in product + seeded history exists.

## POS event stream

Not defined yet. MVP continues on seed/mock floor state. Live Squirrel (or Omnivore) lifecycle events remain an open dependency (`docs/sprint/open-decisions.md` DEP-01).

## Fairness / idle thresholds

Use seating-spec suggestions (e.g. ~15% fairness band, ~8 min idle) when the fuller engine is built, unless docs state otherwise.
