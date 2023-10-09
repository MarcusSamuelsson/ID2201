-module(storage).

-export([create/0, add/3, lookup/2, split/3, merge/2]).

create() ->
    [].

add(Key, Value, Store) ->
    case lookup(Key, Store) of
        {Key, Value} -> 
            Store;
        false -> 
            [{Key, Value} | Store]
    end.

lookup(Key, Store) ->
    lists:keyfind(Key, 1, Store).

split(From, To, Store) ->
    Filtered = lists:filter(fun({Key, _}) -> key:between(Key, From, To) end, Store),
    Rest = lists:filter(fun({Key, _}) -> not key:between(Key, From, To) end, Store),
    {Filtered, Rest}.

merge(Entries, Store) ->
    lists:append(Entries, Store).