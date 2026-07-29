# Sprint 0: Shared Foundation

**Goal:** Stand up the Rails 8 monolith, schema, realtime plumbing, auth and multi-tenancy, core domain models, and the synthetic event source. Both devs are blocked on most of this, so Tanner does the CRITICAL PATH foundation first to unblock Kedi fast. Kedi works the design system and own models in parallel, then begins ROI Internal location setup (I-01) the moment the config models land.

**Status:** F-01 confirmed done in the repo. Everything else below is not started.

---

## Tanner's lane

- [x] **F-01** — Repo & tooling — Initialize Rails 8.1.x app (Ruby 3.3+) with Postgres adapter and Hotwire default.
  *Why:* Create the empty Rails 8 project everything else is built inside. Nothing can start until this container exists.
  Depends on: none · Est: 1d · **CRITICAL PATH**
  Done when: App boots, Turbo and Stimulus present by default. ✅ **Confirmed in repo.**

- [ ] **F-02** — Repo & tooling — Set schema format to `:sql` (`structure.sql`) so Postgres partitioning and CHECK constraints survive schema dumps.
  *Why:* The raw-events table needs Postgres partitioning that the Ruby schema format can't capture.
  Depends on: F-01 · Est: 0.5d · **CRITICAL PATH**
  Done when: `schema_format = :sql` committed and verified.

- [ ] **F-07** — Data model — Migrations and models for `staff` (persistent identity) and `shifts` (per-night state, rotation spot, cut status, covers).
  *Why:* Split because a server's skill carries across nights but their rotation spot resets nightly.
  Depends on: F-02 · Est: 1.5d · **CRITICAL PATH**
  Done when: `staff` and `shifts` split intact with associations.

- [ ] **F-08** — Data model — Migrations and models for `sections` and `tables` (status, `seated_at`, `projected_free_at`, combinable, size cap).
  *Why:* The engine and floor plan both read this to decide who can seat a party.
  Depends on: F-02 · Est: 1.5d · **CRITICAL PATH**
  Done when: Floor entities location-scoped, combinable and size cap present.

- [ ] **F-10** — Data model — Migrations for `raw_events` as a RANGE-partitioned, append-only table (monthly partitions) with an idempotency index.
  *Why:* This is the permanent source of truth the engine runs on and ML later trains on.
  Depends on: F-02, F-07, F-08 · Est: 2d · **CRITICAL PATH**
  Done when: Partition DDL in a migration, full raw payload in jsonb.

- [ ] **F-11** — Data model — Migrations for `seating_decisions` (pool, eliminations, scores, host action, engine flag) and `decision_outcomes`.
  *Why:* Even with no ML today, this becomes labelled training data for Phase 2, for free.
  Depends on: F-02, F-07 · Est: 1.5d · Priority: High
  Done when: A decision row is written on every engine run.

- [ ] **F-14** — Real-time — ActionCable and Turbo Streams on Solid Cable (Postgres-backed), a per-location floor state channel, plus the floor view binding glue.
  *Why:* The whole product depends on every screen sharing one live picture of the floor.
  Depends on: F-01 · Est: 1.75d · **CRITICAL PATH**
  Done when: A change on one screen appears on another in under a second locally.

- [ ] **F-15** — Real-time — Solid Queue background jobs on Postgres, with one example job running.
  *Why:* Pacing and cut checks run in the background later; avoids needing Redis.
  Depends on: F-01 · Est: 0.5d · Priority: Medium
  Done when: A sample background job runs on the queue.

- [ ] **F-16** — POS harness — Synthetic event generator that fires a realistic stream of table lifecycle events at a chosen pace.
  *Why:* So both devs can build/test the engine and live floor without waiting on the real POS, which is still unconfirmed.
  Depends on: F-10 · Est: 2.5d · **CRITICAL PATH**
  Done when: Can simulate a full service night of events.

- [ ] **F-17** — POS harness — Ingestion adapter interface and webhook endpoint stub. The generator and the future Squirrel feed both go through it.
  *Why:* So swapping to the real POS is a one-piece change, not an engine rewrite.
  Depends on: F-16 · Est: 1.5d · Priority: High
  Done when: Swapping synthetic to real POS is one adapter change.

## Kedi's lane

- [ ] **F-03** — Local DB env — `docker-compose.yml` with a Postgres 15 service plus a documented native install path, and a `.env.example`.
  *Why:* Give each dev a local database they can run in Docker or as a desktop install, set up the way they each prefer.
  Depends on: F-01 · Est: 1d · Priority: High
  Done when: A new dev runs either path and `db:setup` works.
  **Status: functionally complete, not yet shared.** `docker-compose.yml` + `Dockerfile.dev` are built and confirmed working (Postgres + Rails serving `localhost:3000`). `README.md` now documents the Docker path in full, plus a brief native-setup pointer (deliberately lighter-detail, since Docker is the path we're standardizing on); `.env.example` covers both. All of this currently exists as **uncommitted changes** on branch `feature/docker-dev-environment` (not yet staged, committed, or pushed), so Tanner doesn't have it yet. Check the box once it's committed, pushed, and merged.

- [ ] **F-04** — Local DB env — Migration workflow doc plus a seed script that builds one demo location.
  *Why:* Write the agreed steps for making a database change, committing it, and applying it on pull, plus test data — keeps both local databases in sync.
  Depends on: F-03 · Est: 1d · Priority: High
  Done when: `db:seed` creates a location, roster, and floor.

- [ ] **F-05** — CI / quality — GitHub Actions running migrations and tests on every pull request, with RuboCop and Brakeman.
  *Why:* Two parallel tracks catch breakage early instead of drifting apart.
  Depends on: F-01 · Est: 1d · Priority: Medium
  Done when: PRs show green checks before merge.
  *(Note: CI workflow already exists in `.github/workflows/ci.yml` from the initial scaffold — worth checking against this task's actual intent before treating as fully open.)*

- [ ] **F-06** — Data model — Migrations and models for `restaurant_groups`, `locations`, and `location_config` (tunables as rows).
  *Why:* Every record hangs off a location, and the settings table holds tunable numbers instead of hard-coding them.
  Depends on: F-02 · Est: 1d · **CRITICAL PATH**
  Done when: `location_config` holds idle minutes, fairness band, skill thresholds, hold minutes, large-party threshold.

- [ ] **F-09** — Data model — Migrations and models for `guests`, `parties` (VIP, HNW, recovery flags) and `reservations` (hold table, hold release).
  *Why:* So the engine can later route valued guests and hold their table.
  Depends on: F-02 · Est: 1.5d · Priority: High
  Done when: Reservation hold fields present for VIP hold logic.

- [ ] **F-12** — Auth & tenancy — Authentication plus three roles: head host, greeter, manager. Session-based for web.
  *Why:* Every screen and permission depends on who is signed in — e.g. only a manager can approve a cut.
  Depends on: F-06 · Est: 1.5d · **CRITICAL PATH**
  Done when: Login works for each role, greeter restricted vs. head host.

- [ ] **F-13** — Auth & tenancy — Location scoping on all tenant tables plus a current-location resolver.
  *Why:* A multi-location product cannot show one location's floor to another.
  Depends on: F-06, F-12 · Est: 1.5d · Priority: High
  Done when: No query leaks across locations.

- [ ] **F-18** — Design system — Shared Hotwire layout, Stimulus setup, base styles, and reusable component partials used across all surfaces.
  *Why:* Stop the two of you inventing two different-looking UIs.
  Depends on: F-01 · Est: 2d · Priority: High
  Done when: One visual system reused by Host, Manager, and Internal.

- [ ] **I-01** — ROI Internal — Location setup screen: create a location, set timezone, POS provider, reservation source, and edit the tunables.
  *Why:* Pulled into Sprint 0 so Kedi has independent work as soon as the config models (F-06) and tenancy (F-13) exist, instead of waiting on the rest of foundation.
  Depends on: F-06, F-13 · Est: 2d · Priority: High
  Done when: A new location can be stood up end to end.

## Sync notes

Tanner's F-01 and F-02 gate everything, so he front-loads F-07 and F-08 to unblock Kedi's roster and floor editor. Kedi runs the design system and own models in parallel, then starts I-01. This sprint leans Tanner because he is laying the scaffold, but Kedi is not idle.
