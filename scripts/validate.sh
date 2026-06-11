#!/usr/bin/env bash
# Validate registry.json against registry.schema.json.
#
# Usage:
#   scripts/validate.sh              # validate registry.json
#   scripts/validate.sh path.json    # validate another file
#
# Requires `check-jsonschema` on PATH. Install with one of:
#   pipx install check-jsonschema
#   pip install --user check-jsonschema
#   uv tool install check-jsonschema

set -euo pipefail

cd "$(dirname "$0")/.."

target="${1:-registry.json}"
schema="registry.schema.json"

if ! command -v check-jsonschema >/dev/null 2>&1; then
  echo "error: \`check-jsonschema\` not on PATH." >&2
  echo "       Install it with one of:" >&2
  echo "         pipx install check-jsonschema" >&2
  echo "         pip install --user check-jsonschema" >&2
  echo "         uv tool install check-jsonschema" >&2
  exit 127
fi

echo "validating $target against $schema"
check-jsonschema --schemafile "$schema" "$target"
echo "ok: $target conforms to $schema"
