# The spec/proposal system, fully explained

The system is a **repo source-of-truth stack**. Its central rule is:

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
Which support tier changed?
Which policy ledgers changed?
What happened after merge?
```

---

## The stack at a glance

```text
Roadmap
  -> Proposal / PRD
    -> Specs
      -> ADRs where needed
        -> Implementation plan
          -> Active goal manifest
            -> Issues / PRs
              -> Proof commands
              -> CI lanes
              -> support-tier updates
              -> policy receipts
                -> Closeout / handoff
```

Each layer narrows the previous one.

- **Roadmap**: direction
- **Proposal**: why this initiative should exist
- **Spec**: behavior contract
- **ADR**: architecture decision
- **Plan**: PR sequence
- **Active goal**: what the agent is doing now
- **Support tiers**: what users may believe
- **Policy ledger**: exceptions and obligations
- **Closeout**: what actually happened

---

## The artifact split

- **Proposal / PRD** owns the problem, users, success criteria, alternatives, and risks.
- **Spec** owns required behavior, non-goals, required evidence, and promotion rules.
- **ADR** owns durable architecture decisions and consequences.
- **Implementation plan** owns PR-sized sequencing and proof commands.
- **Active goal manifest** owns current execution state.
- **Support tiers** own claim-to-proof mapping.
- **Policy ledgers** own governed exceptions and CI/package policies.
- **Closeout** owns what landed and what remains.

---

## Core operating principles

1. **One artifact, one kind of truth.**
2. **Specs are contracts, not queues.**
3. **Plans are PR-sized and executable.**
4. **Claims must be proof-mapped.**
5. **Policy exceptions are ledgers, not vibes.**
6. **Agent state must be machine-readable.**
7. **Do not encode fake repo rules.**
8. **Verify named commands, lanes, crates, and policies before relying on them.**

---

## Canonical source-of-truth map

| Truth | Source of truth |
|---|---|
| Product claim stability | `docs/status/SUPPORT_TIERS.md` |
| CI lane policy | `policy/ci-lane-whitelist.toml` |
| Package classification | `policy/package-boundary.toml` |
| File exceptions | `policy/non-rust-allowlist.toml` |
| Clippy policy | `policy/clippy-lints.toml` |
| Panic exceptions | `policy/no-panic-allowlist.toml` |
| Active Codex work | `.codex/goals/active.toml` |
| PR order | `plans/<milestone>/implementation-plan.md` |
| Initiative why | `docs/proposals/<REPO>-PROP-*.md` |
| Behavior contract | `docs/specs/<REPO>-SPEC-*.md` |
| Architecture decision | `docs/adr/<REPO>-ADR-*.md` |

---

## Recommended minimal rollout

1. Define doc model and templates.
2. Add `policy/doc-artifacts.toml`.
3. Add `cargo xtask check-doc-artifacts`.
4. Add `.codex/goals/active.toml`.
5. Add `cargo xtask check-goals`.
6. Add first proposal.
7. Add first spec.
8. Add support tiers.
9. Add package/CI/policy ledgers.
10. Wire CI checks (advisory first, then blocking).

---

## Short mental model

```text
Proposal = why.
Spec = what.
ADR = durable decision.
Plan = how.
Active goal = what Codex is doing now.
Support tiers = what users may believe.
Policy ledgers = what exceptions and proof obligations exist.
CI = what proved it.
Closeout = what happened.
```

The system works when layers are linked, validated, and avoid duplication.
