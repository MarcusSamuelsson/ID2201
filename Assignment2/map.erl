-module(map).

-compile(export_all).

new() ->
    [].

update(Node,Links,Map) -> 
    [{Node, Links}|lists:keydelete(Node, 1, Map)].

reachable(Node,Map) ->
    case lists:keyfind(Node, 1, Map) of
        {Node,Links} ->
            Links;
        false ->
            []
    end.

all_nodes([]) ->
    [];
all_nodes([{Node, Links}|T]) ->
    Combined = [Node | Links],
    lists:merge(Combined, all_nodes(T)).