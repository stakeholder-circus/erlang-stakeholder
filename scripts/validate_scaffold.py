from pathlib import Path
required = [
    'README.md',
    'AI_DISCLOSURE.md',
    'PARITY.md',
    'GAPS.md',
    'STATUS.md',
    'AGENTS.md',
    'rebar.config',
    'src/erlang_stakeholder.erl',
    'src/erlang_stakeholder_runtime.erl',
    'src/erlang_stakeholder_catalog.erl',
    'src/erlang_stakeholder_json.erl',
    'src/erlang_stakeholder_app.erl',
    'src/erlang_stakeholder_sup.erl',
    'src/erlang_stakeholder.app.src',
    'test/erlang_stakeholder_tests.erl',
    'docs/remotes.md',
    'docs/provenance.md',
    'docs/toolchain.md',
    'docs/traceability/first-push-families.md',
    '.githooks/commit-msg',
    '.githooks/pre-push',
    '.github/CODEOWNERS',
    '.github/PULL_REQUEST_TEMPLATE.md',
    '.github/dependabot.yml',
    '.github/workflows/actionlint.yml',
    '.github/workflows/dependency-review.yml',
    '.github/workflows/ci.yml',
    '.github/workflows/ci-native.yml',
    '.github/workflows/docker-smoke.yml',
    'flake.nix',
    'Dockerfile',
    'flake.lock'
]
missing = [p for p in required if not Path(p).exists()]
if missing:
    raise SystemExit('missing tranche files: ' + ', '.join(missing))
print('erlang tranche validated')
