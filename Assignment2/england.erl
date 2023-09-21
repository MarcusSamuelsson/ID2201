-module(england).

-export([start/0, stop/1, connectCounry/0]).

start() ->
    io:format("Starting tests~n"),
    test:start('england@192.168.1.123',[r7,r8,r9,r10,r11,r12],[london,birmingham,nottingham,cambridge,lancaster,westminster]),
    io:format("Done~n").

stop(Regs) ->
    test:stop(Regs).

connectCounry() ->
    test:connectCounry('england@192.168.1.123','usa@192.168.1.123', r7, r13, london, losangeles).
