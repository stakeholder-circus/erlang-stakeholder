-module(erlang_stakeholder_tests).
-include_lib("eunit/include/eunit.hrl").

parse_args_defaults_test() ->
    {ok, Opts} = erlang_stakeholder:parse_args([]),
    ?assertEqual(undefined, maps:get(focus_family, Opts)),
    ?assertEqual(text, maps:get(output_format, Opts)).

list_values_contains_renderer_metadata_test() ->
    Values = erlang_stakeholder_runtime:list_values_json(),
    Families = maps:get(<<"generatorFamilies">>, Values),
    ?assertEqual(45, length(Families)),
    First = hd(Families),
    ?assertEqual(<<"code_analyzer">>, maps:get(<<"id">>, First)),
    ?assertEqual(<<"classic-six.code_analyzer">>, maps:get(<<"rendererKey">>, First)).

deterministic_same_seed_json_test() ->
    PayloadA = erlang_stakeholder_runtime:focus_payload(platform_engineering, "42", json),
    PayloadB = erlang_stakeholder_runtime:focus_payload(platform_engineering, "42", json),
    ?assertEqual(erlang_stakeholder_json:encode(PayloadA), erlang_stakeholder_json:encode(PayloadB)).

focus_family_required_test() ->
    {error, 2, Message} = erlang_stakeholder:run(["--output-format", "json"]),
    ?assertMatch("focus-family is required and must be a known generator family", Message).

experimental_provider_fails_fast_test() ->
    {error, 2, Message} = erlang_stakeholder:run(["--experimental-provider", "local-demo"]),
    ?assertMatch(_, Message).

orphan_experimental_flag_fails_fast_test() ->
    {error, 2, Message} = erlang_stakeholder:run(["--experimental-mode", "api"]),
    ?assertEqual("experimental flags require --experimental-provider", Message).

json_encoder_sorts_keys_test() ->
    Encoded = erlang_stakeholder_json:encode(#{<<"b">> => 2, <<"a">> => 1}),
    ?assertEqual("{\"a\":1,\"b\":2}", Encoded).
