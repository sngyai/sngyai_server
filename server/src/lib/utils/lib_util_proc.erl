%%%==============================================================================
%%% Author      :all
%%% Created     :2012-6
%%% Description :进程相关操作基础方法库,进程是否存活判断,进程注册等等
%%%==============================================================================
-module(lib_util_proc).


-export([
  is_pid_and_alive_local/1,
  is_process_alive/1,
  whereis_name_local/1,
  whereis_name_global/1,
  register_local/2,
  register_global/2,

  player_process_name/1,
  player_process_name_global_account_serverid/2,

  duplicate_process_name/1,


  get_child_count/1,
  get_child_message_queue_length/1,
  get_process_info/7,
  get_process_info_detail/3,
  get_process_info_check_initial_call/2,
  get_process_info_initial_call/1,
  get_process_all_pid/2,
  get_process_all_pid/4,
  get_process_parent_pid/1,
  get_process_data/1,
  get_process_info_and_zero_value/1,
  get_msg_queue/0,
  get_memory/0,
  get_heap/1,
  get_processes/0,

  pid_to_string/1,
  string_to_pid/1
]).


%% 进程判断注册相关--------------------------------------------------------------------------------
%% 是否是进程id并且活着
%% Pid:检查的参数
%% 返回值:true:是 | false:否
is_pid_and_alive_local(Pid) ->
  is_pid(Pid) andalso erlang:is_process_alive(Pid).

%判断进程是否存活 可以处理本地节点和非本地节点的情况
%% Pid:检查的参数
%% 返回值:true:是 | false:否
is_process_alive(Pid) ->
  try
    if is_pid(Pid) ->
      case rpc:call(node(Pid), erlang, is_process_alive, [Pid]) of
        {badrpc, _Reason} -> false;
        Res -> Res
      end;
      true -> false
    end
  catch
    _:_ -> false
  end.


%% 根据名称获取本地注册进程
%% erlang:register名称类型必须为原子,所以这里也必须为原子
%% 注意与global不同
%% 返回值: pid() | 'undefined'
whereis_name_local(Atom) ->
  erlang:whereis(Atom).

%% 根据名称获取global注册进程
%% 注意global注册的时候name类型为term,所以这里也可以为term
%% 但是erlang的whereis对应erlang的register,那么参数就是原子
%% 返回值:  pid() | 'undefined'
whereis_name_global(Term) ->
  global:whereis_name(Term).

%% 注册本地进程
%% RegName:名称必须为原子atom, Pid:pid
%% 返回值:true 
%% 可能的异常:Failure: badarg if Pid is not an existing, local process or port,
%% if RegName is already in use,
%% if the process or port is already registered (already has a name),
%% or if RegName is the atom undefined.
register_local(RegName, Pid) ->
  erlang:register(RegName, Pid).

%% 注册global进程
%% Name:名称, Pid:pid
%% 返回值:term()
register_global(Name, Pid) ->
  %% 	case global:whereis_name(Name) of
  %% 		Pid0 when is_pid(Pid0) ->
  %% 			global:re_register_name(Name, Pid,{global,random_exit_name,[Name,Pid,Pid0]});
  %% 		undefined ->
  %% 			global:re_register_name(Name, Pid)
  %% 	end.
  global:re_register_name(Name, Pid).


%% 进程名称规则相关---------------------------------------------------------------------------------------------------------------------------

%% ---------------------------------------------
%% 玩家进程相关
%% ---------------------------------------------
%% 根据玩家id生成玩家local进程名,local名称必须为原子类型p_p_PlayerId
%% PlayerId:玩家id
%% 返回值:atom()
player_process_name(PlayerId) when is_integer(PlayerId) or is_atom(PlayerId) ->
  lib_util_type:to_atom(lists:concat([p_p_, PlayerId]));
player_process_name(PlayerId) when is_list(PlayerId) ->
  lib_util_type:to_atom(lists:flatten(["p_p_" | PlayerId]));
player_process_name(PlayerId) when is_binary(PlayerId) ->
  lib_util_type:to_atom(lists:concat([p_p_, binary_to_list(PlayerId)])).

%% 根据玩家账号和服索引生成玩家global进程名, global进程名要求为term()
%% "player_account_serverid_PlayerAccount_ServerId"
%% Account:玩家账户
%% ServerId:账户所属服务器id
%% 返回值:term()
player_process_name_global_account_serverid(Account, ServerId) when is_binary(Account), is_integer(ServerId) ->
  player_process_name_global_account_serverid(lib_util_type:to_list(Account), ServerId);
player_process_name_global_account_serverid(Account, ServerId) when is_list(Account), is_integer(ServerId) ->
  lists:concat(["player_account_serverid_", Account, "_", ServerId]).


%% ---------------------------------------------
%% 副本进程相关
%% ---------------------------------------------

%% 创建副本进程名
%% 因为原子数量有限制所以这里要注意
%% DuplicateId:副本id
%% 返回值:原子
duplicate_process_name(DuplicateId) when is_integer(DuplicateId) ->
  lib_util_type:to_atom(lists:concat(["duplicate_id_", DuplicateId])).


%% 获取进程信息相关==========================================================================================
%% 获取进程的子进程数量
%% Atom:进程名称
%% 返回值:子进程数量
get_child_count(Atom) ->
  case whereis_name_local(Atom) of
    undefined ->
      0;
    _ ->
      [_, {active, ChildCount}, _, _] = supervisor:count_children(Atom),
      ChildCount
  end.

%% 获取进程的子进程消息队列长度数量
%% Atom:进程名称
%% 返回值:子进程消息队列数量
get_child_message_queue_length(Atom) ->
  case whereis_name_local(Atom) of
    undefined ->
      [];
    _ ->
      Child_list = supervisor:which_children(Atom),
      lists:map(
        fun({Name, Pid, _Type, [Class]}) when is_pid(Pid) ->
          {message_queue_len, Qlen} = erlang:process_info(Pid, message_queue_len),
          {links, Links} = erlang:process_info(Pid, links),
          {Name, Pid, Qlen, Class, length(Links)}
        end,
        Child_list)
  end.

%% --------------------------------------------------------------------
%% Func: get pid info/7
%% Param Process: atom Pid or Pid RegName
%% 		 Top: 0=all result, N=0-N record in the result
%% 		 NeedModule fiter Pid module,[]=all
%% 		 Layer node child layer, 0=all,1=self
%%       MinMsgLen message queue length >= MinMsgLen
%%       MinMemSize pid memory size >= MinMemSize
%%       OrderKey, type atom and the value is: msglen,memory
%% Purpose: get pid info
%% Returns: {ok,Result,Count} Result=[{Pid,RegName,MemSize,MessageLength,Module},...]
%% 			{error,Reason}
%% --------------------------------------------------------------------
get_process_info(Process, Top, NeedModule, Layer, MinMsgLen, MinMemSize, OrderKey) ->
  RootPid =
    if erlang:is_pid(Process) ->
      Process;
      true ->
        case whereis_name_local(Process) of
          undefined ->
            error;
          ProcessPid ->
            ProcessPid
        end
    end,
  case RootPid of
    error ->
      {error, lists:concat([Process, " is not process reg name in the ", node()])};
    _ ->
      AllPidList = get_process_all_pid(RootPid, Layer),
      RsList = get_process_info_detail(NeedModule, AllPidList, []),
      Len = erlang:length(RsList),
      FilterRsList =
        case OrderKey of
          msglen ->
            lists:filter(fun({_, _, _, Qlen, _}) -> Qlen >= MinMsgLen end, RsList);
          memory ->
            lists:filter(fun({_, _, Qmem, _, _}) -> Qmem >= MinMemSize end, RsList);
          _ ->
            lists:filter(fun({_, _, _, Qlen, _}) -> Qlen >= MinMsgLen end, RsList)
        end,
      RsList2 =
        case OrderKey of
          msglen ->
            lists:sort(fun({_, _, _, MsgLen1, _}, {_, _, _, MsgLen2, _}) -> MsgLen1 > MsgLen2 end, FilterRsList);
          memory ->
            lists:sort(fun({_, _, MemSize1, _, _}, {_, _, MemSize2, _, _}) -> MemSize1 > MemSize2 end, FilterRsList);
          _ ->
            lists:sort(fun({_, _, _, MsgLen1, _}, {_, _, _, MsgLen2, _}) -> MsgLen1 > MsgLen2 end, FilterRsList)
        end,
      NewRsList =
        if Top =:= 0 ->
          RsList2;
          true ->
            if erlang:length(RsList2) > Top ->
              lists:sublist(RsList2, Top);
              true ->
                RsList2
            end
        end,
      {ok, NewRsList, Len}
  end.

%% --------------------------------------------------------------------
%% Func: get_process_info_detail/3
%% Purpose: get pid detail info
%% Returns: [{Pid,RegName,MemSize,MessageLength,Module},...]
%% --------------------------------------------------------------------
get_process_info_detail(_NeedModule, [], Result) -> Result;
get_process_info_detail(NeedModule, [H | T], Result) ->
  Mql = get_process_data({message_queue_len, H}),
  MemSize = get_process_data({memory, H}),
  RegName = get_process_data({registered_name, H}),
  case NeedModule of
    [] ->
      Module = get_process_info_initial_call(H),
      %% 			io:format("~p process RegName:~p,Mql:~p,MemSize:~p,Module:~p\n",[H, RegName, Mql, MemSize, Module]),
      get_process_info_detail(NeedModule, T, lists:append(Result, [{H, RegName, MemSize, Mql, Module}]));
    _ ->
      case get_process_info_check_initial_call(NeedModule, H) of
        "" ->
          get_process_info_detail(NeedModule, T, Result);
        Module ->
          %% 					io:format("~p process RegName:~p,Mql:~p,MemSize:~p\n",[H, RegName, Mql, MemSize]),
          get_process_info_detail(NeedModule, T, lists:append(Result, [{H, RegName, MemSize, Mql, Module}]))

      end
  end.

%% --------------------------------------------------------------------
%% Func: get_process_info_check_initial_call/2
%% Purpose: check inital call
%% Returns: true or false
%% --------------------------------------------------------------------
get_process_info_check_initial_call(NeedModule, Pid) ->
  DictionaryList = get_process_data({dictionary, Pid}),
  %% 	io:format("Dictionary List:~p\n",[DictionaryList]),
  case proplists:lookup('$initial_call', DictionaryList) of
    {'$initial_call', {Module, _, _}} ->
      %% 			io:format("~p found initial_call Module=~p\n",[Pid,Module]),
      case lists:member(Module, NeedModule) of
        true ->
          Module;
        _ ->
          ""
      end;
    _ ->
      ""
  end.
%% --------------------------------------------------------------------
%% Func: get_process_info_initial_call/1
%% Purpose: get initial call
%% Returns: true or false
%% --------------------------------------------------------------------
get_process_info_initial_call(Pid) ->
  DictionaryList = get_process_data({dictionary, Pid}),
  %% 	io:format("Dictionary List:~p\n",[DictionaryList]),
  case proplists:lookup('$initial_call', DictionaryList) of
    {'$initial_call', {Module, _, _}} ->
      Module;
    _ ->
      ""
  end.
%% --------------------------------------------------------------------
%% Func: get_process_all_pid/1
%% Purpose: get pid and child pid, Layer 0 all 1 fisrt
%% Returns: [Pid,...]
%% --------------------------------------------------------------------
get_process_all_pid(RootPid, Layer) ->
  ParentPid = get_process_parent_pid(RootPid),
  RootLinkPidList = get_process_data({links, RootPid}),
  %% 	io:format("~p links process links~p,and parent pid is~p\n",[RootPid, RootLinkPidList, ParentPid]),
  case RootLinkPidList of
    [] ->
      [RootPid];
    _ ->
      if erlang:length(RootLinkPidList) =:= 1 ->
        [RootPid];
        true ->
          NewLinkPidList =
            if erlang:is_pid(ParentPid) ->
              lists:delete(ParentPid, RootLinkPidList);
              true ->
                RootLinkPidList
            end,
          LinkPidList = lists:delete(RootPid, NewLinkPidList),

          %% 				io:format("~p do handle links process links~p\n",[RootPid,LinkPidList]),
          if Layer =:= 1 ->
            [RootPid];
            true ->
              get_process_all_pid(LinkPidList, Layer, [RootPid], 2)
          end
      end
  end.

get_process_all_pid([], _Layer, ResultList, _Index) -> ResultList;
get_process_all_pid([H | T], Layer, ResultList, Index) ->
  %% 	io:format("get process all pid Index=~p", [Index]),
  if erlang:is_pid(H) ->
    ParentPid = get_process_parent_pid(H),
    RootLinkPidList = get_process_data({links, H}),
    %% 			io:format("~p links process links~p,and parent pid is~p\n",[H, RootLinkPidList, ParentPid]),
    case RootLinkPidList of
      [] ->
        get_process_all_pid(T, Layer, lists:append(ResultList, [H]), Index);
      _ ->
        if erlang:length(RootLinkPidList) =:= 1 ->
          get_process_all_pid(T, Layer, lists:append(ResultList, [H]), Index);
          true ->
            NewLinkPidList =
              if erlang:is_pid(ParentPid) ->
                lists:delete(ParentPid, RootLinkPidList);
                true ->
                  RootLinkPidList
              end,
            LinkPidList = lists:delete(H, NewLinkPidList),
            NewIndex = Index + 1,
            SubResultList =
              if NewIndex > Layer, Layer =/= 0 ->
                [H];
                true ->
                  get_process_all_pid(LinkPidList, Layer, [H], NewIndex)
              end,
            get_process_all_pid(T, Layer, lists:append(ResultList, SubResultList), Index)
        end
    end;
    true ->
      get_process_all_pid(T, Layer, ResultList, Index)
  end.

%% --------------------------------------------------------------------
%% Func: get_process_parent_pid/1
%% Purpose: get the pid parent pid
%% Returns: Pid or ignore
%% --------------------------------------------------------------------
get_process_parent_pid(Pid) ->
  DictionaryList = get_process_data({dictionary, Pid}),
  %% 	io:format("Dictionary List:~p\n",[DictionaryList]),
  case proplists:lookup('$ancestors', DictionaryList) of
    {'$ancestors', [ParentPid | _]} ->
      %% 			io:format("~p found parent pid is ~p\n",[Pid,ParentPid]),
      if erlang:is_pid(ParentPid) ->
        ParentPid;
        true ->
          whereis_name_local(ParentPid)
      end;
    _ ->
      ignore
  end.

%% --------------------------------------------------------------------
%% Func: get_process_data/1
%% Purpose: get the dictionary info of the process
%% Returns: [] or DictionaryList
%% --------------------------------------------------------------------
get_process_data({dictionary, Pid}) ->
  try erlang:process_info(Pid, dictionary) of
    {_, DList} -> DList;
    _ -> []
  catch
    _:_ -> []
  end;

%% --------------------------------------------------------------------
%% Func: get_process_data/1
%% Purpose: get the links info of the process
%% Returns: [] or LinksList
%% --------------------------------------------------------------------
get_process_data({links, Pid}) ->
  try erlang:process_info(Pid, links) of
    {_, Links} -> lists:filter(fun(I) -> erlang:is_pid(I) end, Links);
    _ -> []
  catch
    _:_ -> []
  end;
%% --------------------------------------------------------------------
%% Func: get_process_data/1
%% Purpose: get the message queue length info of the process
%% Returns: 0 or Length
%% --------------------------------------------------------------------
get_process_data({message_queue_len, Pid}) ->
  try erlang:process_info(Pid, message_queue_len) of
    {message_queue_len, Length} -> Length;
    _ -> 0
  catch
    _:_ -> 0
  end;
%% --------------------------------------------------------------------
%% Func: get_process_data/1
%% Purpose: get the memory size info of the process
%% Returns: 0 or MemorySize
%% --------------------------------------------------------------------
get_process_data({memory, Pid}) ->
  try erlang:process_info(Pid, memory) of
    {memory, Size} -> Size;
    _ -> 0
  catch
    _:_ -> 0
  end;
%% --------------------------------------------------------------------
%% Func: get_process_data/1
%% Purpose: get the registered name info of the process
%% Returns: "" or RegisteredName
%% --------------------------------------------------------------------
get_process_data({registered_name, Pid}) ->
  try erlang:process_info(Pid, registered_name) of
    {registered_name, RegName} -> RegName;
    _ -> ""
  catch
    _:_ -> ""
  end.


get_process_info_and_zero_value(InfoName) ->
  PList = erlang:processes(),
  ZList = lists:filter(
    fun(T) ->
      case erlang:process_info(T, InfoName) of
        {InfoName, 0} -> false;
        _ -> true
      end
    end, PList),
  ZZList = lists:map(
    fun(T) -> {T, erlang:process_info(T, InfoName), erlang:process_info(T, registered_name)}
    end, ZList),
  [length(PList), InfoName, length(ZZList), ZZList].

get_process_info_and_large_than_value(InfoName, Value) ->
  PList = erlang:processes(),
  ZList = lists:filter(
    fun(T) ->
      case erlang:process_info(T, InfoName) of
        {InfoName, VV} ->
          if VV > Value -> true;
            true -> false
          end;
        _ -> true
      end
    end, PList),
  ZZList = lists:map(
    fun(T) -> {T, erlang:process_info(T, InfoName), erlang:process_info(T, registered_name)}
    end, ZList),
  [length(PList), InfoName, Value, length(ZZList), ZZList].

get_msg_queue() ->
  io:fwrite("process count:~p~n~p value is not 0 count:~p~nLists:~p~n",
    get_process_info_and_zero_value(message_queue_len)).

get_memory() ->
  io:fwrite("process count:~p~n~p value is large than ~p count:~p~nLists:~p~n",
    get_process_info_and_large_than_value(memory, 1048576)).

get_heap(Value) ->
  io:fwrite("process count:~p~n~p value is large than ~p count:~p~nLists:~p~n",
    get_process_info_and_large_than_value(heap_size, Value)).

get_processes() ->
  io:fwrite("process count:~p~n~p value is large than ~p count:~p~nLists:~p~n",
    get_process_info_and_large_than_value(memory, 0)).

pid_to_string(Pid) when is_pid(Pid) ->
  %% see http://erlang.org/doc/apps/erts/erl_ext_dist.html (8.10 and
  %% 8.7)
  <<131, 103, 100, NodeLen:16, NodeBin:NodeLen/binary, Id:32, Ser:32, Cre:8>>
    = term_to_binary(Pid),
  Node = binary_to_term(<<131, 100, NodeLen:16, NodeBin:NodeLen/binary>>),
  format("<~w.~B.~B.~B>", [Node, Cre, Id, Ser]).

format(Fmt, Args) -> lists:flatten(io_lib:format(Fmt, Args)).

%% inverse of above
string_to_pid(Str) ->
  Err = {error, {invalid_pid_syntax, Str}},
  %% The \ before the trailing $ is only there to keep emacs
  %% font-lock from getting confused.
  case re:run(Str, "^<(.*)\\.(\\d+)\\.(\\d+)\\.(\\d+)>\$",
    [{capture, all_but_first, list}]) of
    {match, [NodeStr, CreStr, IdStr, SerStr]} ->
      %% the NodeStr atom might be quoted, so we have to parse
      %% it rather than doing a simple list_to_atom
      NodeAtom = case erl_scan:string(NodeStr) of
                   {ok, [{atom, _, X}], _} -> X;
                   {error, _, _} -> throw(Err)
                 end,
      <<131, NodeEnc/binary>> = term_to_binary(NodeAtom),
      [Cre, Id, Ser] = lists:map(fun list_to_integer/1,
        [CreStr, IdStr, SerStr]),
      binary_to_term(<<131, 103, NodeEnc/binary, Id:32, Ser:32, Cre:8>>);
    nomatch ->
      throw(Err)
  end.


