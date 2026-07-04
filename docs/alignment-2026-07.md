# Alignment record — July 2026 PR consolidation

This repo accumulated nine open PRs from parallel agent sessions, several of which overlapped or contradicted each other and the merged CI cost plan. This record documents how they were reconciled, so future sessions don't re-litigate the decisions.

## Merged

| PR | What | Alignment work done before merge |
|---|---|---|
| #12 | `RUST_TOOLING_CONTROL_PLANE_STANDARD.md` + plan link | None needed — verified consistent with the emergency plan (default PR stays minimal, self-hosted routing explicit). |
| #8 | Hard Compatibility Invariants section in the emergency plan | None needed — verified conflict-free with #12 (disjoint insertion points) and additive to main. |
| #4 | `.rails/` durable knowledge base | None needed — chosen over competing structures (see below). |
| #10 | Routed `atlasctl-rust-small` workflow + bare-self-hosted guard | Aligned post-review: added `cancel-in-progress: false` concurrency, per-job timeouts, ack-label-gated hosted fallback for the missing-token and no-idle-runner paths (previously silent fallback / hard fail), and a check-only `mode` for the fork/GitHub lane. |
| #11 | Droid AI review (MiniMax BYOK) | Reworked from run-on-every-PR to strictly opt-in (`workflow_dispatch` + `ai-review`/`full-ci` label gate), `cancel-in-progress: false`, timeout, and fixed the `settings.json` generation bug where the API key was written literally instead of expanded (and the secret wasn't exposed to that step at all). |
| #14 | Grafts from closed PRs onto `.rails/` | New PR created for this consolidation: overview essay (from #2), issue forms + PR template (from #1, converted to valid issue-form syntax), policy ledgers under `.rails/policy/` incl. the CI lane whitelist, and `AGENTS.md`. |

## Closed as superseded

| PR | Reason |
|---|---|
| #1 | Stored durable governance in `.codex/goals/` (forbidden by the adopted model — agent dirs are awareness-only) and its `policy-contracts.yml` added an unconditioned `ubuntu-latest` PR lane, violating the cost plan. Valuable parts (issue forms, PR template, policy ledgers, AGENTS.md) grafted via #14. |
| #2 | Overview essay only, no structure; carried over as `docs/rails-overview.md` via #14. |
| #3 | Same artifact-graph design as #4 but with one-line stub templates/schemas and a repo-specific namespace (`.atlasctl-swarm-spec/`); #4 strictly dominates. |
| #5 | Duplicate of #10's routed workflow with weaker properties everywhere judged: name-only runner matching, silent GitHub-hosted fallback on missing token/API errors/no idle runner, weaker fan-in check, duplicated no-Cargo.toml handling. Merging both would also have doubled default PR CI. |
| #6 | Echo-only "efficiency" workflow whose `cancel-in-progress: true` directly violated the invariants merged via #8; enforced nothing. |

## Verified live

The routed lane was exercised end-to-end on PR #14 (this repo has no `Cargo.toml`, so lanes run control-plane-only):

- **Fail-closed path**: without an ack label, the router found `EM_RUNNER_READ_TOKEN` configured, discovered no idle `em-ci` runner, and failed with "failing rather than expanding hosted spend" — the intended doctrine behavior.
- **Acked-fallback path**: with `ci-budget-ack` applied (and a reopen so the label was in the event payload), the router selected the GitHub lane with reason `no_idle_runner_hosted_acked`, the composite action reported control-plane-only, and the `Atlasctl Rust Small Result` fan-in check passed.

## Known follow-ups

- `Factory-AI/droid-action@main` is a mutable ref; pin to a vetted release SHA (TODO comment in the workflow).
- The droid lane needs `MINIMAX_API_KEY` and `FACTORY_API_KEY` secrets before its first labeled run.
- No idle `em-ci` self-hosted runners were online at verification time; once `cx43`/`cpx42`/`cx53` are registered with `em-ci` + capacity labels, default PRs will route to them and the ack labels become unnecessary for routine work.
- Opt-in labels are read from the triggering event payload; labels added after the event require a new push/reopen to take effect.
