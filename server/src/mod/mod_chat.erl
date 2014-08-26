%%%==============================================================================
%%% Author      :	杨玉东
%%% Created     :	2012-7-24 16:52:01
%%% Description :	玩家聊天gen_server， 这个gen_server专门用于处理玩家的频道聊天消息
%%%==============================================================================
-module(mod_chat).
-behaviour(gen_server).

%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------
-include("common.hrl").
-include("chat.hrl").

%%--------------------------------------------------------------------
%% Export
%%--------------------------------------------------------------------
%% 启动接口
-export([start_link/0, start/0]).

%% gen_server 回调处理
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%%对外接口
-export([
  send_to_all/2,
  send_to_map/2,
  send_to_map_view/5,
  send_to_guild/2,
  send_to_idlist/2
]).

%%—————————————————————————————————————————————
%% 对外接口
%%—————————————————————————————————————————————
%%向全服玩家发送消息（世界聊天频道、系统消息）
%%Bin 已打包的待发送的消息
%%SenderId 发送玩家ID
%%不使用返回值
send_to_all(Bin, SenderId) ->
  gen_server:cast(mod_chat, {send_to_all, Bin, SenderId}).

%%想指定场景内的在线玩家发送消息
%%Bin 已打包的待发送的消息
%%MapId 场景ID
send_to_map(Bin, MapId) ->
  gen_server:cast(mod_chat, {send_to_map, Bin, MapId}).

%%向指定场景指定坐标九宫格内的玩家发送消息
%%Bin 已打包的待发送的消息
%%SenderId 发送消息玩家ID
%%MapId 发送消息场景ID
%%X, Y 发送消息玩家坐标
send_to_map_view(Bin, SenderId, MapId, X, Y) ->
  gen_server:cast(mod_chat, {send_to_map_view, Bin, SenderId, MapId, X, Y}).

%%向发送玩家所在公会所有在线成员发送消息
%%Bin 已打包的待发送的消息
%%GuildId 发送玩家所在公会ID
%%不使用返回值
send_to_guild(Bin, GuildId) ->
  gen_server:cast(mod_chat, {send_to_guild, Bin, GuildId}).

%%发送至玩家列表
%%Bin 已打包的待发送的消息
%%IdList 目标玩家ID列表
%%不使用返回值
send_to_idlist(Bin, IdList) ->
  gen_server:cast(mod_chat, {send_to_idlist, Bin, IdList}).


%%--------------------------------------------------------------------
%% Server functions
%%--------------------------------------------------------------------

%% 别忘记注释,根据启动方式不同选择不同的参数
start_link() ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], ?Public_Service_Options).
start() ->
  gen_server:start(?MODULE, [], ?Public_Service_Options).

%% --------------------------------------------------------------------
%% Callback functions
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%% --------------------------------------------------------------------
init(_Args) ->
  process_flag(trap_exit, true),
  put(tag, ?MODULE),
  {ok, state}.

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
      ?Error(chat_logger, "mod_chat handle_call is Info:~p, Reason:~p, Trace:~p, State:~p", [Info, Reason, Stacktrace, State]),
      ?T("*****Error mod_chat handle_call info: ~p,~n reason:~p,~n stacktrace:~p", [Info, Reason, Stacktrace]),
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
      ?Error(chat_logger, "mod_chat handle_cast is Info:~p, Reason:~p, Trace:~p, State:~p", [Info, Reason, Stacktrace, State]),
      ?T("*****Error mod_chat handle_cast info: ~p,~n reason:~p,~n stacktrace:~p", [Info, Reason, Stacktrace]),
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
      ?Error(chat_logger, "mod_chat handle_info is Info:~p, Reason:~p, Trace:~p, State:~p", [Info, Reason, Stacktrace, State]),
      ?T("*****Error mod_chat handle_info info: ~p,~n reason:~p,~n stacktrace:~p", [Info, Reason, Stacktrace]),
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
      ?Error(chat_logger, "mod_chat do_terminate is Reason:~p, Trace:~p, State:~p", [Reason, Stacktrace, State]),
      ?T("*****Error mod_chat do_terminate ~n reason:~p,~n stacktrace:~p", [Reason, Stacktrace]),
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
  ?Error(chat_logger, "chat_logger call is not match:~p", [Info]),
  {reply, ok, State}.


%%--------------------do_cast-----------------------------------------

%%发送至所有在线玩家（世界聊天频道）
%%Bin 已打包的待发送的消息内容
%%PlayerId 发送者ID（可能是玩家，也可能是系统）
do_cast({send_to_all, BinList, PlayerId}, State) ->
  lib_chat_handler:send_to_all(BinList, PlayerId),
  {noreply, State};

%%发送至指定场景内的在线玩家
%%Bin 已打包的待发送的消息内容
%%MapId 目标场景ID
do_cast({send_to_map, BinList, MapId}, State) ->
  lib_chat_handler:send_to_map(BinList, MapId),
  {noreply, State};

%%向指定场景指定坐标九宫格内的玩家发送消息
%%Bin 已打包的待发送的消息
%%SenderId 发送消息玩家ID
%%MapId 发送消息场景ID
%%X, Y 发送消息玩家坐标
do_cast({send_to_map_view, BinList, SenderId, MapId, X, Y}, State) ->
  lib_chat_handler:send_to_map_view(BinList, SenderId, MapId, X, Y),
  {noreply, State};

%%发送至玩家所在家族（家族聊天频道）
%%Bin 已打包的待发送的消息内容
%%PlayerId 发送者ID（只能是玩家）
do_cast({send_to_guild, BinList, GuildId}, State) ->
  lib_chat_handler:send_to_guild(BinList, GuildId),
  {noreply, State};

%发送至指定玩家ID列表
%%Bin 已打包的待发送的消息内容
%%IdList 消息的目标玩家ID列表
do_cast({send_to_idlist, Bin, IdList}, State) ->
  lib_chat_handler:send_to_idlist(Bin, IdList),
  {noreply, State};

%% 通配cast处理
%% Info:消息
%% State:当前进程状态
%% 返回值:不使用
do_cast(Info, State) ->
  ?Error(chat_logger, "chat_logger cast is not match:~p", [Info]),
  {noreply, State}.

%%--------------------do_info------------------------------------------
%% 别忘记完整注释哦亲

%% 通配info处理
%% Info:消息
%% State:当前进程状态
%% 返回值:不使用
do_info(Info, State) ->
  ?Error(chat_logger, "chat_logger info is not match:~p", [Info]),
  {noreply, State}.

%%---------------------do_terminate-------------------------------------

%% 通配进程销毁处理
%% State:当前进程状态
%% 返回值:ok
do_terminate(Reason, State) ->
  %?T("do_terminate"),
  case Reason =:= normal orelse Reason =:= shutdown of
    true ->
      skip;
    false ->
      ?Error(chat_logger, "chat_logger terminate reason: ~p, state:~p", [Reason, State])
  end,
  %别忘记进程销毁需要做的数据清理哦
  ok.

%% --------------------------------------------------------------------------------------------------------------------------
%% 其他方法
%% --------------------------------------------------------------------------------------------------------------------------


