-module(worker).

-export([start/5, stop/1, peers/2]).

start(Name, Logger, Seed, Sleep, Jitter) ->
    spawn_link(fun() -> init(Name, Logger, Seed, Sleep, Jitter) end).

stop(Worker) ->
    Worker ! stop.

init(Name, Log, Seed, Sleep, Jitter) ->
    random:seed(Seed, Seed, Seed),
    receive
        {peers, Peers} ->
            loop(Name, Log, Peers, Sleep, Jitter, time:zero());
        stop ->
            ok
    end.

peers(Wrk, Peers) ->
    Wrk ! {peers, Peers}.

loop(Name, Log, Peers, Sleep, Jitter, T)->
    Wait = random:uniform(Sleep),
    
    receive
        {msg, Time, Msg} ->
            NewT = time:inc(Name, time:merge(T, Time)),
            Log ! {log, Name, NewT, {received, Msg}},
            loop(Name, Log, Peers, Sleep, Jitter, NewT);
        stop ->
            ok;
        Error ->
            Log ! {log, Name, time, {error, Error}}
        after Wait ->
            Selected = select(Peers),
            Time = time:inc(Name,T),
            Message = {hello, random:uniform(100)},
            Selected ! {msg, Time, Message},
            jitter(Jitter),
            Log ! {log, Name, Time, {sending, Message}},
            loop(Name, Log, Peers, Sleep, Jitter, Time)
    end.

select(Peers) ->
    lists:nth(random:uniform(length(Peers)), Peers).

jitter(0) -> 
    ok;

jitter(Jitter) -> 
    timer:sleep(random:uniform(Jitter)).