-module(usa).

-compile(export_all).

start() ->
    io:format("Starting tests~n"),
    test:start('usa@192.168.1.123',[r13,r14,r15,r16,r17,r18],[losangeles,newyork,texas,ohio,hawaii,washingtondc]),
    io:format("Done~n").

stop() ->
    test:stop([r13,r14,r15,r16,r17,r18]).

updateAll() ->
    test:broadcast([r13,r14,r15,r16,r17,r18]),
    test:update([r13,r14,r15,r16,r17,r18]).

connectCounry() ->
    test:connectCounry('usa@192.168.1.123','france@192.168.1.123', r13, r19, losangeles, paris).