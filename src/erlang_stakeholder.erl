-module(erlang_stakeholder).
-export([main/1, run/1, parse_args/1]).

main(Args) ->
    case run(Args) of
        ok -> ok;
        {error, Code, Message} ->
            io:format(standard_error, "~s~n", [Message]),
            halt(Code)
    end.

run(Args) ->
    case parse_args(Args) of
        {error, Code, Message} ->
            {error, Code, Message};
        {ok, Opts} ->
            case maps:get(experimental_provider, Opts) of
                undefined -> run_focus(Opts);
                Provider ->
                    {error, 2, lists:flatten(io_lib:format(
                        "experimental provider '~s' is not enabled in the deterministic first tranche",
                        [Provider]
                    ))}
            end
    end.

parse_args(Args) ->
    parse_args(Args, default_options()).

parse_args([], Opts) ->
    {ok, Opts};
parse_args(["--list-values" | Rest], Opts) ->
    parse_args(Rest, Opts#{list_values => true});
parse_args(["--focus-family", Value | Rest], Opts) ->
    case parse_family(Value) of
        {ok, Family} -> parse_args(Rest, Opts#{focus_family => Family});
        {error, Message} -> {error, 2, Message}
    end;
parse_args(["--focus-family"], _Opts) ->
    {error, 2, "missing value for --focus-family"};
parse_args(["--seed", Value | Rest], Opts) ->
    parse_args(Rest, Opts#{seed => Value});
parse_args(["--seed"], _Opts) ->
    {error, 2, "missing value for --seed"};
parse_args(["--output-format", Value | Rest], Opts) ->
    case parse_output_format(Value) of
        {ok, Format} -> parse_args(Rest, Opts#{output_format => Format});
        {error, Message} -> {error, 2, Message}
    end;
parse_args(["--output-format"], _Opts) ->
    {error, 2, "missing value for --output-format"};
parse_args(["--experimental-provider", Value | Rest], Opts) ->
    parse_args(Rest, Opts#{experimental_provider => Value});
parse_args(["--experimental-provider"], _Opts) ->
    {error, 2, "missing value for --experimental-provider"};
parse_args([Arg | _Rest], _Opts) when is_list(Arg) ->
    case lists:prefix("--experimental-", Arg) of
        true -> {error, 2, "experimental flags require --experimental-provider"};
        false -> {error, 2, lists:flatten(io_lib:format("unknown argument: ~s", [Arg]))}
    end.

run_focus(Opts) ->
    case maps:get(list_values, Opts) of
        true ->
            io:format("~s~n", [erlang_stakeholder_json:encode(erlang_stakeholder_runtime:list_values_json())]),
            ok;
        false ->
            case maps:get(focus_family, Opts) of
                undefined ->
                    {error, 2, "focus-family is required and must be a known generator family"};
                Family ->
                    Payload = erlang_stakeholder_runtime:focus_payload(
                        Family,
                        maps:get(seed, Opts),
                        maps:get(output_format, Opts)
                    ),
                    emit_payload(maps:get(output_format, Opts), Payload),
                    ok
            end
    end.

emit_payload(json, Payload) ->
    io:format("~s~n", [erlang_stakeholder_json:encode(Payload)]);
emit_payload(text, Payload) ->
    lists:foreach(fun(Line) -> io:format("~s~n", [Line]) end, erlang_stakeholder_runtime:text_payload(Payload)).

default_options() ->
    #{
        focus_family => undefined,
        seed => "default-seed",
        output_format => text,
        list_values => false,
        experimental_provider => undefined
    }.

parse_family(Value) ->
    try
        {ok, erlang_stakeholder_catalog:normalize_family(Value)}
    catch
        error:{invalid_family, _} ->
            {error, lists:flatten(io_lib:format("invalid --focus-family: ~s", [Value]))}
    end.

parse_output_format(Value) ->
    case string:lowercase(Value) of
        "text" -> {ok, text};
        "json" -> {ok, json};
        _ -> {error, lists:flatten(io_lib:format("invalid --output-format: ~s", [Value]))}
    end.
