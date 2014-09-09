%%%---------------------------------------------------
%%% @Module  : server_sup
%%% @Author  : f
%%% @Created : 2012.06.18
%%% @Description: 游戏服务器监控树根监控进程
%%%---------------------------------------------------
-module(server_sup).
-behaviour(supervisor).
-export([start_link/0, start_child_supervisor/1, init/1]).

%% 启动supervisor
start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% 启动子supervisor方法,到本supervisor下,根superviosr下面只能启动子supervisor不能挂载worker
%% Supervisor:要启动的supervisor
%% 返回值:ok
start_child_supervisor(Supervisor_Child) ->
  {ok, _} = supervisor:start_child(?MODULE,
    {Supervisor_Child, {Supervisor_Child, start_link, []},
      transient, infinity, supervisor, [Supervisor_Child]}),
  ok.

%% supervisor的回调init方法,定义了重启机制
init([]) ->
  {ok, {
    {one_for_one, 8, 10},
    []
  }}.


