-module(intf).

-compile(export_all).

new() ->
    [].

add(Name,Ref,Pid,Intf) ->
    io:format("Add: ~p ~n",[Name]),
    [{Name,Ref,Pid}|Intf].

remove(Name, Intf) ->
    lists:keydelete(Name, 1, Intf).

lookup(Name, Intf) ->
    case lists:keyfind(Name, 1, Intf) of
        {_, _, Pid} ->
            {ok, Pid};
        false ->
            notfound
    end.

ref(Name, Intf) ->
    case lists:keyfind(Name, 1, Intf) of
        {Name, Ref, _} ->
            {ok, Ref};
        false ->
            notfound
    end.

name(Ref, Intf) ->
    case lists:keyfind(Ref, 1, Intf) of
        {Name, Ref, _} ->
            {ok, Name};
        false ->
            notfound
    end.

list([]) ->
    [];
list([{Name, _, _}|T])->
	io:format("List: ~p ~n",[Name]),
    [Name|list(T)].

broadcast(_, []) ->
    [];
broadcast(Message, [{_,_,Pid}|T]) ->
    Pid ! Message,
    broadcast(Message, T).
    