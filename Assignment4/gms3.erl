-module(gms3).
-define(arghh, 10000000000000000000000000).
-define(timeout, 100).

-compile(export_all).

start(Id) ->
    Rnd = random:uniform(1000),
    Self = self(),
    {ok, spawn_link(fun()-> init(Id, Rnd, Self) end)}.

init(Id, Rnd, Master) ->
    random:seed(Rnd, Rnd, Rnd),
    leader(Id, Master, 0, [], [Master]).


leader(Id, Master, N, Slaves, Group) ->
    receive
        {mcast, Msg} ->
            gms1:bcast(Id, {msg, N, Msg}, Slaves),
            Master ! Msg,
            leader(Id, Master, N+1,  Slaves, Group);
        {join, Wrk, Peer} ->
            Slaves2 = lists:append(Slaves, [Peer]),
            Group2 = lists:append(Group, [Wrk]),
            gms1:bcast(Id, {view, N, [self() | Slaves2], Group2}, Slaves2),
            Master ! {view, Group2},
            leader(Id, Master, N+1, Slaves2, Group2);
        stop ->
            ok
    end.

start(Id, Grp) ->
    Rnd = random:uniform(1000),
    Self = self(),
    {ok, spawn_link(fun()-> init(Id, Rnd, Grp, Self) end)}.

init(Id, Rnd, Grp, Master) ->
    random:seed(Rnd, Rnd, Rnd),
    Grp ! {join, Master, self()},
    io:format("worker ~w ~w: spawned slave  ~w to join ~w~n", [Id, Master, self(), Grp]),
    
    receive
        {view, N, [Leader|Slaves], Group} ->
            erlang:monitor(process, Leader),
            Master ! {view, Group},
            Last = {view, N, [Leader | Slaves], Group},
            slave(Id, Master, Leader, N+1, Last, Slaves, Group)
        after ?timeout ->
            Master ! {error, "no reply from leader"}
    end.

slave(Id, Master, Leader, N, Last, Slaves, Group) ->
    receive
        {mcast, Msg} ->
            Leader ! {mcast, Msg},
            slave(Id, Master, Leader, N, Last, Slaves, Group);
        {join, Wrk, Peer} ->
            Leader ! {join, Wrk, Peer},
            slave(Id, Master, Leader, N, Last, Slaves, Group);
        {msg, I, _} when I < N ->
            slave(Id, Master, Leader, N, Last, Slaves, Group);
        {msg, N, Msg} ->
            Master ! Msg,
            slave(Id, Master, Leader, N+1, {msg, N, Msg}, Slaves, Group);
        {view, N, [Leader | Slaves2], Group2} ->
            Master ! {view, Group2},
            Last2 = {view, N, [Leader | Slaves2], Group2},
            slave(Id, Master, Leader, N+1, Last2, Slaves2, Group2);
        {'DOWN', _Ref, process, Leader, _Reason} ->
            election(Id, Master, N, Last, Slaves, Group);
        stop ->
            ok
    end.

election(Id, Master, N, Last, Slaves, [_|Group]) ->
    Self = self(),
    case Slaves of
        [Self|Rest] ->
            io:format("leader ~w: group =~w~n\t  slaves=~w~n", [Id, Group, Slaves]),
            gms1:bcast(Id, Last, Rest),
            gms1:bcast(Id, {view, N, Slaves, Group}, Rest),
            Master ! {view, Group},
            leader(Id, Master, N+1, Rest, Group);
        [Leader|Rest] ->
            erlang:monitor(process, Leader),
            slave(Id, Master, Leader, N, Last, Rest, Group)
    end.