%%%==============================================================================
%%% Author      :fangjie008@163.com
%%% Created     :2012-8
%%% Description :系统服务监控进程
%%%==============================================================================
-module(server_sup_sys).


-behaviour(supervisor).

-export([start_link/0, init/1]).
-export([start_service/0, stop_service/0]).

%% 启动supervisor
start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% supervisor的回调init方法,定义了重启机制
init([]) ->
  %% 返回
  {ok, {
    {one_for_one, 8, 10},
    []
  }}.


%%====================================================================
%% External functions
%%====================================================================
%% 游戏服务节点启动代码
%% Ip:监听id, Port:监听端口
%% 返回值:ok
start_service() ->

  %%开启核心服务,必须放到最前
  ok = start_init(),

  %%基础服务启动
  inets:start(),
  %%系统ID生成器
  ok = start_increase(),
  %%随机种子生成服务
  ok = start_random(),

  %%开启客户端监控树,broker进程
  ok = start_client(),
  %%开启tcp listener监控树
  {_Ip, Port} = lib_config:get_tcp_listener(),
  ok = start_tcp(Port),
  %% 后台服务进程
  ok = start_webserver(),
  %% 定时触发服务
  ok = start_crone(),
  %% 兑换记录任务
  ok = start_exchange_log(),
  %% 服务日志记录
  ok = start_log(),
  %% reloader服务
  ok = start_reloader(),
  %% ibrowse服务
  ok = start_ibrowse(),

  %% &*^&(*)注意这句要始终保持在最后的位置
  %% 文件存储服务
  ok = start_sys_alarm_monitor(),
  ok.

%%====================================================================
%% Private functions
%%====================================================================
%%开启核心服务
start_init() ->
  {ok, _} = supervisor:start_child(
    server_sup_sys,
    {mod_init,
      {mod_init, start_link, []},
      permanent, 10000, worker, [mod_init]}),
  ok.

%%随机种子
start_random() ->
  {ok, _} = supervisor:start_child(
    server_sup_sys,
    {mod_random,
      {mod_random, start_link, []},
      permanent, 10000, worker, [mod_random]}),
  ok.

%%开启客户端监控树
start_client() ->
  {ok, _} = supervisor:start_child(
    server_sup_sys,
    {tcp_client_sup,
      {tcp_client_sup, start_link, []},
      transient, infinity, supervisor, [tcp_client_sup]}),
  ok.


%%开启tcp listener监控树
start_tcp(Port) ->
  {ok, _} = supervisor:start_child(
    server_sup_sys,
    {tcp_listener_sup,
      {tcp_listener_sup, start_link, [Port]},
      transient, infinity, supervisor, [tcp_listener_sup]}),
  ok.

%% 开启ID管理进程服务
start_increase() ->
  increase_sup:start_sup(),
  ok.

%% 启动后台服务进程
start_webserver() ->
  {ok, _} = supervisor:start_child(
    server_sup_sys,
    {mod_webserver,
      {mod_webserver, start_link, []},
      permanent, 10000, worker, [mod_webserver]}),
  ok.

%% 定时触发服务
start_crone() ->
  {ok, _} = supervisor:start_child(
    server_sup_sys,
    {mod_crone,
      {mod_crone, start_link, []},
      permanent, 10000, worker, [mod_crone]}),
  ok.

%%启动兑换记录服务
start_exchange_log() ->
    {ok, _} = supervisor:start_child(
        server_sup_sys,
        {mod_exchange_log,
            {mod_exchange_log, start_link, []},
            permanent, 10000, worker, [mod_exchange_log]}),
    ok.

%% 服务日志记录
start_log() ->
  {ok, _} = supervisor:start_child(
    server_sup_sys,
    {mod_server_log,
      {mod_server_log, start_link, []},
      permanent, 10000, worker, [mod_server_log]}),
  mod_server_log:add_handler(),
  ok.



%% @doc 启动reloader server
-ifdef(product).
-define(RELOAD_INTERVAL, 5).
-else.
-define(RELOAD_INTERVAL, 5).    % 5秒
-endif.
start_reloader() ->
  {ok, _} = supervisor:start_child(
    server_sup_sys,
    {mod_reloader,
      {mod_reloader, start_link, [?RELOAD_INTERVAL]},
      permanent, brutal_kill, worker, [mod_reloader]}),
  ok.

%% 开启 系统状态监控模块 进程组
start_sys_alarm_monitor() ->
  {ok, _} = supervisor:start_child(
    server_sup_sys,
    {sys_alarm_monitor_sup,
      {sys_alarm_monitor_sup, start_link, []},
      permanent, 16000, worker, [sys_alarm_monitor_sup]}),
  ok.

%% 启动 ibrowse 为http访问提供支持
start_ibrowse() ->
  {ok, _} = supervisor:start_child(
    server_sup_sys,
    {ibrowse_sup,
      {ibrowse_sup, start_link, []},
      permanent, 16000, worker, [ibrowse_sup]}),
  ok.

%% 游戏服务节点stop代码
%% 返回值:ok
stop_service() ->
  ok.



