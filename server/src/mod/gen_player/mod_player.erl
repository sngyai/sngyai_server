%%%==============================================================================
%%% Author      :fangjie008@163.com
%%% Created     :2012-8
%%% Description :玩家部分基础属性的处理
%%%==============================================================================
-module(mod_player).
-behaviour(gen_player).

%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------
-include("common.hrl").
-include("record.hrl").
-include("protocol.hrl").
-include("player.hrl").
-include("chat.hrl").


-define(key_mod_player_settle_strength_timer, key_mod_player_settle_strength_timer).

-define(key_mod_player_settle_buffer_timer, key_mod_player_settle_buffer_timer).
%%--------------------------------------------------------------------
%% Export
%%--------------------------------------------------------------------
-export([call/2, call/3, cast/2, info/2, send_after/2, send_interval/2]).
%% gen_server 回调处理
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/1]).
%% 路由处理
-export([handle_interior/2]).


%%--------------------------------------------------------------------
%% Server functions
%%--------------------------------------------------------------------
%% 同步调用
%% Pid:玩家进程pid
%% Req:info
call(Pid, Req) ->
  gen_server:call(Pid, make_msg(Req)).
call(Pid, Req, Timeout) ->
  gen_server:call(Pid, make_msg(Req), Timeout).
%% 异步调用
%% Pid:玩家进程pid
%% Req:info
cast(Pid, Req) ->
  %?T(["mod_player_task", Req]),
  gen_server:cast(Pid, make_msg(Req)).
%% 异步info调用
%% Pid:玩家进程pid
%% Req:info
info(Pid, Req) ->
  Pid ! make_msg(Req).

%% 定时发送消息,使用erlang:send_after方法,取消的话使用erlang:cancel_timer方法
%% Time:时间间隔,单位毫秒
%% Req:定时的消息内容
%% 返回值:TimerRef
send_after(Time, Req) ->
  erlang:send_after(Time, self(), make_msg(Req)).

%% 定时循环发送消息,使用timer:send_interval方法,取消的话使用timer:cancel方法
%% Time:时间间隔,单位毫秒
%% Req:定时的消息内容
%% 返回值:TRef 注意与TimerRef不同
send_interval(Time, Req) ->
  timer:send_interval(Time, self(), make_msg(Req)).

%% 构建发送到此模块的消息
make_msg(Req) ->
  {route, ?MODULE, Req}.

%% --------------------------------------------------------------------
%% Callback functions
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: 新的player_status
%% --------------------------------------------------------------------
init(PlayerStatus) ->
  PlayerStatus.

%% 请求State
%% 返回值State
handle_call(state, _From, State) ->
  {reply, State, State};

%% 通配call处理
%% Info:消息
%% _From:消息来自
%% State:当前进程状态
%% 返回值:ok
handle_call(Info, _From, State) ->
  ?Error(player_logger, "call is not match:~p", [Info]),
  {reply, ok, State}.


%% mfa测试使用--由于必须在玩家进程执行
handle_cast({mfa, M, F, A}, _Status) ->
  {true, Player_Status} = apply(M, F, A), %要求返回值
  {noreply, Player_Status};

%% 测试使用sleep
handle_cast({sleep, Interval}, State) ->
  ?T("start sleeping......"),
  timer:sleep(Interval),
  ?T("end sleeping......"),
  {noreply, State};

%% 通配cast处理
%% Info:消息
%% State:当前进程状态
%% 返回值:不使用
handle_cast(Info, State) ->
  ?Error(player_logger, "cast is not match:~p", [Info]),
  {noreply, State}.

%%--------------------do_info------------------------------------------

%%--------------------------------------------------------------------
%% 定时处理玩家buffer到期-调用定义好的接口取得最新buffer数据
%%--------------------------------------------------------------------

%% 通配info处理
%% Info:消息
%% State:当前进程状态
%% 返回值:不使用
handle_info(Info, State) ->
  ?Error(player_logger, "info is not match:~p", [Info]),
  {noreply, State}.

%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------

%% 通配进程销毁处理
%% State:当前进程状态
%% 返回值:ok
terminate(_PlayerState) ->
  %体力timer
  case erlang:get(?key_mod_player_settle_strength_timer) of
    undefined ->
      skip;
    TimerRef_Strength ->
      catch erlang:cancel_timer(TimerRef_Strength)
  end,
  %buffer timer
  case erlang:get(?key_mod_player_settle_buffer_timer) of
    undefined ->
      skip;
    TimerRef_Buffer ->
      catch erlang:cancel_timer(TimerRef_Buffer)
  end,
  ok.

%% --------------------------------------------------------------------------------------------------------------------------
%% 内部接口方法,相当于内部调用接口
%% --------------------------------------------------------------------------------------------------------------------------
%% _Info:消息
%% _Player_Status:玩家进程
%% 返回值:根据使用情况
handle_interior(_Event, _PlayerStatus) ->
  ok.















