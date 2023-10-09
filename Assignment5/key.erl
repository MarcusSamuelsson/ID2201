-module(key).

-compile(export_all).

generate() ->
    random:uniform(1000000000).

between(Key, From, To) ->
    case From == To of
        true -> 
            true;
        false->
            case From > To of
                true ->
                    if (Key > From) or (Key =< To) ->
                        true;
                    true ->
                        false
                    end;
                false ->
                    if (Key > From) and (Key =< To) ->
                        true;
                    true ->
                        false
                    end
            end
    end.