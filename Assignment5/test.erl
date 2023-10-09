-module(test).

-compile(export_all).

-define(Timeout, 1000).


%% probe_test - Test the probe functionality
%% returns a list of all nodes
probe_test(Module, N) ->
    {Id, Pid} = start(Module),
    io:format("First node ~p ~n", [{Id, Pid}]),
    [{Last_Id, Last_Pid}|_Nodes] = start(Module, N-1, {Id, Pid}, []),
    timer:sleep(1000),
    io:format("Probing node ~p ~n", [{Last_Id, Last_Pid}]),
    Last_Pid ! probe.


%% storage_test - Test the storage functionality
%% returns a result from lookup of N keys
storage_test(N) ->
    {Id, Pid} = start(node2),
    io:format("First node ~p ~n", [{Id, Pid}]),
    timer:sleep(1000),
    io:format("Generationg Keys ~n", []),
    Keys = keys(N),
    io:format("Adding keys to storage ~n", []),
    add(Keys, Pid),
    io:format("Checking keys in storage ~n", []),
    check(Keys, Pid).


start(Module) ->
    Id = key:generate(), 
    Pid = apply(Module, start, [Id]),
    {Id, Pid}.


start(Module, P) ->
    Id = key:generate(), 
    Pid = apply(Module, start, [Id,P]),
    {Id, Pid}.    

start(_, 0, _, Nodes) ->
    Nodes;
start(Module, 1, {Id, P}, Nodes) ->
    New = start(Module, P),
    io:format("Node ~p linked to Pid: ~p~n", [New, P]),
    Final = [New|Nodes],
    start(Module, 0, {Id, P}, Final);
start(Module, N, First, [{Id, P}|T]) ->
    New = start(Module, P),
    io:format("Node ~p linked to Pid: ~p~n", [New, P]),
    Nodes = [{Id, P}|T],
    Final = [New|Nodes],
    start(Module, N-1, First, Final);
start(Module, N, {Id, P}, []) ->
    New = start(Module, P),
    io:format("Node ~p linked to Pid: ~p~n", [New, P]),
    start(Module, N-1, {Id, P}, [New]).

add(Key, Value , P) ->
    Q = make_ref(),
    P ! {add, Key, Value, Q, self()},
    receive 
	{Q, ok} ->
	   ok
	after ?Timeout ->
	    {error, "timeout"}
    end.

lookup(Key, Node) ->
    Q = make_ref(),
    Node ! {lookup, Key, Q, self()},
    receive 
	{Q, Value} ->
	    Value
    after ?Timeout ->
	    {error, "timeout"}
    end.

keys(N) ->
    lists:map(fun(_) -> key:generate() end, lists:seq(1,N)).

add(Keys, P) ->
    lists:foreach(fun(K) -> add(K, potatis, P) end, Keys).

check(Keys, P) ->
    T = erlang:system_time(micro_seconds),
    {Failed, Timeout} = check(Keys, P, 0, 0),
    FinalTime = (erlang:system_time(micro_seconds)-T)/1000,
    io:format("Ran ~w lookup operations in ~w ms ~n", [length(Keys), FinalTime]),
    io:format("Failed: ~w \nTimeouts: ~w ~n", [Failed, Timeout]).


check([], _, Failed, Timeout) ->
    {Failed, Timeout};
check([Key|Keys], P, Failed, Timeout) ->
    case lookup(Key,P) of
        {Key, _} -> 
            check(Keys, P, Failed, Timeout);
        {error, _} -> 
            check(Keys, P, Failed, Timeout+1);
        false ->
            check(Keys, P, Failed+1, Timeout)
    end.
