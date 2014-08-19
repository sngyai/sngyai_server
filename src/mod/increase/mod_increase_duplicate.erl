%%%==============================================================================
%%% Author      :f
%%% Created     :2012-11
%%% Description :副本相关自增id生成
%%%==============================================================================
-module(mod_increase_duplicate).
-behaviour(gen_server).

%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------
-include("common.hrl").

-record(state, {
  duplicate_auto_id = 1 %副本自增id
}).

%%--------------------------------------------------------------------
%% Export
%%--------------------------------------------------------------------
%% 启动接口
-export([start_link/0, start/0, get_duplicate_auto_id/0]).

%% gen_server 回调处理
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).


%%--------------------------------------------------------------------
%% Server functions
%%--------------------------------------------------------------------

%% 别忘记注释,根据启动方式不同选择不同的参数
start_link() ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], ?Public_Service_Options).
start() ->
  gen_server:start(?MODULE, [], []).

%% 获取地图自增Id
get_duplicate_auto_id() ->
  {ok, AutoId} = gen_server:call(?MODULE, 'get_auto_id'),
  AutoId.


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
  put(tag, ?MODULE),
  process_flag(trap_exit, true),
  %这个地方要注意慎用try catch 哦
  {ok, #state{}}.


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
      ?Error(increase_logger, "mod_increase_duplicate handle_call is Info:~p, Reason:~p, Trace:~p, State:~p", [Info, Reason, Stacktrace, State]),
      ?T("*****Error mod_increase_duplicate handle_call info: ~p,~n reason:~p,~n stacktrace:~p", [Info, Reason, Stacktrace]),
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
      ?Error(increase_logger, "mod_increase_duplicate handle_cast is Info:~p, Reason:~p, Trace:~p, State:~p", [Info, Reason, Stacktrace, State]),
      ?T("*****Error mod_increase_duplicate handle_cast info: ~p,~n reason:~p,~n stacktrace:~p", [Info, Reason, Stacktrace]),
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
      ?Error(increase_logger, "mod_increase_duplicate handle_info is Info:~p, Reason:~p, Trace:~p, State:~p", [Info, Reason, Stacktrace, State]),
      ?T("*****Error mod_increase_duplicate handle_info info: ~p,~n reason:~p,~n stacktrace:~p", [Info, Reason, Stacktrace]),
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
      ?Error(increase_logger, "mod_increase_duplicate do_terminate is Reason:~p, Trace:~p, State:~p", [Reason, Stacktrace, State]),
      ?T("*****Error mod_increase_duplicate do_terminate ~n reason:~p,~n stacktrace:~p", [Reason, Stacktrace]),
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

%% 获取新autoID,autoid的范围为:1~999999,副本启动进程,进程注册本地,使用原子
%% 返回值:{ok, auto_id}
do_call('get_auto_id', _, State) ->
  NewState =
    case State#state.duplicate_auto_id < 999999 of
      true ->
        AutoId = State#state.duplicate_auto_id + 1,
        State#state{duplicate_auto_id = AutoId};
      _ ->
        AutoId = 1,
        State#state{duplicate_auto_id = AutoId}
    end,
  {reply, {ok, NewState#state.duplicate_auto_id}, NewState};

%% 通配call处理
%% Info:消息
%% _From:消息来自
%% State:当前进程状态
%% 返回值:ok
do_call(Info, _From, State) ->
  ?Error(increase_logger, "mod_increase_duplicate call is not match:~p", [Info]),
  {reply, ok, State}.


%%--------------------do_cast-----------------------------------------
%% 别忘记完整注释哦亲

%% 通配cast处理
%% Info:消息
%% State:当前进程状态
%% 返回值:不使用
do_cast(Info, State) ->
  ?Error(increase_logger, "mod_increase_duplicate cast is not match:~p", [Info]),
  {noreply, State}.

%%--------------------do_info------------------------------------------
%% 别忘记完整注释哦亲

%% 通配info处理
%% Info:消息
%% State:当前进程状态
%% 返回值:不使用
do_info(Info, State) ->
  ?Error(increase_logger, "mod_increase_duplicate info is not match:~p", [Info]),
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
      ?Error(increase_logger, "mod_increase_duplicate terminate reason: ~p, state:~p", [Reason, State])
  end,
  %别忘记进程销毁需要做的数据清理哦
  ok.

%% --------------------------------------------------------------------------------------------------------------------------
%% 其他方法
%% --------------------------------------------------------------------------------------------------------------------------


