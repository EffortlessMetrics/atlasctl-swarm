#!/usr/bin/env bash
set -euo pipefail

wf="${1:?workflow path required}"

grep -q 'orgs/\${ORG}/actions/runners?per_page=100' "$wf"
! grep -q 'repos/.*/actions/runners' "$wf"
grep -q 'labels: \[self-hosted, linux, x64, em-ci, cpx42, rust-16gb, rust-medium, trusted-pr\]' "$wf"
grep -q 'name: Prepare CPX42 scratch' "$wf"
grep -q 'dtolnay/rust-toolchain@v1' "$wf"
grep -q 'toolchain: 1.95.0' "$wf"
grep -q 'Rust Small on CX43' "$wf"
grep -q 'Rust Small on CX53' "$wf"
grep -q 'Rust Small on GitHub Hosted' "$wf"
grep -q 'Atlasctl Rust Small Result' "$wf"

scratch_line=$(grep -n 'name: Prepare CPX42 scratch' "$wf" | head -n1 | cut -d: -f1)
toolchain_line=$(grep -n 'dtolnay/rust-toolchain@v1' "$wf" | head -n1 | cut -d: -f1)
if (( scratch_line >= toolchain_line )); then
  echo 'CPX42 scratch preparation must be before rust-toolchain setup.' >&2
  exit 1
fi

echo 'Swarm routing policy checks passed.'
