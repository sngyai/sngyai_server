%%% 集群节点管理进程，在集群中的每个节点都会启动这样一个进程，它负责联通集群中的各个节点，同时维护着一个节点的列表。
%%% 每当一个新的节点加入集群，首先从数据库中读取集群中已经存在的节点，插入ets。同时其他的节点都会收到消息，将新加入的节点信息放入各自节点的ets中。

-module(mod_node_manager).
-behaviour(gen_server).
-include("common.hrl").
-include("record.hrl").
-export([start_link/4,
  rpc_server_add/5]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%% Node_type节点类型
start_link(Ip, Port, Server_no, Node_type) ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [Ip, Port, Server_no, Node_type], ?Public_Service_Options). %todo gen_server启动参数

init([Ip, Port, Server_no, Node_type]) ->
  put(tag, ?MODULE),
  process_flag(trap_exit, true),
  net_kernel:monitor_nodes(true),
  ets:new(?ETS_SERVER_NODE, [{keypos, #server_node.id}, named_table, public, set]),
  State = #server_node{id = Server_no, node = node(), node_type = Node_type, ip = Ip, port = Port},
  add_server_to_db(State),
  get_and_call_server(State),
  {ok, State}.

%% --------------------------------------------------------------------
%% Function: handle_call/3
%% Description: Handling call messages
%% Returns: {reply, Reply, State}          |
%%          {reply, Reply, State, Timeout} |
%%          {noreply, State}               |
%%          {noreply, State, Timeout}      |
%%          {stop, Reason, Reply, State}   | (terminate/2 is called)
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_call(Info, _From, State) ->
  try
    do_call(Info, _From, State)
  catch
    _:Reason ->
      Stacktrace = erlang:get_stacktrace(),
      ?Error(node_manager_logger, "mod_node_manager handle_call is Info:~p, Reason:~p, Trace:~p, State:~p", [Info, Reason, Stacktrace, State]),
      ?T("*****Error mod_node_manager handle_call info: ~p,~n reason:~p,~n stacktrace:~p", [Info, Reason, Stacktrace]),
      {reply, ok, State}
  end.

%% --------------------------------------------------------------------
%% Function: handle_cast/2
%% Description: Handling cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_cast(Info, State) ->
  try
    do_cast(Info, State)
  catch
    _:Reason ->
      Stacktrace = erlang:get_stacktrace(),
      ?Error(node_manager_logger, "mod_node_manager handle_cast is Info:~p, Reason:~p, Trace:~p, State:~p", [Info, Reason, Stacktrace, State]),
      ?T("*****Error mod_node_manager handle_cast info: ~p,~n reason:~p,~n stacktrace:~p", [Info, Reason, Stacktrace]),
      {noreply, State}
  end.
%% --------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_info(Info, State) ->
  try
    do_info(Info, State)
  catch
    _:Reason ->
      Stacktrace = erlang:get_stacktrace(),
      ?Error(node_manager_logger, "mod_node_manager handle_info is Info:~p, Reason:~p, Trace:~p, State:~p", [Info, Reason, Stacktrace, State]),
      ?T("*****Error mod_node_manager handle_info info: ~p,~n reason:~p,~n stacktrace:~p", [Info, Reason, Stacktrace]),
      {noreply, State}
  end.

%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(Reason, State) ->
  try
    do_terminate(Reason, State)
  catch
    _:Reason ->
      Stacktrace = erlang:get_stacktrace(),
      ?Error(node_manager_logger, "mod_node_manager do_terminate is Reason:~p, Trace:~p, State:~p", [Reason, Stacktrace, State]),
      ?T("*****Error mod_node_manager do_terminate ~n reason:~p,~n stacktrace:~p", [Reason, Stacktrace]),
      ok
  end.
%% --------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

%% --------------------------------------------------------------------------------------------------------------------------
%%										内部Handler
%% --------------------------------------------------------------------------------------------------------------------------

%%---------------------do_call----------------------------------------
%% 别忘记完整注释哦亲

%% 通配call处理
%% Info:消息
%% _From:消息来自
%% State:当前进程状态
%% 返回值:ok
do_call(Info, _From, State) ->
  ?Error(node_manager_logger, "call is not match:~p", [Info]),
  {reply, ok, State}.


%%--------------------do_cast-----------------------------------------
do_cast({rpc_server_add, Server_no, Node, Node_type, Ip, Port}, State) ->
  ets:insert(?ETS_SERVER_NODE,
    #server_node{id = Server_no, node = Node, node_type = Node_type, ip = Ip, port = Port}),
  {noreply, State};

%% 通配cast处理
%% Info:消息
%% State:当前进程状态
%% 返回值:不使用
do_cast(Info, State) ->
  ?Error(node_manager_logger, "cast is not match:~p", [Info]),
  {noreply, State}.

%%--------------------do_info------------------------------------------
%% 处理新节点加入事件
do_info({nodeup, Node}, State) ->
  rpc:cast(Node, mod_node_manager, rpc_server_add,
    [State#server_node.id,
      State#server_node.node,
      State#server_node.node_type,
      State#server_node.ip,
      State#server_node.port]),
  {noreply, State};

%% 处理节点关闭事件
do_info({nodedown, Node}, State) ->
  %% 检查是否战区节点，并做相应处理
  case ets:match_object(?ETS_SERVER_NODE, #server_node{node = Node, _ = '_'}) of
    [_Z] ->
      ets:match_delete(?ETS_SERVER_NODE, #server_node{node = Node, _ = '_'});
    _ ->
      skip
  end,
  {noreply, State};

%% 通配info处理
%% Info:消息
%% State:当前进程状态
%% 返回值:不使用
do_info(Info, State) ->
  ?Error(node_manager_logger, "info is not match:~p", [Info]),
  {noreply, State}.

%%---------------------do_terminate-------------------------------------

%% 通配进程销毁处理
%% State:当前进程状态
%% 返回值:ok
do_terminate(Reason, State) ->
  case Reason =:= normal orelse Reason =:= shutdown of
    true ->
      skip;
    false ->
      ?Error(node_manager_logger, "terminate reason: ~p, state:~p", [Reason, State])
  end,
  %别忘记进程销毁需要做的数据清理哦
  ok.

%% --------------------------------------------------------------------------------------------------------------------------
%% 其他方法
%% --------------------------------------------------------------------------------------------------------------------------

%% 获取并通知所有线路信息
%% 返回值:不使用返回值
get_and_call_server(State) ->
  case get_all_server_from_db() of
    [] -> %如果数据库没有查询到数据
      [];
    ServerList -> %如果查询到了数据库中的当前已经插入的列表
      F = fun(ServerNode) ->
        Node_E = ServerNode#server_node.node,
        Ip_E = ServerNode#server_node.ip,
        Id = ServerNode#server_node.id,
        case Id /= State#server_node.id of  % 自己不写入和不通知
          true ->
            case net_adm:ping(Node_E) of %% 如果其他服务器节点已经启动了的话,将其他节点信息插入本节点ets表中
              pong -> %如果通的话
                ets:insert(?ETS_SERVER_NODE, #server_node{id = Id, node = Node_E, ip = Ip_E, port = ServerNode#server_node.port}),
                %% 通知已有的线路加入当前线路的节点，包括线路0网关
                rpc:cast(Node_E, mod_node_manager, rpc_server_add, [State#server_node.id, State#server_node.node, State#server_node.ip, State#server_node.port]);
              pang ->
                del_server(Id) %服务器没有回应删除数据库记录
            end;
          false ->
            ok
        end
      end,
      [F(S) || S <- ServerList]
  end.

%% 将节点信息插入到数据库
%% Server_Node:   #server_node
%% 不使用返回值
add_server_to_db(_Server_Node) ->
  todo.

%% 从数据库中获取所有server信息
%% 返回值 [#server_node] || []
get_all_server_from_db() ->
  %% 由于在数据库中node和ip都是以二进制形式存储的，这里需要转换一下。
  %list_to_atom(binary_to_list(<<"node">>)),
  %binary_to_list(ip),
  todo.

%% 退出服务器集群
%% 删除数据库服务器
%% 不使用返回值
del_server(_ServerID) ->
  todo.


%% 接收其它节点的加入信息
%% 不使用返回值
rpc_server_add(Server_no, Node, Node_type, Ip, Port) ->
  gen_server:cast(?MODULE, {rpc_server_add, Server_no, Node, Node_type, Ip, Port}).


























