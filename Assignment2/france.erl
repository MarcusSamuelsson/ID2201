-module(france).

-export([start/0, stop/1]).

start() ->
    io:format("Starting tests~n"),
    test:start('france@192.168.1.123',[r19,r20,r21,r22,r23,r24],[paris,marseilles,lyon,toulouse,nice,lille]),
    io:format("Done~n").

stop(Regs) ->
    test:stop(Regs).