-module(loggy).

-export([start/1, stop/1]).

start(Node) ->
    spawn_link(fun() -> init(Node) end).

stop(Logger) ->
    Logger ! stop.

init(Nodes) ->
    loop(time:clock(Nodes), []).

loop(Clock, Queue) ->
    receive
        {log, From, Time, Msg} ->
            UpdatedClock = time:update(From, Time, Clock),
            UpdatedQueue = queue(UpdatedClock, lists:keysort(2, [{From, Time, Msg}|Queue]), []),
            loop(UpdatedClock, UpdatedQueue);
        stop ->
            ok
    end.

queue(_, [], NewQueue) ->
    NewQueue;
queue(Clock, [{From, Time, Msg}|T], NewQueue) ->
    case time:safe(Time, Clock) of
        true ->
            log(From, Time, Msg),
            queue(Clock, T, NewQueue);
        false ->
            queue(Clock, T, [{From, Time, Msg}|NewQueue])
    end.

log(From, Time, Msg) ->
    io:format("log: ~w ~w ~p ~n", [Time, From, Msg]).

