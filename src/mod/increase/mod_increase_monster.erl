%%%==============================================================================
%%% Author      :fangjie008@163.com
%%% Created     :2012-6
%%% Description :怪物id自增处理
%%%==============================================================================
-module(mod_increase_monster).

-include("common.hrl").

-behaviour(gen_server).


%% API
-export([
  new_id/0
]).

%% External exports
-export([
  start_link/0
]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%% ID状态信息
-record(state, {
  id_index = 0         %% 怪物ID索引值
}).

%% ====================================================================
%% External functions
%% ====================================================================

start_link() ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], ?Public_Service_Options).


%% ====================================================================
%% 外部API接口
%% ====================================================================

%% 获取副本自增Id
new_id() ->
  AutoId = gen_server:call(?MODULE, 'get_new_id'),
  AutoId.

%% ====================================================================
%% Server functions
%% ====================================================================

%% --------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%% --------------------------------------------------------------------
init([]) ->
  put(tag, ?MODULE),
  process_flag(trap_exit, true),
  % 初始化ID
  Id_Index = 0,
  % 服务启动的时候保证还有五千万的空间,否则不让启动
  State = #state{
    id_index = Id_Index
  },
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
      ?Error(increase_logger, "mod_increase_monster handle_call is Info:~p, Reason:~p, Trace:~p, State:~p", [Info, Reason, Stacktrace, State]),
      ?T("*****Error mod_increase_monster handle_call info: ~p,~n reason:~p,~n stacktrace:~p", [Info, Reason, Stacktrace]),
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
      ?Error(increase_logger, "mod_increase_monster handle_cast is Info:~p, Reason:~p, Trace:~p, State:~p", [Info, Reason, Stacktrace, State]),
      ?T("*****Error mod_increase_monster handle_cast info: ~p,~n reason:~p,~n stacktrace:~p", [Info, Reason, Stacktrace]),
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
      ?Error(increase_logger, "mod_increase_monster handle_info is Info:~p, Reason:~p, Trace:~p, State:~p", [Info, Reason, Stacktrace, State]),
      ?T("*****Error mod_increase_monster handle_info info: ~p,~n reason:~p,~n stacktrace:~p", [Info, Reason, Stacktrace]),
      {noreply, State}
  end.

%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(_Reason, _State) ->
  ok.

%% --------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

%% --------------------------------------------------------------------
%%% Internal functions
%% --------------------------------------------------------------------

%%---------------------do_call--------------------------------
%% 获取进程State
do_call('get_info', _, State) ->
  {reply, State, State};
%% 获取新ID
do_call('get_new_id', _, State) ->
  AutoId = State#state.id_index + 1,
  NewState = State#state{id_index = AutoId},
  {reply, AutoId, NewState};

do_call(Info, _, State) ->
  ?Warn(increase_logger, "mod_increase call is not match:~w", [Info]),
  {reply, ok, State}.


%%---------------------do_cast--------------------------------
do_cast(Info, State) ->
  ?Warn(increase_logger, "mod_increase cast is not match:~w", [Info]),
  {noreply, State}.

%%---------------------do_info--------------------------------
do_info(Info, State) ->
  ?Warn(increase_logger, "mod_increase info is not match:~w", [Info]),
  {noreply, State}.


	