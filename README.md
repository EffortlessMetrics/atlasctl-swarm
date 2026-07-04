# atlasctl-swarm

Control-plane repository for the EffortlessMetrics atlasctl swarm: CI cost policy, runner routing, Rust tooling doctrine, and the durable `.rails/` knowledge base. There is no Rust code here yet — when a `Cargo.toml` lands, the CI lanes below pick it up automatically.

## Document map

| Document | Role |
|---|---|
| [`EMERGENCY_CI_COST_REDUCTION_PLAN.md`](EMERGENCY_CI_COST_REDUCTION_PLAN.md) | Authoritative CI cost doctrine: minimal default PR lane, opt-in broad lanes, fallback rules, LEM budgets, and the Hard Compatibility Invariants (including `cancel-in-progress: false` concurrency semantics). |
| [`RUST_TOOLING_CONTROL_PLANE_STANDARD.md`](RUST_TOOLING_CONTROL_PLANE_STANDARD.md) | Long-term Rust tooling contract: `xtask` as the stable public surface, upstream tools as the engine room, risk-routed heavy lanes. |
| [`AGENTS.md`](AGENTS.md) | Operating contract for coding agents: durable artifacts go in `.rails/`, agent dirs are awareness-only, CI rules summary. |
| [`docs/rails.md`](docs/rails.md) / [`docs/rails-overview.md`](docs/rails-overview.md) | Human-facing guide and conceptual overview of the Rails knowledge base. |
| [`docs/contributing/rails.md`](docs/contributing/rails.md) | Contributor workflow for proposals, specs, ADRs, and lanes. |
| [`.rails/index.toml`](.rails/index.toml) | Machine-readable artifact graph — the index of all durable proposals, specs, ADRs, and lanes. |
| [`.rails/policy/ci-lane-whitelist.toml`](.rails/policy/ci-lane-whitelist.toml) | The only CI lanes allowed to exist, with budgets and concurrency semantics. |

## CI model

Exactly one default PR lane plus one opt-in lane:

- **`atlasctl-rust-small`** (`.github/workflows/atlasctl-rust-small.yml`) — the routed default PR lane. A router job discovers org self-hosted runners (`cx43` → `cpx42` → `cx53`) via `EM_RUNNER_READ_TOKEN` and dispatches to the selected lane; a fan-in check (`Atlasctl Rust Small Result`) validates the router and the selected lane. Fork PRs get a tiny GitHub-hosted check-only lane. With no `Cargo.toml` present, lanes report control-plane-only and pass. Same-repo PRs **fail closed** — no silent GitHub-hosted fallback — unless an ack label (below) is applied.
- **`droid-pr-review`** (`.github/workflows/droid-pr-review.yml`) — external AI review, strictly opt-in via the `ai-review`/`full-ci` label or manual dispatch. Requires `MINIMAX_API_KEY` and `FACTORY_API_KEY` secrets.

Guard rails: `.github/scripts/check-no-bare-self-hosted.sh` rejects bare `self-hosted` runner blocks; both workflows use `cancel-in-progress: false` with single-active + single-pending semantics; every job has a timeout.

### Opt-in labels

Registered in [issue #13](https://github.com/EffortlessMetrics/atlasctl-swarm/issues/13):

| Label | Effect |
|---|---|
| `full-ci` | Opt into broad CI lanes; also accepted as an AI-review opt-in. |
| `ci-budget-ack` / `allow-github-hosted` | Acknowledge GitHub-hosted spend so the router may fall back to `ubuntu-latest` when self-hosted capacity or the discovery token is unavailable. |
| `ai-review` | Trigger the Droid AI review workflow on a PR. |

Labels are read from the triggering event's payload — apply the label **before** opening the PR's next event (a label added mid-flight takes effect on the next push or reopen).

## Contributing

Durable decisions (proposals, specs, ADRs, lane trackers, closeouts) live under `.rails/` and are indexed in `.rails/index.toml` — see [`docs/contributing/rails.md`](docs/contributing/rails.md). GitHub issue forms exist for proposals, specs, implementation slices, and policy exceptions. For how the current repository state was consolidated from its founding PRs, see [`docs/alignment-2026-07.md`](docs/alignment-2026-07.md).
