#!/usr/bin/env bash
# Every skill in skills/ carries the same reading harness between the
# <!-- shared:harness … --> and <!-- /shared:harness --> markers, so each
# skill still works when copied on its own. This checks the copies match.
set -euo pipefail
cd "$(dirname "$0")/.."

block() { sed -n '/<!-- shared:harness/,/<!-- \/shared:harness -->/p' "$1"; }

ref_file=""
ref=""
status=0
count=0
for f in skills/*/SKILL.md; do
  count=$((count + 1))
  b=$(block "$f")
  if [ -z "$b" ]; then
    echo "missing shared block: $f"
    status=1
  elif [ -z "$ref_file" ]; then
    ref_file=$f
    ref=$b
  elif [ "$b" != "$ref" ]; then
    echo "differs from $ref_file: $f"
    diff <(printf '%s\n' "$ref") <(printf '%s\n' "$b") || true
    status=1
  fi
done

if [ "$status" -eq 0 ]; then
  echo "shared harness identical in $count skills"
fi
exit "$status"
