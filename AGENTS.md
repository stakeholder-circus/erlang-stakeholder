    # erlang-stakeholder AGENTS

    - Preserve imported Rust history and provenance.
    - Queue state: `scaffold-only` in the next-20 autonomous sprint.
    - Origin: `git@github.com:stakeholder-circus/erlang-stakeholder.git`
    - Upstream: `https://github.com/giacomo-b/rust-stakeholder`
    - Deterministic normalized JSON is the first implementation target.
    - Missing behavior must fail fast and be recorded in `GAPS.md`.
    - No placeholder runtime behavior once implementation starts.

    ## Planned promotion commands
    - `erl -eval 'erlang:display(erlang:system_info(otp_release)), halt().' -noshell`
- `rebar3 version`
