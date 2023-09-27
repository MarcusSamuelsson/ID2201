-module(time).

-compile(export_all).

zero() ->
    0.

inc(_Name, T) ->
    (T+1).

merge(Ti, Tj) ->
    case Ti < Tj of
        true ->
            Tj;
        false ->
            Ti
    end.

leq(Ti, Tj) ->
    (Ti =< Tj).

clock(Nodes) ->
    lists:foldl(fun(X, Acc) -> [{X, zero()}|Acc] end, [], Nodes).

update(Node, Time, Clock) ->
    lists:keysort(2, [{Node, Time}|lists:keydelete(Node, 1, Clock)]).

safe(Time, Clock) ->
    lists:all(fun({_, T}) -> leq(Time, T) end, Clock).