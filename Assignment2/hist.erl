-module(hist).

-compile(export_all).

new(Name) ->
    [{Name, -1}].

update(Node,N,History) ->
    case lists:keyfind(Node, 1, History) of
        {_, Count} ->
            if
                N > Count ->
                    Updated = [{Node,N}|lists:keydelete(Node, 1, History)],
                    {new, Updated};
                true ->
                    old
            end;
        false ->
            {new, [{Node, N}|History]}
    end.