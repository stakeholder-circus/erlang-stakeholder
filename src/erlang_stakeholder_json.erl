-module(erlang_stakeholder_json).
-export([encode/1]).

encode(Value) ->
    lists:flatten(encode_value(Value)).

encode_value(null) ->
    "null";
encode_value(undefined) ->
    "null";
encode_value(true) ->
    "true";
encode_value(false) ->
    "false";
encode_value(Value) when is_integer(Value) ->
    integer_to_list(Value);
encode_value(Value) when is_float(Value) ->
    lists:flatten(io_lib:format("~.17g", [Value]));
encode_value(Value) when is_binary(Value) ->
    encode_string(unicode:characters_to_list(Value));
encode_value(Value) when is_atom(Value) ->
    case Value of
        null -> "null";
        true -> "true";
        false -> "false";
        _ -> encode_string(atom_to_list(Value))
    end;
encode_value(Value) when is_map(Value) ->
    encode_object(maps:to_list(Value));
encode_value(Value) when is_list(Value) ->
    case Value of
        [] -> "[]";
        _ ->
            case is_iolist(Value) of
                true -> encode_string(lists:flatten(Value));
                false -> encode_array(Value)
            end
    end;
encode_value(Value) when is_tuple(Value) ->
    encode_array(tuple_to_list(Value)).

encode_object(Pairs) ->
    Sorted = lists:sort(fun({K1, _}, {K2, _}) -> key_string(K1) < key_string(K2) end, Pairs),
    Inner = string:join([
        lists:flatten([encode_string(key_string(Key)), ":", encode_value(Val)])
        || {Key, Val} <- Sorted
    ], ","),
    ["{", Inner, "}"].

encode_array(List) ->
    Inner = string:join([lists:flatten(encode_value(Item)) || Item <- List], ","),
    ["[", Inner, "]"].

encode_string(Value) ->
    ["\"", escape_chars(Value), "\""].

escape_chars([]) ->
    [];
escape_chars([H | T]) ->
    [escape_char(H) | escape_chars(T)].

escape_char($") ->
    "\\\"";
escape_char($\\) ->
    "\\\\";
escape_char($\b) ->
    "\\b";
escape_char($\f) ->
    "\\f";
escape_char($\n) ->
    "\\n";
escape_char($\r) ->
    "\\r";
escape_char($\t) ->
    "\\t";
escape_char(C) when C < 32 ->
    lists:flatten(io_lib:format("\\u~4.16.0B", [C]));
escape_char(C) ->
    [C].

key_string(Key) when is_binary(Key) ->
    unicode:characters_to_list(Key);
key_string(Key) when is_atom(Key) ->
    atom_to_list(Key);
key_string(Key) when is_list(Key) ->
    Key;
key_string(Key) when is_integer(Key) ->
    integer_to_list(Key).

is_iolist(Value) ->
    case lists:all(fun(Item) -> is_integer(Item) orelse is_list(Item) orelse is_binary(Item) end, Value) of
        true -> false;
        false -> false
    end.
