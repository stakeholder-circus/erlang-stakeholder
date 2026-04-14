  # Erlang Toolchain

  - State: scaffold-only next-20 prep
  - Toolchain source: `built-in`

  ## Planned commands after promotion
    - `erl -eval 'erlang:display(erlang:system_info(otp_release)), halt().' -noshell`
- `rebar3 version`

  ## Scaffold-time checks
  - `python3 scripts/validate_scaffold.py`
  - `/nix/var/nix/profiles/default/bin/nix --extra-experimental-features 'nix-command flakes' flake lock`

  ## Current limitation
  - BEAM toolchain is already present.
