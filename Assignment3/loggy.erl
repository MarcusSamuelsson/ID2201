-module(loggy).

-export([start/1, stop/1]).

start(Node) ->
    spawn_link(fun() -> init(Node) end).

stop(Logger) ->
    Logger ! stop.

init(_) ->
    loop().

loop() ->
    receive
        {log, From, Time, Msg} ->
            log(From, Time, Msg),
            loop();
        stop ->
            ok
    end.

log(From, Time, Msg) ->
    io:format("log: ~w ~w ~p ~n", [Time, From, Msg]).

