# neopackages

The package registry consumed by the [`neo` CLI](https://github.com/NeoHaskell/neocli).
`neo` fetches `registry.json` from `main`, looks up each bare dependency from a
project's `neo.json`, and resolves it to a git URL + SHA for `cabal.project`.

## Files

- `registry.json` — the registry itself.
- `registry.schema.json` — JSON Schema (Draft 2020-12) describing the structure of `registry.json`.

## Schema shape

```jsonc
{
  "packages": {
    "<package-name>": {
      "description": "One-line human-readable description.",
      "repository": "https://github.com/<owner>/<repo>",
      "versions": {
        "<semver>": { "sha": "<git-sha>", "tag": "<upstream-tag>" }
      }
    }
  }
}
```

Constraints (enforced by `registry.schema.json`):

- `packages` keys are lowercase, `[a-z0-9][a-z0-9._-]*`.
- `repository` is a git URL (`https://…`, `git@…`, `ssh://…`, `git+…`).
- `versions` keys are valid semver (e.g. `1.2.3`, `0.1.0-beta.1`).
- `sha` is a 7–40 char hex git SHA.
- `tag` is the upstream git tag (informational — `sha` is the source of truth).

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
