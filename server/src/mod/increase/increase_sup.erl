%%%-------------------------------------------------------------------------------------------------------------------------------------
%%% @Module  : increase_sup
%%% @Author  : tj
%%% @Created : 2012.02.22 
%%% @Description: 
%%%					ID生成器监控树
%%%--------------------------------------------------------------------------------------------------------------------------------------
-module(increase_sup).
-behaviour(supervisor).
%% --------------------------------------------宏定义------------------------------------------------------------------------------------
%% --------------------------------------------export------------------------------------------------------------------------------------
-export([start_link/0, init/1]).
%% -------------------------------------------API exports-------------------------------------------------------------------------------
-export([
  start_sup/0,
  stop_sup/0
]).
%% ====================================================================
%% 					Server functions
%% ====================================================================
start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
  put(tag, ?MODULE),
  process_flag(trap_exit, true),
  {ok, {
    {one_for_one, 8, 10},
    []
  }}.

%% ====================================================================
%% 					外部API函数
%% ====================================================================
%%开启监控树
start_sup() ->
  {ok, _Pid} = supervisor:start_child(
    server_sup_sys,
    {?MODULE,
      {?MODULE, start_link, []},
      permanent, infinity, supervisor, [?MODULE]}),
  ok = start_mod_workers(),
  ok = start_mod_exchange(),
  ok.

%%关闭监控树
stop_sup() ->
  ok = supervisor:terminate_child(server_sup_sys, ?MODULE),
  ok = supervisor:delete_child(server_sup_sys, ?MODULE),
  ok.

%% ====================================================================
%% 				内部函数
%% ====================================================================

%%------------------------------------------------------------------------------
%% 启动工作进程服务
%% 返回：不是返回值
%%------------------------------------------------------------------------------
start_mod_workers() ->
  %用户
  {ok, _} = supervisor:start_child(
    ?MODULE,
    {mod_increase_user,
      {mod_increase_user, start_link, []},
      permanent, 10000, worker, [mod_increase_user]}),
  ok.

start_mod_exchange() ->
  %兑换
  {ok, _} = supervisor:start_child(
    ?MODULE,
    {mod_increase_exchange_log,
      {mod_increase_exchange_log, start_link, []},
      permanent, 10000, worker, [mod_increase_exchange_log]}),
  ok.


