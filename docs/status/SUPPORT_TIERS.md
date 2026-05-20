# Support tiers

This file maps product claims to proof commands.

## Tier definitions

| Tier | Meaning |
|---|---|
| Stable | User-facing claim is supported by required CI proof. |
| Stabilizing | Works for documented cases; still limited or advisory. |
| Experimental | Available for exploration; no broad product claim. |
| Advisory | Reports information but does not block. |
| Not supported | Explicitly not claimed. |

## Claim map

| Surface | Tier | Claim | Proof command | Notes |
|---|---|---|---|---|
| Source-of-truth artifacts | Stabilizing | Linked proposal/spec/ADR/plan/goal artifacts exist. | `cargo xtask check-doc-artifacts` | Command planned; CI currently advisory. |
| Active goal manifest | Stabilizing | One active goal with valid work-item state is maintained. | `cargo xtask check-goals` | Command planned; CI currently advisory. |
| Policy contracts lane | Advisory | Policy checks are executed on PRs and pushes. | `github workflow: Policy Contracts` | Starts advisory during migration. |
