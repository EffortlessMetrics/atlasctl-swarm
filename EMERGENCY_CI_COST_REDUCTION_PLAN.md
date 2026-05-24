# Emergency CI Cost-Reduction Plan (EffortlessMetrics)

## Objective
Immediately reduce GitHub-hosted Actions spend by making default PR CI intentionally minimal and forcing all expensive lanes behind explicit opt-in controls.

## Critical Clarification
- Self-hosted runners **still execute through GitHub Actions workflows**.
- You cannot disable GitHub Actions and keep self-hosted CI alive.
- Cost control is achieved by changing job runner labels from GitHub-hosted labels (`ubuntu-latest`, `windows-latest`, `macos-latest`) to self-hosted labels, not by disabling Actions.

## Default PR Policy (Emergency)
- Run **exactly one** lightweight PR lane by default.
- Prefer self-hosted routed runners (`cpx42`, `cx43`, `cx53`) for Rust small checks.
- Include only: format/lint check, `cargo check`, focused `cargo test`, and `git diff --check`.
- Disable default PR execution of OS matrices, release builds, broad docs, audit sweeps, BDD/fuzz/mutation/coverage, AI review, and hardware/GPU lanes.

## Fallback Policy
- No silent full fallback to GitHub-hosted runners.
- Fork PRs: tiny safe GitHub-hosted fallback only (check/syntax, no secrets).
- No idle self-hosted capacity: fail/queue with explicit reason rather than launching broad GitHub-hosted jobs.
- Full GitHub-hosted fallback allowed only with explicit label (`allow-github-hosted` or `ci-budget-ack`) or maintainer dispatch override.

## Trigger and Gating Policy
- Full CI is opt-in only via:
  - `full-ci` label,
  - `workflow_dispatch`,
  - merge queue,
  - release/tag events,
  - justified schedule.
- If repo has routed PR workflow + legacy CI workflow, legacy CI must not run broad jobs for unlabeled PRs.
- Use gating expression on broad jobs:

```yaml
if: github.event_name != 'pull_request' || contains(github.event.pull_request.labels.*.name, 'full-ci')
```

## Budget Enforcement Targets
- Preferred default PR lane: `<= 25` Linux-equivalent minutes (LEM).
- Hard default PR lane limit: `<= 35` LEM.
- Above default limit: fail early with instruction to use `full-ci`, `ci-budget-ack`, or manual dispatch.

## Emergency Rollout Phases

### Phase 0: Inventory
Audit all workflow files across repos and flag:
- default PR `ubuntu-latest`/`windows-latest`/`macos-latest`,
- self-hosted fallback to broad GitHub-hosted runs,
- fast schedules,
- `upload-artifact` with `if: always()`,
- `workflow_run` fan-out,
- external AI review on PR,
- default PR fuzz/coverage/mutation/BDD,
- default PR release/cross-platform builds.

### Phase 1: PR Slimming
- Keep one routed `rust-small` PR path per Rust repo.
- For swarm repos, set all CI jobs to self-hosted (`runs-on: self-hosted` or org-specific self-hosted labels) and remove GitHub-hosted redundancy.
- Gate or remove broad PR CI from legacy `ci.yml`.
- Start with highest-cost repos (shipper, shiplog), then hardware-heavy repos (BitNet-rs), then small tools.

### Phase 2: Enforced Budgets
- Promote budget/lanes policy from advisory to enforced.
- Deterministic lane selection by file changes (docs-only vs Rust source vs workflow/policy vs release/hardware touches).

### Phase 3: Routing/Fallback Hardening
- Fail on runner auth/config errors (do not expand spend with silent fallback).
- Keep fallback lane tiny and explicit.
- Emit clear route summary (target, trusted status, reason, estimated LEM, fallback allowed).

### Phase 4: Cache/Artifacts/Actuals
- Minimize GitHub-hosted cache scope.
- Prefer persistent self-hosted cache paths.
- Artifacts only on failure unless release output.
- Temporarily reduce CI Actuals fan-out to main/schedule/manual.

## Definition of Done
- No default PR `windows-latest` or `macos-latest`.
- No default PR cross-platform matrix or release builds.
- No default PR broad fuzz/mutation/coverage/BDD/external AI review.
- No duplicate default PR execution of routed + legacy broad CI.
- No silent GitHub-hosted fallback.
- Default PR path constrained to preferred/hard LEM thresholds.
