> [!WARNING]
> This repository is AI-assisted and manually reviewed. It now carries the deterministic Erlang first-tranche implementation locally.

# erlang-stakeholder

Erlang deterministic parity port under stakeholder-circus.

## Status
- Full dedicated `classic-six + modern-core` is implemented locally.
- Later families are present as grouped fallback renderers.
- Full live-provider/runtime support remains a required follow-on wave.
- Local-only baseline branch remains unpublished with no upstream tracking.

## Contract
- `--list-values`
- `--focus-family <family>`
- `--output-format text|json`
- `--seed <value>`
- `--experimental-provider <provider>` fail-fast
- orphan experimental flags fail fast

## Local workflow
```bash
python3 scripts/validate_scaffold.py
rebar3 eunit
rebar3 escriptize
./_build/default/bin/erlang-stakeholder --list-values
```

## Documentation
- [STATUS.md](STATUS.md)
- [PARITY.md](PARITY.md)
- [GAPS.md](GAPS.md)
- [docs/toolchain.md](docs/toolchain.md)
- [docs/provenance.md](docs/provenance.md)
- [docs/traceability/first-push-families.md](docs/traceability/first-push-families.md)
