%%%==============================================================================
%%% Author      :f
%%% Created     :2012-6
%%% Description :玩家核心gen_server
%%% 都将玩家核心进程注册为一个全局唯一进程
%%% see PlayerProcessName = lib_util_misc:player_process_name(PlayerID)
%%%==============================================================================
-module(player_server).
-behaviour(gen_server).

%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------
-include("common.hrl").
-include("record.hrl").
-include("protocol.hrl").
-include("global_msg.hrl").
-include("player.hrl").

%%----------
%% 宏定义
%%----------
-ifdef(product).
-define(SAVE_PLAYER_TICK, (20 * 60 * 1000)).  %% 保存tick
-else.
-define(SAVE_PLAYER_TICK, (20 * 60 * 1000)).  %% 保存tick
-endif.


%% player进程名称
-define(PLAYER_START_NAME(Player_Id), {local, lib_util_proc:player_process_name(Player_Id)}).


%% player_server进程是我们非常特殊的进程{log_to_file, "tracefile_player"}
-define(Player_Server_Options, [{debug, []}, {timeout, 60000},
  {spawn_opt, [{priority, high}, {fullsweep_after, 350}, {min_heap_size, 102400}, {min_bin_vheap_size, 204800}]}]).

%%--------------------------------------------------------------------
%% Export
%%--------------------------------------------------------------------
%% API

%% 启动接口
-export([start_link/7, stop/2]).

%% gen_server 回调处理
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%%--------------------------------------------------------------------
%% API functions
%%--------------------------------------------------------------------
%%停止玩家游戏进程
stop(Pid, Reason) when is_pid(Pid) ->
  gen_server:cast(Pid, {stop, Reason}).
%%--------------------------------------------------------------------
%% Server functions
%%--------------------------------------------------------------------

%%--------------------------------------------------------------------------
%%  启动玩家主进程
%%--------------------------------------------------------------------------
start_link(PlayerID, Socket, ClientPid, Openkey, Pf, Pfkey, Check_login) ->
  gen_server:start_link(?PLAYER_START_NAME(PlayerID), ?MODULE, [PlayerID, Socket, ClientPid, Openkey, Pf, Pfkey, Check_login], ?Player_Server_Options).

%% --------------------------------------------------------------------
%% Callback functions
%% --------------------------------------------------------------------

%%--------------------------------------------------------------------------
%%  进程初始化
%%  PlayerID    玩家ID
%%  Socket      客户端socket连接
%%  ClientPid:broker进程pid
%%  OpenKey:string:来自url-sesseionkey, Pf:string:来自url-来源平台, PfKey:string:平台key
%%  返回  {ok, Status}
%%--------------------------------------------------------------------------
init([Player_Id, Socket, ClientPid, Openkey, Pf, Pfkey, Check_login]) ->
  %?T("~p |1-player_server init~n", [lib_util_time:get_fine_timestamp()]),
  put(tag, ?MODULE),
  %%设置为系统进程
  erlang:process_flag(trap_exit, true),
%%   lib_monitor_system:insert_monitor_pid({self(), ?MODULE, {Player_Id}}),

  put(?DICT_PLAYERID, Player_Id),
  {ok, {Socket, ClientPid, Openkey, Pf, Pfkey, Check_login}}.


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
      ?Error(player_logger, "player_server handle_call is Info:~p, Reason:~p, Trace:~p, State:~p", [Info, Reason, Stacktrace, State]),
      ?T("*****Error player_server handle_call info: ~p,~n reason:~p,~n stacktrace:~p", [Info, Reason, Stacktrace]),
      {reply, exception, State}
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
      ?Error(player_logger, "player_server handle_cast is Info:~p, Reason:~p, Trace:~p, State:~p", [Info, Reason, Stacktrace, State]),
      ?T("*****Error player_server handle_cast info: ~p,~n reason:~p,~n stacktrace:~p", [Info, Reason, Stacktrace]),
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
      ?Error(player_logger, "player_server handle_info is Info:~p, Reason:~p, Trace:~p, State:~p", [Info, Reason, Stacktrace, State]),
      ?T("*****Error player_server handle_info info: ~p,~n reason:~p,~n stacktrace:~p", [Info, Reason, Stacktrace]),
      {noreply, State}
  end.

%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(Reason, State) ->
%%   lib_monitor_system:delete_monitor_pid(self()),
  try
    do_terminate(Reason, State)
  catch
    _:Reason ->
      Stacktrace = erlang:get_stacktrace(),
      ?Error(player_logger, "player_server do_terminate is Reason:~p, Trace:~p, State:~p", [Reason, Stacktrace, State]),
      ?T("*****Error player_server do_terminate ~n reason:~p,~n stacktrace:~p", [Reason, Stacktrace]),
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
%% 首先处理路由到子系统的call
do_call({route, Module, Req}, From, Status) ->
  Module:handle_call(Req, From, Status);


%%--------------------------------------------------------------------------
%% 通配call处理
%% Info:消息
%% _From:消息来自
%% State:当前进程状态
%% 返回值:ok
%%--------------------------------------------------------------------------
do_call(Info, _From, State) ->
  ?Error(player_logger, "mod_name call is not match:~p", [Info]),
  {reply, ok, State}.


%%--------------------do_cast-----------------------------------------
%% 别忘记完整注释哦亲

%%------------------
%% 首先处理路由到子系统的cast
%%------------------
do_cast({route, Module, Req}, Status) ->
  %?T(["player_server", Req]),
  Module:handle_cast(Req, Status);

%%--------------------------------------------------------------------
%% 处理socket协议 (cmd：命令号; Data：已经解析好的相对于协议的命令)
%%--------------------------------------------------------------------
do_cast({'SOCKET_EVENT', Cmd, Data}, Status) ->
  % ?T("-------------do_cast SOCKET_EVENT: CMD:~p ~n",[Cmd]),
  NewStatus = socket_event(Cmd, Data, Status),
  {noreply, NewStatus};

%%--------------------------------------------------------------------
%%停止角色进程(Reason 为停止原因)
%%--------------------------------------------------------------------
do_cast({stop, _Reason}, Status) ->
  {stop, normal, Status};

%%--------------------------------------------------------------------
%% 通配cast处理
%% Info:消息
%% State:当前进程状态
%% 返回值:不使用
%%--------------------------------------------------------------------
do_cast(Info, State) ->
  ?T("player_server do_cast no match info: ~p", [Info]),
  ?Error(player_logger, "mod_name cast is not match:~p", [Info]),
  {noreply, State}.

%%--------------------do_info------------------------------------------
%% 别忘记完整注释哦亲

%%------------------
%% 首先处理路由到子系统的cast
%%------------------
do_info({route, Module, Req}, Status) ->
  Module:handle_info(Req, Status);

%%--------------------------------------------------------------------
%% 通配info处理
%% Info:消息
%% State:当前进程状态
%% 返回值:不使用
%%--------------------------------------------------------------------
%% gen_server超时消息
do_info({Ref, Msg}, State) when is_reference(Ref), is_tuple(Msg) ->
  ?T("do_info Ref:~p, Msg:~p", [Ref, Msg]),
  {noreply, State};

do_info(Info, State) ->
  ?T("player_server do_info no match info: ~p", [Info]),
  ?Error(player_logger, "player_server info is not match:~p", [Info]),
  {noreply, State}.

%%---------------------do_terminate-------------------------------------

%% 通配进程销毁处理
%% State:当前进程状态
%% 返回值:ok
do_terminate(Reason, Status) ->
  %    ?T("do_terminate1 reason:~p", [Reason]),
  %timer:sleep(50000),
  %    ?T("do_terminate2 reason:~p", [Reason]),
  %% 卸载角色数据 持久化
  lib_player_login:unload_player_info(Status),
  case Reason =:= normal orelse Reason =:= shutdown of
    true ->
      skip;
    false ->
      ?T("player_server do_terminate reason: ~p", [Reason]),
      ?Error(player_logger, "mod_name terminate reason: ~p, state:~p", [Reason, Status])
  end,
  %别忘记进程销毁需要做的数据清理哦
  ok.

%% --------------------------------------------------------------------------------------------------------------------------
%% 其他方法
%% --------------------------------------------------------------------------------------------------------------------------

%% -----------------------------------------------------------------------------
%% 接受client事件
%% cmd：命令号; Data：已经解析好的相对于协议的命令)
%% Status:当前玩家状态数据
%% 返回值:玩家新的状态数据
%% 注意：此处一定需要非常明确，业务逻辑对Player_Status的数据更改会影响到的范围 Ets_Online  MapDict  DB
%% -----------------------------------------------------------------------------
socket_event(Cmd, Data, Status) ->
  case routing(Cmd, Status, Data) of
    {update, Status_Updated} ->%只更新进程Status信息
      Status_Updated;
    {update_ets, Status_Updated} -> %% 同步更新 ets_online
      %?T("socket_event update_ets x:~p, y:~p", [Status_Updated#player_status.x, Status_Updated#player_status.y]),
      lib_player_info:update_ets(Status_Updated),
      Status_Updated;
    {update_db, Status_Updated} -> %% 同步更新  DB
      lib_player_info:update_db(Status_Updated),
      Status_Updated;
    {update_all, Status_Updated} ->%% 同步更新 ets_online  DB
      lib_player_info:update_all(Status_Updated),
      Status_Updated;
    _R ->
      Status
  end.


%% 协议处理的路由
%% Cmd:命令号
%% Status:当前玩家状态数据
%% Data:消息体,已经解析过的针对协议号的消息数据
routing(Cmd, Status, Data) ->
  %?T([routing,Cmd, Status, Data]),
  %%取前面二位区分功能类型
  [H1, H2, _, _, _] = integer_to_list(Cmd),
  case [H1, H2] of
  %%游戏基础功能处理
    "10" ->
      ph_10_account:handle(Cmd, Status, Data);
%        "36" ->
%            ph_36_multi_conquest:handle(Cmd, Status, Data);
    _ -> %%错误处理
      ?T("player_server routing cmd: ~p", [Cmd]),
      ?Error(player_logger, "Routing Error [~w].", [Cmd]),
      {error, "Routing failure"}
  end.















