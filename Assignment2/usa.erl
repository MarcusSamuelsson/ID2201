-module(usa).

-export([start/0, stop/1, connectCounry/0]).

start() ->
    io:format("Starting tests~n"),
    test:start('usa@192.168.1.123',[r13,r14,r15,r16,r17,r18],[losangeles,newyork,texas,ohio,hawaii,washingtondc]),
    io:format("Done~n").

stop(Regs) ->
    test:stop(Regs).

connectCounry() ->
    test:connectCounry('usa@192.168.1.123','france@192.168.1.123', r13, r19, losangeles, paris).