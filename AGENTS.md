# Agent operating contract

Rails (`.rails/`) is this repo's durable source-of-truth stack. See `docs/rails.md` and `docs/rails-overview.md`.

## Workflow

1. Read `.rails/index.toml` — it is the artifact graph (IDs, paths, statuses, links).
2. Read the active lane tracker (`.rails/lanes/<lane>/tracker.toml`) and its linked work item.
3. Read the linked spec (`.rails/specs/`); read the proposal (`.rails/proposals/`) only for context.
4. Make one PR-sized change.
5. Update `.rails/support/claim-map.toml` or the ledgers under `.rails/policy/` only if a claim or policy actually changes.
6. Run the proof commands listed in the work item / lane implementation plan.
7. Register new durable artifacts in `.rails/index.toml`.
8. Do not invent missing claims. If proof is missing, keep the claim advisory/experimental.
9. Verify that any named command, lint, API, feature flag, crate, or workflow exists before building a PR around it.

## Namespace rules

- Durable artifacts live under `.rails/` only.
- `.codex/`, `.spec/`, `.claude/`, and `.jules/` are awareness-only tool/agent spaces: never store durable state there, never migrate or validate them.

## CI rules (see `EMERGENCY_CI_COST_REDUCTION_PLAN.md` and `.rails/policy/ci-lane-whitelist.toml`)

- Default PR CI is exactly one lane: the routed self-hosted rust-small lane (`.github/workflows/atlasctl-rust-small.yml`).
- No silent GitHub-hosted fallback. Hosted fallback requires an explicit `allow-github-hosted`, `ci-budget-ack`, or `full-ci` label (or maintainer dispatch).
- AI review (`.github/workflows/droid-pr-review.yml`) runs only via the `ai-review` or `full-ci` label, or manual dispatch.
- Concurrency for heavy/core workflows must keep `cancel-in-progress: false` (single active run + single pending replacement slot).
- Do not add CI lanes that are not whitelisted in `.rails/policy/ci-lane-whitelist.toml`.
