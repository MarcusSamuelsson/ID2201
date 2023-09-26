-module(england).

-compile(export_all).

start() ->
    io:format("Starting tests~n"),
    test:start('england@192.168.1.123',[r7,r8,r9,r10,r11,r12],[london,birmingham,nottingham,cambridge,lancaster,westminster]),
    io:format("Done~n").

stop() ->
    test:stop([r7,r8,r9,r10,r11,r12]).

updateAll() ->
    test:broadcast([r7,r8,r9,r10,r11,r12]),
    test:update([r7,r8,r9,r10,r11,r12]).

connectCounry() ->
    test:connectCounry('england@192.168.1.123','usa@192.168.1.123', r7, r13, london, losangeles).
