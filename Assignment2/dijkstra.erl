-module(dijkstra).

-export([table/2, route/2]).

entry(Node,Sorted) ->
    case lists:keyfind(Node, 1, Sorted) of
		{_,N,_} ->
			N;
		false ->
			0
    end.

replace(Node,N,Gateway,Sorted) ->
    case lists:keyfind(Node, 1, Sorted) of
        {Node, _, _Gateway} ->
            lists:keysort(2, lists:keyreplace(Node, 1, Sorted, {Node, N, Gateway}));
        false ->
            Sorted
    end.

update(Node,N,Gateway,Sorted) ->
    M = entry(Node,Sorted),

    if 
        M > N ->
            replace(Node,N,Gateway,Sorted);
        true ->
            Sorted
    end.
        
iterate([],_,Table) ->
    Table;
iterate([{_,inf,_}|_],_,Table) ->
    Table;
iterate([{Node,N,Gateway}|T],Map,Table) ->
    Sorted = lists:foldl(fun(CurrNode, CurrSorted) -> update(CurrNode, N+1, Gateway, CurrSorted) end, T, map:reachable(Node,Map)),
    iterate(Sorted,Map,[{Node,Gateway}|Table]).

setupTable([],_,Result) ->
    Result;
setupTable([H|T],Gateways,Result) ->
    case lists:member(H, Gateways) of
		true ->
		    setupTable(T,Gateways,[{H, 0, H} | Result]);
		false ->
            setupTable(T,Gateways,[{H, inf, unknown} | Result])
	end.

table(Gateways,Map) ->
    Routes = lists:usort(map:all_nodes(Map)),
    FinalList = lists:keysort(2, setupTable(Routes,Gateways,[])),
    %lists:foldl(fun(Node, List) -> update(Node, 0, Node, List) end, InitialList, Gateways),
    iterate(FinalList,Map,[]).

route(Node, Table) ->
    %io:format("Here ~p ~n",[Table]),
    case lists:keyfind(Node, 1, Table) of
		{_, Gateway} ->
			io:format("Found ~p ~n",[Gateway]),
            {ok, Gateway};
		false ->
			io:format("Fail ~p ~n",[Node]),
            notfound
    end.