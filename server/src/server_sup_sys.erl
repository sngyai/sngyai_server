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
  %% 服务日志记录
  ok = start_log(),
  %% 地图服务
  ok = start_map(),
  %% 聊天服务
  ok = start_chat(),
  %% 系统消息推送服务
  ok = start_chat_system(),
  %% reloader服务
  ok = start_reloader(),
  %% 好友服务
  ok = start_relation(),
  %% 开启“怪物入侵”活动进程
  ok = start_monster_invasion(),
  %% 帮会
  ok = start_guild(),
  ok = start_guild_pet(),
  ok = start_guild_pet_market(),
  %% 帮会战
  ok = start_guild_battle(),
  ok = start_fairy_war(),
  ok = start_monster_attack(),
  ok = start_jin_god_war(),
  ok = start_guild_defend_war(),
  %% 儿童节活动
  ok = start_childrens_day(),
  %% 端午节活动
  ok = start_dragon_boat_festival(),
  %% add here 在这里添加
  ok = start_server_state(),
  %% 转盘
  ok = start_turntable(),
  %% 谪仙之战
  ok = start_angel_overlord(),% 暂时关闭
  %% 多人秘境活动
  ok = start_multi_dungeon(),
  %% 答题系统
  ok = start_exam(),
  %% ibrowse服务
  ok = start_ibrowse(),

  %% &*^&(*)注意这句要始终保持在最后的位置
  %% 文件存储服务
  ok = start_storage_file(),
  ok = start_delay_plug(),
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

%% 服务日志记录
start_log() ->
  {ok, _} = supervisor:start_child(
    server_sup_sys,
    {mod_server_log,
      {mod_server_log, start_link, []},
      permanent, 10000, worker, [mod_server_log]}),
  mod_server_log:add_handler(),
  ok.

%% 地图数据
start_map() ->
  {ok, _} = supervisor:start_child(
    server_sup_sys,
    {mod_map,
      {mod_map, start_link, []},
      permanent, 10000, worker, [mod_map]}),
  ok.

%% 聊天服务
start_chat() ->
  {ok, _} = supervisor:start_child(
    server_sup_sys,
    {mod_chat,
      {mod_chat, start_link, []},
      permanent, 10000, worker, [mod_chat]}),
  ok.

%% 系统消息推送服务
start_chat_system() ->
  {ok, _} = supervisor:start_child(
    server_sup_sys,
    {mod_chat_system,
      {mod_chat_system, start_link, []},
      permanent, 10000, worker, [mod_chat_system]}),
  ok.

%%好友服务
start_relation() ->
  {ok, _} = supervisor:start_child(
    server_sup_sys,
    {mod_relation,
      {mod_relation, start_link, []},
      permanent, 10000, worker, [mod_relation]}),
  ok.

%% 开启“怪物入侵”活动进程
start_monster_invasion() ->
  {ok, _} = supervisor:start_child(
    server_sup_sys,
    {mod_monster_invasion,
      {mod_monster_invasion, start_link, []},
      permanent, 10000, worker, [mod_monster_invasion]}),
  ok.

start_guild() ->
  {ok, _} = supervisor:start_child(
    server_sup_sys,
    {mod_guild,
      {mod_guild, start_link, []},
      permanent, 10000, worker, [mod_guild]}),
  ok.

start_guild_pet() ->
  {ok, _} = supervisor:start_child(
    server_sup_sys,
    {mod_guild_pet,
      {mod_guild_pet, start_link, []},
      permanent, 10000, worker, [mod_guild_pet]}),
  ok.

start_guild_pet_market() ->
  {ok, _} = supervisor:start_child(
    server_sup_sys,
    {mod_guild_pet_market,
      {mod_guild_pet_market, start_link, []},
      permanent, 10000, worker, [mod_guild_pet_market]}),
  ok.

start_guild_battle() ->
  {ok, _} = supervisor:start_child(
    server_sup_sys,
    {
      mod_guild_battle,
      {mod_guild_battle, start_link, []},
      permanent, 10000, worker, [mod_guild_battle]
    }
  ),
  ok.

start_fairy_war() ->
  {ok, _} = supervisor:start_child(
    server_sup_sys,
    {
      mod_fairy_war,
      {mod_fairy_war, start_link, []},
      permanent, 10000, worker, [mod_fairy_war]
    }
  ),
  ok.

start_monster_attack() ->
  {ok, _} = supervisor:start_child(
    server_sup_sys,
    {
      mod_monster_attack,
      {mod_monster_attack, start_link, []},
      permanent, 10000, worker, [mod_monster_attack]
    }
  ),
  ok.

%% 开启晋神之战活动主进程
start_jin_god_war() ->
  {ok, _} = supervisor:start_child(
    server_sup_sys,
    {
      mod_jin_god_war,
      {mod_jin_god_war, start_link, []},
      permanent, 10000, worker, [mod_jin_god_war]
    }
  ),
  ok.

%%家园守卫战活动主进程
start_guild_defend_war() ->
  {ok, _} = supervisor:start_child(
    server_sup_sys,
    {
      mod_guild_defend_war,
      {mod_guild_defend_war, start_link, []},
      permanent, 10000, worker, [mod_guild_defend_war]
    }
  ),
  ok.

%%儿童节活动进程
start_childrens_day() ->
  {ok, _} = supervisor:start_child(
    server_sup_sys,
    {
      mod_childrens_day,
      {mod_childrens_day, start_link, []},
      permanent, 10000, worker, [mod_childrens_day]
    }
  ),
  ok.
start_dragon_boat_festival() ->
  {ok, _} = supervisor:start_child(
    server_sup_sys,
    {
      mod_dragon_boat_festival,
      {mod_dragon_boat_festival, start_link, []},
      permanent, 10000, worker, [mod_dragon_boat_festival]
    }
  ),
  ok.


start_turntable() ->
  {ok, _} = supervisor:start_child(
    server_sup_sys,
    {
      mod_turntable,
      {mod_turntable, start_link, []},
      permanent, 10000, worker, [mod_turntable]
    }
  ),
  ok.

% 暂时关闭
start_angel_overlord() ->
  {ok, _} = supervisor:start_child(
    server_sup_sys,
    {
      mod_angel_overlord,
      {mod_angel_overlord, start_link, []},
      permanent, 10000, worker, [mod_angel_overlord]
    }
  ),
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


%% 开启“多人秘境”活动进程
start_multi_dungeon() ->
  {ok, _} = supervisor:start_child(
    server_sup_sys,
    {mod_multi_dungeon,
      {mod_multi_dungeon, start_link, []},
      permanent, 10000, worker, [mod_multi_dungeon]}),
  ok.

%% 开启“答题系统”活动进程
start_exam() ->
  {ok, _} = supervisor:start_child(
    server_sup_sys,
    {mod_exam,
      {mod_exam, start_link, []},
      permanent, 10000, worker, [mod_exam]}),
  ok.

%% 开启“文件存储服务”进程
start_storage_file() ->
  {ok, _} = supervisor:start_child(
    server_sup_sys,
    {mod_storage_file,
      {mod_storage_file, start_link, []},
      permanent, 10000, worker, [mod_storage_file]}),
  ok.

%% 开启“服数据”进程
start_server_state() ->
  {ok, _} = supervisor:start_child(
    server_sup_sys,
    {mod_server_state,
      {mod_server_state, start_link, []},
      permanent, 10000, worker, [mod_server_state]}),
  ok.

%% 开启“延迟塞”进程
start_delay_plug() ->
  {ok, _} = supervisor:start_child(
    server_sup_sys,
    {mod_delay_plug,
      {mod_delay_plug, start_link, []},
      permanent, 16000, worker, [mod_delay_plug]}),
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



