-module(erlang_stakeholder_runtime).
-export([list_values_json/0, focus_payload/3, text_payload/1]).

list_values_json() ->
    erlang_stakeholder_catalog:list_values().

focus_payload(FamilyValue, SeedValue, OutputFormat) ->
    Family = erlang_stakeholder_catalog:normalize_family(FamilyValue),
    Seed = normalize_seed(SeedValue),
    {ContextKey, ContextValue} = erlang_stakeholder_catalog:context_for(Family),
    RendererKey = erlang_stakeholder_catalog:renderer_key(Family),
    Tranche = erlang_stakeholder_catalog:tranche_for(Family),
    RegistryId = list_to_binary(erlang_stakeholder_catalog:family_label(Family)),
    Hash = hash({Seed, Family}),
    Sequence = 1000 + (Hash rem 9000),
    #{
        <<"eventType">> => <<"stakeholder.generator.output">>,
        <<"sequence">> => Sequence,
        <<"family">> => atom_to_binary(Family, utf8),
        <<"message">> => list_to_binary(io_lib:format("Deterministic erlang tranche for ~s", [RegistryId])),
        <<"timestamp">> => timestamp(Hash),
        <<"context">> => #{
            <<"rendererKey">> => RendererKey,
            ContextKey => ContextValue,
            <<"seedFingerprint">> => seed_fingerprint(RegistryId, Hash),
            <<"tranche">> => Tranche,
            <<"erlangProfile">> => <<"next-20-deterministic-foundation">>
        },
        <<"generationProvenance">> => #{
            <<"sourceRepo">> => <<"erlang-stakeholder">>,
            <<"baseline">> => <<"next20-family-focus">>,
            <<"experimental">> => false,
            <<"adapterType">> => <<"static-catalog">>,
            <<"promptVersion">> => null
        },
        <<"outputFormat">> => atom_to_binary(OutputFormat, utf8)
    }.

text_payload(Payload) ->
    Context = maps:get(<<"context">>, Payload),
    [
        lists:flatten(io_lib:format("family: ~s", [maps:get(<<"family">>, Payload)])),
        lists:flatten(io_lib:format("renderer: ~s", [maps:get(<<"rendererKey">>, Context)])),
        lists:flatten(io_lib:format("tranche: ~s", [maps:get(<<"tranche">>, Context)])),
        lists:flatten(io_lib:format("sequence: ~p", [maps:get(<<"sequence">>, Payload)])),
        lists:flatten(io_lib:format("timestamp: ~s", [maps:get(<<"timestamp">>, Payload)])),
        lists:flatten(io_lib:format("message: ~s", [maps:get(<<"message">>, Payload)]))
    ].

normalize_seed(undefined) -> <<"default-seed">>;
normalize_seed(Seed) when is_binary(Seed) -> Seed;
normalize_seed(Seed) when is_list(Seed) -> list_to_binary(Seed);
normalize_seed(Seed) -> list_to_binary(io_lib:format("~p", [Seed])).

seed_fingerprint(RegistryId, Hash) ->
    Hex = string:lowercase(lists:flatten(io_lib:format("~.16B", [Hash]))),
    <<RegistryId/binary, "-", (list_to_binary(Hex))/binary>>.

hash(Input) ->
    erlang:phash2(Input, 16#7fffffff).

timestamp(Hash) ->
    Seconds = Hash rem 86400,
    Hour = Seconds div 3600,
    Minute = (Seconds rem 3600) div 60,
    Second = Seconds rem 60,
    list_to_binary(
        io_lib:format(
            "2026-01-01T~2..0B:~2..0B:~2..0BZ",
            [Hour, Minute, Second]
        )
    ).
