-module(mod_chat_system).
%%%==============================================================================
%%% Author      :   杨玉东
%%% Created     :   2012-7-27 14:23:24
%%% Description :   系统消息推送gen_server， 专门用于推送系统消息，GM可在后台修改内容，
%%%                 另有mod_chat是玩家聊天的gen_server
%%%==============================================================================

-behaviour(gen_server).

%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------
-include("common.hrl").
-include("chat.hrl").

-define(CHAT_SYSTEM_TICK, 1000).    %系统轮询间隔——1秒钟

%%--------------------------------------------------------------------
%% Export
%%--------------------------------------------------------------------
%% 启动接口
-export([start_link/0, start/0]).

%% gen_server 回调处理
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-export([save_mail_msg/1, get_mail_msg/0, append_mail_msg/3]).

%%--------------------------------------------------------------------
%% Server functions
%%--------------------------------------------------------------------

%% 别忘记注释,根据启动方式不同选择不同的参数
start_link() ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], ?Public_Service_Options).
start() ->
  gen_server:start(?MODULE, [], ?Public_Service_Options).

%%保存离线消息
save_mail_msg(Data) ->
  gen_server:cast(mod_chat_system, {save_mail_msg, Data}).

%%获取离线消息
get_mail_msg() ->
  gen_server:call(mod_chat_system, get_mail_msg).

%%向进程字典中追加离线消息
append_mail_msg(PlayerIdList, Type, Content) ->
  gen_server:cast(mod_chat_system, {append_mail_msg, PlayerIdList, Type, Content}).

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
init([]) ->
  process_flag(trap_exit, true),
  put(tag, ?MODULE),
  ActiveSysChatList = lib_chat_system:init(),
  put(?DICT_SYSTEM_CHAT_CONTENT, ActiveSysChatList),
  erlang:send_after(?CHAT_SYSTEM_TICK, self(), {self_state_deal}),
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
      ?Error(chat_system_logger, "mod_chat_system handle_call is Info:~p, Reason:~p, Trace:~p, State:~p", [Info, Reason, Stacktrace, State]),
      ?T("*****Error mod_chat_system handle_call info: ~p,~n reason:~p,~n stacktrace:~p", [Info, Reason, Stacktrace]),
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
      ?Error(chat_system_logger, "mod_chat_system handle_cast is Info:~p, Reason:~p, Trace:~p, State:~p", [Info, Reason, Stacktrace, State]),
      ?T("*****Error mod_chat_system handle_cast info: ~p,~n reason:~p,~n stacktrace:~p", [Info, Reason, Stacktrace]),
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
      ?Error(chat_system_logger, "mod_chat_system handle_info is Info:~p, Reason:~p, Trace:~p, State:~p", [Info, Reason, Stacktrace, State]),
      ?T("*****Error mod_chat_system handle_info info: ~p,~n reason:~p,~n stacktrace:~p", [Info, Reason, Stacktrace]),
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
      ?Error(chat_system_logger, "mod_chat_system do_terminate is Reason:~p, Trace:~p, State:~p", [Reason, Stacktrace, State]),
      ?T("*****Error mod_chat_system do_terminate ~n reason:~p,~n stacktrace:~p", [Reason, Stacktrace]),
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
do_call(get_mail_msg, _From, State) ->
  Res = case get(?DICT_MAIL_MSG_CONTENT) of
          undefined ->
            [];
          Data ->
            Data
        end,
  {reply, Res, State};

%% 通配call处理
%% Info:消息
%% _From:消息来自
%% State:当前进程状态
%% 返回值:ok
do_call(Info, _From, State) ->
  ?Error(chat_system_logger, "chat_system call is not match:~p", [Info]),
  {reply, ok, State}.


%%--------------------do_cast-----------------------------------------

do_cast(refresh_system_chat, State) ->
  ActiveSysChatList = lib_chat_system:init(),
  put(?DICT_SYSTEM_CHAT_CONTENT, ActiveSysChatList),
  {noreply, State};

%%保存所有玩家离线消息到进程字典——覆盖
%%用于单个玩家登陆后，处理完毕该玩家离线消息后，将其他玩家未处理过的消息保存到进程字典
%%  Data： {PlayerId， MsgType, MsgContent}的列表
do_cast({save_mail_msg, Data}, State) ->
  put(?DICT_MAIL_MSG_CONTENT, Data),
  {noreply, State};

%%保存单个玩家的离线消息到进程字典——追加
%%用于处理广播时，如果该玩家不在线，策划又有一定要广播到该玩家的需求时，这时将该玩家离线消息追加到进程字典中
do_cast({append_mail_msg, PlayerIdList, Type, Content}, State) ->
  CurMsgList = case get(?DICT_MAIL_MSG_CONTENT) of
                 undefined ->
                   [];
                 AllMailMsg ->
                   AllMailMsg
               end,
  Fun = fun(Id, Acc) ->
    [{Id, Type, Content} | Acc]
  end,
  NewData = CurMsgList ++ lists:foldl(Fun, [], PlayerIdList),
  put(?DICT_MAIL_MSG_CONTENT, NewData),
  {noreply, State};

%% 通配cast处理
%% Info:消息
%% State:当前进程状态
%% 返回值:不使用
do_cast(Info, State) ->
  ?Error(chat_system_logger, "chat_system cast is not match:~p", [Info]),
  {noreply, State}.

%%--------------------do_info------------------------------------------
%% 别忘记完整注释哦亲

do_info({self_state_deal}, State) ->
  NewAciveSysChat = lib_chat_system:self_state_deal(),
  put(?DICT_SYSTEM_CHAT_CONTENT, NewAciveSysChat),
  erlang:send_after(?CHAT_SYSTEM_TICK, self(), {self_state_deal}),
  {noreply, State};

%% 通配info处理
%% Info:消息
%% State:当前进程状态
%% 返回值:不使用
do_info(Info, State) ->
  ?Error(chat_system_logger, "chat_system info is not match:~p", [Info]),
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
      ?Error(chat_system_logger, "chat_system terminate reason: ~p, state:~p", [Reason, State])
  end,
  %别忘记进程销毁需要做的数据清理哦
  ok.

%% --------------------------------------------------------------------------------------------------------------------------
%% 其他方法
%% --------------------------------------------------------------------------------------------------------------------------


