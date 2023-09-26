-module(test).

-compile(export_all).

start(Network, Regs, Cities) ->
    io:format("Starting tests~n"),
    test(Network,Regs,Cities),
    io:format("Done~n").

stop([]) ->
    empty;
stop([H|T]) ->
    routy:stop(H),
    stop(T).

init([],[]) ->
    empty;
init([H1|T1],[H2|T2]) ->
    io:format("Initiating ~p ~p ~n",[H1,H2]),
    routy:start(H1,H2),
    init(T1,T2).

connectCities(Network, Reg1, Reg2, City1, City2) ->
    io:format("Connecting ~p and ~p ~n",[City1,City2]),
    Reg1 ! {add, City2, {Reg2, Network}},
    timer:sleep(100),
    Reg2 ! {add, City1, {Reg1, Network}},
    timer:sleep(100).

connectCounry(Network1, Network2, Reg1, Reg2, City1, City2) ->
    io:format("Connecting ~p and ~p ~n",[City1,City2]),
    Reg1 ! {add, City2, {Reg2, Network2}},
    timer:sleep(100),
    Reg2 ! {add, City1, {Reg1, Network1}},
    timer:sleep(100).

broadcast([]) ->
        empty;
broadcast([H|T]) ->
    io:format("Broadcasting ~p ~n",[H]),
    H ! broadcast,
    timer:sleep(100),
    broadcast(T).

update([]) ->
    empty;
update([H|T]) ->
    io:format("Updating ~p ~n",[H]),
    H ! update,
    timer:sleep(100),
    update(T).

test(Network, Regs, Cities) ->
    io:format("Initiating routers~n"),
    init(Regs,Cities),

    timer:sleep(100),

    io:format("Connect cities~n"),
    connectCities(Network, lists:nth(1,Regs), lists:nth(3,Regs), lists:nth(1,Cities), lists:nth(3,Cities)),
    connectCities(Network, lists:nth(3,Regs), lists:nth(5,Regs), lists:nth(3,Cities), lists:nth(5,Cities)),
    connectCities(Network, lists:nth(5,Regs), lists:nth(4,Regs), lists:nth(5,Cities), lists:nth(4,Cities)),
    connectCities(Network, lists:nth(2,Regs), lists:nth(4,Regs), lists:nth(2,Cities), lists:nth(4,Cities)),
    connectCities(Network, lists:nth(2,Regs), lists:nth(1,Regs), lists:nth(2,Cities), lists:nth(1,Cities)),
    connectCities(Network, lists:nth(2,Regs), lists:nth(6,Regs), lists:nth(2,Cities), lists:nth(6,Cities)),
    connectCities(Network, lists:nth(1,Regs), lists:nth(6,Regs), lists:nth(1,Cities), lists:nth(6,Cities)),

    io:format("Broadcast~n"),
    broadcast(Regs),
    io:format("Update cities~n"),
    update(Regs).
