# ATLASCTL-SPEC-0001: Source-of-truth stack

Status: accepted
Owner: repo-infra
Created: 2026-05-20
Linked proposal: ATLASCTL-PROP-0001-source-of-truth-contract-stack
Linked ADRs:
- none
Linked plan:
- plans/0.1.0/implementation-plan.md
Linked issues:
- none
Linked PRs:
- none
Support-tier impact: stabilizing
Policy impact:
- policy/doc-artifacts.toml

## Problem

Repository initiatives need enforceable links among why, what, how, now, and proof.

## Behavior

The repository must maintain linked proposal/spec/plan/goal artifacts and policy ledgers.

## Non-goals

Implementation of all validators in this initial scaffold PR.

## Required evidence

`git diff --check` passes and artifact links resolve in `policy/doc-artifacts.toml`.
