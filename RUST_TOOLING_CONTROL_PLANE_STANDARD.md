# Rust Tooling Control Plane Standard

## Purpose

This standard defines the repo-facing Rust quality, policy, and CI control plane for EffortlessMetrics repositories.

The core rule is simple:

```text
Standardize upstream engines.
Standardize repo-facing wrappers.
Do not make upstream tools the repo's public control surface.
```

In practice, contributors and CI should invoke stable `cargo xtask ...` commands. Upstream tools should remain the implementation substrate behind those wrappers.

## Control-Plane Doctrine

- `xtask` is the repo policy and orchestration surface.
- `cargo-allow` owns source exception receipts and policy waivers.
- `ripr` provides cheap PR-time static mutation-exposure signal.
- `unsafe-review` makes unsafe changes reviewable by requiring safety contracts, guards, test reach, and witness routes.
- Heavy runtime proof lanes are routed by risk, labels, schedule, release, or maintainer dispatch instead of running on every ordinary PR.

## Standard Upstream Substrates

| Plane | Standard upstream tools | Default role |
| --- | --- | --- |
| Syntax and codemods | `ast-grep`; rust-analyzer crates for Rust-specific authority | Find structural candidates cheaply; use Rust-aware data for authoritative Rust identity. |
| Workspace graph | `cargo_metadata`, `guppy` | Inventory packages/targets and compute dependency, reverse-dependency, feature, release, and CI lane scopes. |
| Test execution | `cargo-nextest`, `cargo test --doc` | Run default PR tests with nextest; keep doctests separate. |
| Coverage | `cargo-llvm-cov` | Produce execution-surface evidence and coverage artifacts without treating coverage as correctness proof. |
| Mutation | `ripr`, `cargo-mutants` | Shift mutation signal left with `ripr`; use runtime mutation as targeted/nightly/release backstop. |
| Unsafe and UB | `unsafe-review`, Miri | Review unsafe contracts statically; use Miri for targeted concrete UB witnesses. |
| Source exceptions | `cargo-allow` | Keep durable exception receipts rather than hidden policy bypasses. |
| Dependency trust | `cargo-deny`, `cargo-vet`, RustSec/`cargo-audit`, `cargo-auditable` | Gate dependency policy, advisories, audits, and shipped-binary auditable metadata. |
| Public API and release | `cargo-semver-checks`, rustdoc JSON | Gate public API compatibility and generate custom API surface facts when needed. |
| Workflow policy | `actionlint`, `zizmor` | Check GitHub Actions correctness and security posture. |
| Text and config hygiene | `taplo`, `typos`, Markdown link/style tooling | Keep TOML, spelling, and documentation hygiene consistent. |
| Workspace hygiene | `cargo-udeps` scheduled; `cargo-hakari` only for large workspaces | Avoid unused dependencies and duplicate-build churn only when the repo's scale justifies it. |
| CI cache | `Swatinem/rust-cache` by default; `sccache` only when justified | Keep CI cache economics explicit rather than cargo-culting heavier cache infrastructure. |

## Standard `xtask` Surface

Every Rust repo should expose stable wrappers where applicable:

```bash
cargo xtask check-pr
cargo xtask fix-pr
cargo xtask pr-summary

cargo xtask allow-check
cargo xtask allow-diff
cargo xtask ripr-pr
cargo xtask unsafe-review-pr

cargo xtask test-pr
cargo xtask coverage
cargo xtask mutation-targeted
cargo xtask miri-targeted

cargo xtask check-deps
cargo xtask check-supply-chain
cargo xtask semver-check
cargo xtask check-workflows
cargo xtask check-toml
cargo xtask policy-report
```

These command names are the repo contract. Their internal implementation can evolve as upstream tools change.

## Default PR Lane

The default PR lane should optimize proof per minute:

1. Run formatting and lint checks.
2. Run `cargo check` or the repo's equivalent fast compile check.
3. Run `cargo xtask test-pr`, backed by `cargo-nextest` plus focused doctests when appropriate.
4. Run source exception, static mutation-exposure, unsafe-review, dependency, workflow, TOML, spelling, or Markdown checks only when the changed files and repo maturity justify them.
5. Emit a route summary that explains which lanes ran, which lanes were skipped, and why.

Full coverage, broad mutation, full Miri, cross-platform matrices, release builds, and large supply-chain sweeps should not be ordinary default PR tax.

## Risk-Routed Backstops

Use heavier lanes when a risk trigger justifies them:

- `ripr` should run on PRs with Rust behavior changes and produce repair packets or review artifacts.
- `cargo-mutants` should run for targeted PR mutation, nightly mutation matrices, and release readiness.
- `unsafe-review` should run for unsafe changes, with optional Miri witness lanes where concrete UB checks are valuable.
- `cargo-llvm-cov` should run for coverage receipts, release snapshots, or explicit coverage workflows.
- `cargo-deny` should be the default dependency policy gate; `cargo-vet` should be introduced for mature or high-risk repos with public release obligations.
- `cargo-semver-checks` should run for public crates during release preparation and compatibility-sensitive changes.

## Source Inventory and Policy Identity

Policy scans should start from the tracked source inventory:

```bash
git ls-files -z
```

Use `ast-grep` for fast structural candidates and codemod opportunities. Use Rust-aware tooling, such as rust-analyzer crates or Cargo metadata, when policy decisions require stable Rust identity across formatting and refactors.

## Tooling Maturity Guidance

- Baseline every serious Rust repo with `rustfmt`, Clippy, nextest-backed tests, dependency policy, and stable `xtask` wrappers.
- Add `ripr`, `unsafe-review`, workflow linting, TOML linting, spelling, and Markdown checks as repo policy matures.
- Add `cargo-vet`, `cargo-auditable`, scheduled `cargo-udeps`, `cargo-hakari`, or `sccache` only when release risk, binary distribution, workspace scale, or cache economics justify them.
- Keep exceptions receipted and reviewable instead of scattering bespoke suppressions through YAML and scripts.

## Relationship to Emergency CI Cost Reduction

This standard complements the emergency CI cost-reduction policy: default PRs remain small, self-hosted routing remains explicit, and heavyweight proof is opt-in or risk-routed. The long-term contract is that `xtask` chooses and documents the correct proof lane rather than each workflow independently invoking ad hoc tool commands.
