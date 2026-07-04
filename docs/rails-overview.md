# The Rails framework, fully explained

> This is the conceptual overview of Rails, this repo's durable source-of-truth
> framework. For the short reference see [`docs/rails.md`](rails.md); for the
> contributor workflow see [`docs/contributing/rails.md`](contributing/rails.md).
> The framework itself lives under `.rails/`.

Rails is a **repo source-of-truth stack**. Its central rule is:

> **Do not make every document do every job.**

Each artifact owns one kind of truth: **why**, **what**, **what decision**, **how**, **what now**, **what proves it**, and **what changed**.

The end result is a repo where a human, Codex, Droid, Claude, or CI can answer:

```text
Why are we doing this?
What exact behavior must be true?
What architecture decision did we make?
What PR-sized work comes next?
What is the active lane right now?
What proves the claim?
Which support claims changed?
Which policy ledgers changed?
What happened after merge?
```

---

## The stack at a glance

```text
Proposal
  -> Specs
    -> ADRs where needed
      -> Lane implementation plan
        -> Lane tracker (active work items)
          -> Issues / PRs
            -> Proof commands
            -> CI lanes
            -> support claim-map updates
            -> policy receipts
              -> Closeout / handoff
```

Each layer narrows the previous one.

- **Proposal**: why this initiative should exist
- **Spec**: behavior contract
- **ADR**: architecture decision
- **Lane plan**: PR sequence
- **Lane tracker**: what is being executed now
- **Support claim map**: what users may believe
- **Policy ledger**: exceptions and obligations
- **Closeout**: what actually happened

---

## The artifact split

- **Proposal** (`.rails/proposals/`) owns the problem, users, success criteria, alternatives, and risks.
- **Spec** (`.rails/specs/`) owns required behavior, non-goals, required evidence, and promotion rules.
- **ADR** (`.rails/adr/`) owns durable architecture decisions and consequences.
- **Lane implementation plan** (`.rails/lanes/<lane>/implementation-plan.md`) owns PR-sized sequencing and proof commands.
- **Lane tracker** (`.rails/lanes/<lane>/tracker.toml`) owns current execution state.
- **Support claim map** (`.rails/support/claim-map.toml`) owns claim-to-proof mapping.
- **Policy ledgers** (`.rails/policy/`) own governed exceptions and CI/package policies.
- **Closeout** (`.rails/closeouts/`) owns what landed and what remains.
- **Index** (`.rails/index.toml`) owns the artifact graph: every owned artifact, its ID, path, status, and links.

---

## Core operating principles

1. **One artifact, one kind of truth.**
2. **Specs are contracts, not queues.**
3. **Plans are PR-sized and executable.**
4. **Claims must be proof-mapped.**
5. **Policy exceptions are ledgers, not vibes.**
6. **Agent state must be machine-readable** (lane trackers and the index are TOML).
7. **Do not encode fake repo rules.**
8. **Verify named commands, lanes, crates, and policies before relying on them.**

---

## Canonical source-of-truth map

| Truth | Source of truth |
|---|---|
| Artifact graph | `.rails/index.toml` |
| Product claim stability | `.rails/support/claim-map.toml` |
| Policy ledger references | `.rails/policy/ledgers.toml` |
| CI lane policy | `.rails/policy/ci-lane-whitelist.toml` |
| Package classification | `.rails/policy/package-boundary.toml` |
| Non-Rust file exceptions | `.rails/policy/non-rust-allowlist.toml` |
| Clippy policy | `.rails/policy/clippy-lints.toml` |
| Clippy exception receipts | `.rails/policy/clippy-exceptions.toml` |
| Panic exceptions | `.rails/policy/no-panic-allowlist.toml` |
| Active work | `.rails/lanes/<lane>/tracker.toml` |
| PR order | `.rails/lanes/<lane>/implementation-plan.md` |
| Initiative why | `.rails/proposals/ATLAS-PROP-*.md` |
| Behavior contract | `.rails/specs/ATLAS-SPEC-*.md` |
| Architecture decision | `.rails/adr/ATLAS-ADR-*.md` |
| CI cost policy | `EMERGENCY_CI_COST_REDUCTION_PLAN.md` |
| Rust tooling control plane | `RUST_TOOLING_CONTROL_PLANE_STANDARD.md` |

ID conventions come from `.rails/index.toml`: `ATLAS-PROP`, `ATLAS-SPEC`, `ATLAS-ADR`, `ATLAS-LANE`.

External namespaces (`.codex/`, `.spec/`, `.claude/`, `.jules/`) are awareness-only tool/agent spaces. Rails never owns, migrates, or validates them.

---

## Recommended rollout for a new lane

1. Write the proposal under `.rails/proposals/` (use `.rails/templates/proposal.md`).
2. Write the spec under `.rails/specs/` (use `.rails/templates/spec.md`).
3. Record any durable decision as an ADR under `.rails/adr/`.
4. Register all three in `.rails/index.toml` with links.
5. Create the lane: `.rails/lanes/<lane>/tracker.toml` and `implementation-plan.md` (templates exist for both).
6. Map any new product claims in `.rails/support/claim-map.toml`.
7. Record policy impact in the ledgers under `.rails/policy/` and reference them from `.rails/policy/ledgers.toml`.
8. On completion, write a closeout under `.rails/closeouts/` and update artifact statuses in the index.

Validation starts advisory and human-enforced; promote checks to CI only within the CI cost policy (see `EMERGENCY_CI_COST_REDUCTION_PLAN.md`).

---

## Short mental model

```text
Proposal = why.
Spec = what.
ADR = durable decision.
Lane plan = how.
Lane tracker = what is active now.
Support claim map = what users may believe.
Policy ledgers = what exceptions and proof obligations exist.
CI = what proved it.
Closeout = what happened.
```

The system works when layers are linked in `.rails/index.toml`, validated, and avoid duplication.
