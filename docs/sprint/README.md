# ROI — MVP1 Build Plan (local working copy)

> Markdown version of `ROI_MVP1_Build_Plan.pdf`, split into per-sprint files for day-to-day tracking.
> Not gitignored — tracked like any other file if you choose to stage it — but not yet committed or
> pushed, so still local-only for now (fine for now, since this is a private 2-dev repo). Source of
> truth for the *original* plan is still the PDF in this same folder; update these files as work
> actually happens so they reflect reality, not just the original plan.

Restaurant Operational Intelligence · Release 1 (web only) · Rails 8 + Hotwire monolith · Rebalanced to an exact 50/50 split between Tanner and Kedi.

## Files in this folder

- [sprint-0-foundation.md](sprint-0-foundation.md) — shared base: Rails app, schema, realtime, auth, core models, synthetic event source
- [sprint-1-onboarding-engine-core.md](sprint-1-onboarding-engine-core.md) — ROI Internal onboarding + deterministic rule engine
- [sprint-2-scoring-floor-views.md](sprint-2-scoring-floor-views.md) — heuristic scoring + Host/Manager floor views
- [sprint-3-pacing-cuts-rush.md](sprint-3-pacing-cuts-rush.md) — pacing governor, cut execution, rush mode
- [sprint-4-analytics-pilot.md](sprint-4-analytics-pilot.md) — analytics, hardening, shadow-mode pilot readiness
- [open-decisions.md](open-decisions.md) — product/config decisions that block engine tasks, tracked separately since they cut across sprints

## Workload split (exactly even)

| Dev | Owned tasks | Owned days | Shared (half-counted) | Total days | Share |
|---|---|---|---|---|---|
| **Tanner** | 27 | 42.75 | +3.5 | 46.25 | 50.0% |
| **Kedi** | 27 | 42.75 | +3.5 | 46.25 | 50.0% |
| Shared (both) | 4 tasks | 7 days total | — | — | — |

**Owner legend**
- **Tanner** — Engine and backend: the high-risk algorithmic core, the data backbone, realtime infra, pacing/cut logic, the Host *backend*.
- **Kedi** — Frontend and views (Host views included), ROI Internal onboarding, Manager surface, analytics.
- **Shared** — Done jointly or with an explicit written contract; integration seams that span both domains.

### Per-phase breakdown

| Phase / Sprint | Tanner tasks | Tanner days | Kedi tasks | Kedi days | Shared tasks | Shared days |
|---|---|---|---|---|---|---|
| Phase 0: Foundation (Sprint 0) | 10 | 14.25 | 9 | 12.5 | 0 | 0 |
| Phase 1: Onboarding + Engine Core (Sprint 1) | 6 | 10 | 4 | 7.5 | 0 | 0 |
| Phase 2: Scoring + Floor Views (Sprint 2) | 5 | 8.5 | 7 | 10.25 | 1 | 1 |
| Phase 3: Pacing, Cuts, Rush (Sprint 3) | 4 | 6.5 | 4 | 7 | 1 | 2 |
| Phase 4: Analytics + Pilot (Sprint 4) | 2 | 3.5 | 3 | 5.5 | 2 | 4 |
| **Total (owned)** | **27** | **42.75** | **27** | **42.75** | **4** | **7** |

## Phases at a glance

| Phase | Focus |
|---|---|
| **Phase 0: Foundation** (Sprint 0) | Shared base: Rails app, database, realtime, login, core models, fake event source. Split by component between both devs. |
| **Phase 1: Onboarding + Engine Core** (Sprint 1) | Kedi builds ROI Internal (incl. drag-and-drop floor plan). Tanner builds the deterministic rule engine. |
| **Phase 2: Scoring + Floor Views** (Sprint 2) | Tanner adds heuristic scoring. Kedi builds the Host floor/seating views and the Manager live view. |
| **Phase 3: Pacing, Cuts, Rush** (Sprint 3) | Tanner builds pacing, cut, and rush logic. Kedi builds the rush toggle and cut cost views. |
| **Phase 4: Analytics + Pilot** (Sprint 4) | Analytics, no-show tracking, the decision audit view, hardening, and shadow-mode pilot readiness. |

## What changed in the rebalance

- **Host frontend moved to Kedi** — the Host views (live floor, greeter check-in, seating recommendation surface, rush toggle, decision audit view) are now Kedi's. The engine and realtime infra behind them stay Tanner's.
- **A few tasks were split** — H-01, H-03, and I-03 were each split into two subtasks so the work divides cleanly and the counts land even.
- **Engine stays with Tanner** — the deterministic seating engine, pacing governor, cut logic, and VIP holds remain Tanner's. None of that moved.

## Parallel flow — lane balance per sprint

| Sprint | Tanner load | Kedi load | Gap |
|---|---|---|---|
| Phase 0: Foundation | 14.25d | 12.5d | +1.75d (Tanner heavier) |
| Phase 1: Onboarding + Engine Core | 10.0d | 7.5d | +2.50d (Tanner heavier) |
| Phase 2: Scoring + Floor Views | 8.5d | 10.25d | −1.75d (Kedi heavier) |
| Phase 3: Pacing, Cuts, Rush | 6.5d | 7.0d | −0.50d (Kedi heavier) |
| Phase 4: Analytics + Pilot | 3.5d | 5.5d | −2.00d (Kedi heavier) |

### Sync points and handoffs, per sprint

- **Sprint 0:** Tanner's F-01/F-02 gate everything, so he front-loads F-07/F-08 to unblock Kedi's roster and floor editor. Kedi runs the design system and own models in parallel, then starts I-01. Leans Tanner-heavy since he's laying the scaffold, but Kedi isn't idle.
- **Sprint 1:** Lowest-coordination sprint — the engine lane (Tanner) and ROI Internal lane (Kedi) are almost fully independent. Only link: E-03 reads the floor shape I-03b produces, so order I-03b before E-03.
- **Sprint 2 — SHARED: X-01.** Settle the floor channel contract in writing *before* the views are built. Key handoff: Kedi's H-03 consumes Tanner's E-07 scoring output — agree that payload early. C-01 and V-01 are Tanner's parallel filler so he isn't idle while views are built.
- **Sprint 3 — SHARED: C-02.** Highest integration risk this plan. Cut approval spans both surfaces. Handoffs: Tanner's P-02 consumes Kedi's R-01 (rush flag) and H-03; Kedi's M-04 reads the pacing history P-01 produces, so order P-01 before M-04.
- **Sprint 4 — SHARED: Q-02, Q-04.** Performance pass and end-to-end night test done together. Handoff: Tanner's Q-03 (host resilience) builds on Kedi's H-01b live binding. Lightest sprint by design — a buffer for hardening and pilot onboarding.

## Progress log

> Update this as work actually lands — this is the one section meant to diverge from the static PDF.

- **2026-07-15** — F-01 confirmed done in the actual repo (Rails 8 app initialized, boots, Turbo/Stimulus present — matches the existing `git log`). Everything else in Sprint 0 is still not started in code. Local Docker dev environment (`docker-compose.yml` + `Dockerfile.dev`, not part of the original plan's exact form but fulfills the spirit of F-03) built and confirmed working — Postgres + Rails serving `localhost:3000`. Native install path and `.env.example` update (the other half of F-03) still outstanding.
- **2026-07-15** — F-03 documentation gap closed: `README.md` rewritten (was default Rails boilerplate) — Docker documented as the primary, fully-detailed setup path, with a brief native-setup pointer since Docker is what we're standardizing on. `.env.example` updated to cover the Docker route plus native macOS/Linux and native Windows cases. All of this exists as uncommitted changes on a new branch, `feature/docker-dev-environment` (not yet staged, committed, or pushed) — still local-only until committed and shared. F-03 is functionally done; the only remaining gap is committing and sharing it with Tanner.
- **2026-07-15** — Decided against gitignoring `docs/sprint/` after all — this is a private 2-dev repo, so there's no real need to hide the sprint plan from git. The exclusion rule was added and then removed from `.gitignore` the same day; these files are now plain untracked files like any other, staged/committed whenever that's decided. Separately, the F-03 commit itself was undone (`git reset`, mixed mode) to review the changes before finalizing — so as of this entry, nothing on this branch is committed, only sitting as working-tree changes.
