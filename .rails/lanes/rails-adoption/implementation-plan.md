# Rails Adoption Implementation Plan

## Goal

Adopt the `.rails/` framework footprint and establish an initial artifact graph.

## PR sequence

1. Add `.rails/` root artifacts and human-facing docs.
2. Add templates for durable artifacts.
3. Add seed proposal/spec/ADR and lane tracker artifacts.

## Proof strategy

- Run `git diff --check` before merging.

## Risks and mitigations

- Risk: artifact drift.
  - Mitigation: require index links for each owned artifact.
