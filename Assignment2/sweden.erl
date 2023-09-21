-module(sweden).

-export([start/0, stop/1, connectCounry/0]).

start() ->
    io:format("Starting tests~n"),
    test:start('sweden@192.168.1.123',[r1,r2,r3,r4,r5,r6],[stockholm,lund,goteborg,norrtalje,malmo,jamtland]),
    io:format("Done~n").

stop(Regs) ->
    test:stop(Regs).

connectCounry() ->
    test:connectCounry('sweden@192.168.1.123','england@192.168.1.123', r1, r7, stockholm, london).