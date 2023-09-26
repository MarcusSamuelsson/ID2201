-module(france).

-compile(export_all).

start() ->
    io:format("Starting tests~n"),
    test:start('france@192.168.1.123',[r19,r20,r21,r22,r23,r24],[paris,marseilles,lyon,toulouse,nice,lille]),
    io:format("Done~n").

stop() ->
    test:stop([r19,r20,r21,r22,r23,r24]).

updateAll() ->
    test:broadcast([r19,r20,r21,r22,r23,r24]),
    test:update([r19,r20,r21,r22,r23,r24]).
    