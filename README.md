# neopackages

The package registry consumed by the [`neo` CLI](https://github.com/NeoHaskell/neocli).
`neo` fetches `registry.json` from `main`, looks up each bare dependency from a
project's `neo.json`, then runs `git ls-remote --tags <repository>` to enumerate
the available versions and pick the highest tag satisfying the constraint. The
registry does **not** list versions — git tags on the upstream repo are the
source of truth.

## Files

- `registry.json` — the registry itself.
- `registry.schema.json` — JSON Schema (Draft 2020-12) describing the structure of `registry.json`.

## Schema shape

```jsonc
{
  "packages": {
    "<package-name>": {
      "description": "One-line human-readable description.",
      "repository": "https://github.com/<owner>/<repo>"
    }
  }
}
```

Constraints (enforced by `registry.schema.json`):

- `packages` keys are lowercase, `[a-z0-9][a-z0-9._-]*`.
- `repository` is a git URL (`https://…`, `git@…`, `ssh://…`, `git+…`).

Versions come from the upstream repo's git tags. The CLI accepts tags in the
shape `1.2.3` or `v1.2.3` (the leading `v`, if present, is stripped before
semver parsing).

## Validating locally

```sh
scripts/validate.sh
```

Requires [`check-jsonschema`](https://github.com/python-jsonschema/check-jsonschema)
on `PATH`. Install with one of:

```sh
pipx install check-jsonschema
pip install --user check-jsonschema
uv tool install check-jsonschema
```

## CI

`.github/workflows/validate.yml` runs the same schema check on every push and
pull request to `main`. A PR that breaks the schema will fail CI.
