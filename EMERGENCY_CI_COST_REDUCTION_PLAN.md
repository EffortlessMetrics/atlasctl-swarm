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

## Long-Term Tooling Standard

After the emergency cost controls are in place, use [`RUST_TOOLING_CONTROL_PLANE_STANDARD.md`](RUST_TOOLING_CONTROL_PLANE_STANDARD.md) as the durable Rust tooling contract: `xtask` is the public repo surface, upstream tools are the engine room, and heavyweight proof lanes are risk-routed rather than default PR tax.

## Definition of Done
- No default PR `windows-latest` or `macos-latest`.
- No default PR cross-platform matrix or release builds.
- No default PR broad fuzz/mutation/coverage/BDD/external AI review.
- No duplicate default PR execution of routed + legacy broad CI.
- No silent GitHub-hosted fallback.
- Default PR path constrained to preferred/hard LEM thresholds.

## Hard Compatibility Invariants (Codex CI-Efficiency Brief Addendum)

> Do not optimize CI by blindly canceling active work or by routing metadata edits through Rust.
> Optimize by classifying changes correctly, keeping one active run, one pending replacement slot, and making default PR paths tiny.

### 1) Concurrency semantics (heavy/core workflows)
- For heavy/core PR workflows, do **not** use `cancel-in-progress: true`.
- Required semantics are **single active run + single pending replacement slot**:
  - if one run is already executing, let it continue;
  - if a newer commit arrives, queue the newer run;
  - if another newer commit arrives while one is pending, replace the older pending run;
  - when active run finishes, run the latest pending one.
- Canonical pattern:

```yaml
concurrency:
  group: ${{ github.workflow }}-${{ github.event.pull_request.number || github.ref }}
  cancel-in-progress: false
```

- Do not submit “efficiency” PRs that cancel active Rust/core CI runs unless repo policy explicitly marks that workflow safe to cancel.

### 2) Change classification (metadata/control-plane must stay light)
- Do not treat all changed files as Rust-code changes.
- Metadata/control-plane changes must route to docs/policy/light CI paths.
- Changes that should remain light (unless mixed with real Rust/build/test edits):
  - `docs/**`
  - `*.md`
  - `README*`, `CHANGELOG*`, `SECURITY*`, `CONTRIBUTING*`
  - `policy/**`
  - `plans/**`
  - `badges/**`
  - `AGENTS.md`
  - `.github/CODEOWNERS`
  - `.github/dependabot.yml`
  - `.github/pull_request_template.md`
  - `.github/PULL_REQUEST_TEMPLATE/**`
  - `.codex/campaigns/**`
  - `docs/tracking/**`
  - `ci/hardware/**` receipt files
  - `.rails/**`
  - `.uselesskey/**`
- Workflow-file edits remain special:
  - `.github/workflows/**` must not route through docs-light;
  - route to minimal hosted workflow-validation/safety path, not full Rust CI unless required.

### 3) Default PR routing policy
- Classify first, then choose the cheapest truthful lane.
- `docs/control-plane-only` -> no Rust compile.
- `workflow-only` -> hosted YAML/workflow validation, no full Rust.
- `Rust source/build/test touched` -> routed `rust-small`.
- `hardware/GPU/receipt-only` -> syntax/receipt validation only.
- `unknown or mixed changes` -> `rust-small`, not full CI.
- Full CI requires explicit gate (label, manual dispatch, main push, release, schedule, or merge queue).

### 4) Hosted fallback policy
- Do not silently turn self-hosted `rust-small` into full GitHub-hosted Rust lanes.
- Fork PRs may use tiny hosted safe lane only.
- Runner readiness/token/idle-capacity failures must not trigger 75–120 minute hosted equivalents.
- Require explicit labels/inputs for expensive hosted fallback:
  - `full-ci`
  - `allow-github-hosted`
  - `ci-budget-ack`

### 5) Artifacts policy
- Do not always upload receipts/JUnit/log artifacts on default PR CI unless tiny and required by merge policy.
- Prefer upload-on-failure with 3–7 day retention.
- If receipts are required for policy, keep them small and avoid docs/control-plane upload paths.

### 6) Required testing for CI-only efficiency PRs
Every CI-efficiency PR must include:
- `git diff --check`
- YAML parse check for edited workflows
- classification dry-run/shell-unit tests covering:
  - docs-only
  - `.rails/**`
  - `.uselesskey/**`
  - workflow-file change
  - Rust-file change
  - mixed docs + Rust
- confirmation that concurrency did not regress from no-cancel semantics unless intentionally documented.

### Reviewer rejection checklist (must-answer)
Reject CI-efficiency PRs unless they explicitly answer all of:
1. Does this preserve `cancel-in-progress: false` for heavy/core CI?
2. Does this avoid Rust CI for metadata/control-plane-only edits?
3. Does this keep workflow changes out of docs-light?
4. Does this avoid silent expensive hosted fallback?
5. Does this reduce actual billable work (not just move it)?
