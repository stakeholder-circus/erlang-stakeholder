# Erlang Toolchain

- State: deterministic first tranche implemented locally
- Toolchain source: `built-in`

## Native commands
- `erl -eval 'erlang:display(erlang:system_info(otp_release)), halt().' -noshell`
- `rebar3 version`
- `python3 scripts/validate_scaffold.py`
- `rebar3 eunit`
- `rebar3 escriptize`

## Docker commands
- `docker build -t erlang-stakeholder .`
- `docker run --rm erlang-stakeholder --list-values`

## Current limitation
- The deterministic tranche is implemented; live-provider/runtime work remains deferred.
