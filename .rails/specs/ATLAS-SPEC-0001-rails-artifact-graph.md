# ATLAS-SPEC-0001: Rails Artifact Graph Contract

Status: accepted
Owner: core
Created: 2026-05-21
Linked proposal: ATLAS-PROP-0001
Linked ADRs: ATLAS-ADR-0001
Linked lane: rails-adoption
Linked issues:
Linked PRs:
Support-tier impact: none
Policy impact: reference-only

## Problem

Without a graph contract, durable artifacts can become inconsistent, unlinked, or mixed with external tool state.

## Behavior

- Rails artifacts must be indexed through `.rails/index.toml`.
- Owned artifact paths must live under `.rails/`.
- External namespaces may be listed for awareness but not owned as artifacts.
- Specs define behavior contracts, not global PR order.
- Focused lane trackers define implementation sequencing.

## Non-goals

Defining external tool namespace schema or lifecycle.

## Required evidence

- `git diff --check`

## Acceptance examples

- `[[artifact]]` entries point only to `.rails/` paths.
- `[[lane]]` entries reference tracker files under `.rails/lanes/`.

## Test mapping

Repository policy checks and future xtask validators.

## Implementation mapping

- `.rails/index.toml`
- `.rails/lanes/*/tracker.toml`
- Rails documentation under `docs/`

## CI proof

- `git diff --check`

## Metrics / promotion rule

Stable once all newly added durable artifacts are index-linked and ownership boundaries are documented.

## Failure modes

Paths under external namespaces being declared as Rails-owned artifacts.
