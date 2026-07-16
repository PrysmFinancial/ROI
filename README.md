# ROI — Restaurant Operational Intelligence

A restaurant operating system for multi-location hospitality groups: direct-booking infrastructure at a flat fee (no per-guest charge), plus a seating engine that decides in real time which table and which server each arriving guest gets — with live floor and staffing intelligence for managers and a cross-location view for group operators.

"ROI" is a working placeholder name; see `docs/specs/` for the full product spec, restaurant-domain glossary, and seating engine specification.

## Tech stack

- **Ruby** 3.4.4 / **Rails** 8.1
- **PostgreSQL** 15
- **Hotwire** (Turbo + Stimulus) for interactive views, no separate frontend framework
- **Tailwind CSS** (via `tailwindcss-rails`)
- **Solid Queue / Solid Cache / Solid Cable** — Rails 8's Postgres-backed job queue, cache, and Action Cable adapters (no Redis needed)
- **Importmap** for JavaScript (no Node build step)

Currently a single Rails monolith serving server-rendered HTML — no separate API, no native mobile app.

## Prerequisites

**Docker Desktop** is the only thing you need installed to run this locally. Everything else (Ruby, Postgres, gems) runs inside containers.

If you'd rather not use Docker, see [Native setup (without Docker)](#native-setup-without-docker) below.

## Running it locally (Docker)

1. Get `config/master.key` from a teammate who already has it (see [About the master key](#about-the-master-key) below) and save it at `config/master.key`. **This step can be skipped for now** — the app boots fine without it in development; you'll only need it once real secrets are added to `config/credentials.yml.enc`.

2. From the project root:

   ```bash
   docker compose build
   docker compose up
   ```

   First run takes a few minutes (pulling the Postgres image, installing gems). Subsequent runs are much faster.

3. Open [http://localhost:3000](http://localhost:3000) — you should see the "Who are you?" landing page.

4. To stop: `Ctrl+C`, then `docker compose down` (this keeps your database data in a named volume for next time).

**Other useful commands** (run from the project root):

```bash
# One-off Rails commands (console, generators, etc.) without starting the whole stack:
docker compose run --rm app bundle exec rails console

# Run the test suite:
docker compose run --rm app bundle exec rails db:test:prepare test

# Peek at the database directly:
docker compose exec app psql $DATABASE_URL
```

> **Windows note:** if your project folder lives on your Windows filesystem (e.g. under `C:\Users\...`), Docker's file-sharing layer between Windows and the Linux containers is noticeably slow — expect the first boot in particular to take longer than on macOS/Linux. Moving the project into a native Linux filesystem (via WSL2) fixes this if it becomes a real pain point, but isn't required to get running.

## About the master key

`config/master.key` decrypts `config/credentials.yml.enc`, which holds Rails' `secret_key_base` (used to sign/encrypt session cookies) and any other real secrets. It's intentionally excluded from git (see `.gitignore`), so it has to be shared directly between teammates rather than committed.

- **For local development right now:** you don't need it. Rails auto-generates a temporary development-only secret when the real key is missing.
- **Once real secrets get added** to `credentials.yml.enc` (API keys, tokens, etc.), the real key becomes necessary — get it from whoever holds it, and never commit it.

## Native setup (without Docker)

If you'd rather install things directly instead of using Docker:

- **Ruby 3.4.4** (see `.ruby-version` / `mise.toml` — [mise](https://mise.jdx.dev/) will install the pinned version automatically) and **Bundler**
- **PostgreSQL 15**, running locally or reachable via `DATABASE_URL`
- **Node 22** (pinned in `mise.toml`)

Then:

```bash
bundle install
bin/rails db:prepare
bin/dev   # starts the Rails server + Tailwind watcher together
```

See `.env.example` for connection options if your Postgres setup needs an explicit `DATABASE_URL` (e.g. on Windows, where the default socket-based config assumes macOS/Linux).

## Running the test suite

```bash
bin/rails db:test:prepare test        # regular tests
bin/rails db:test:prepare test:system # browser-driven system tests
```

(Prefix with `docker compose run --rm app` if you're using the Docker setup.)

## Project docs

- `docs/specs/` — product overview, restaurant-domain glossary, and the seating engine specification (committed, shared)
- `docs/screenshots/` — UI reference screenshots for the Host/Guest/Manager surfaces
