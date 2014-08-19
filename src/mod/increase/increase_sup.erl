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
  %帮会
  {ok, _} = supervisor:start_child(
    ?MODULE,
    {mod_increase_guild,
      {mod_increase_guild, start_link, []},
      permanent, 10000, worker, [mod_increase_guild]}),
  %帮会萌宠
  {ok, _} = supervisor:start_child(
    ?MODULE,
    {mod_increase_guild_pet,
      {mod_increase_guild_pet, start_link, []},
      permanent, 10000, worker, [mod_increase_guild_pet]}),
  %物品
  {ok, _} = supervisor:start_child(
    ?MODULE,
    {mod_increase_item,
      {mod_increase_item, start_link, []},
      permanent, 10000, worker, [mod_increase_item]}),
  %零时背包
  {ok, _} = supervisor:start_child(
    ?MODULE,
    {mod_increase_temp_bag,
      {mod_increase_temp_bag, start_link, []},
      permanent, 10000, worker, [mod_increase_temp_bag]}),
  %采集背包
  {ok, _} = supervisor:start_child(
    ?MODULE,
    {mod_increase_collection_bag,
      {mod_increase_collection_bag, start_link, []},
      permanent, 10000, worker, [mod_increase_collection_bag]}),
  %元神
  {ok, _} = supervisor:start_child(
    ?MODULE,
    {mod_increase_spirit,
      {mod_increase_spirit, start_link, []},
      permanent, 10000, worker, [mod_increase_spirit]}),
  %地图
  {ok, _} = supervisor:start_child(
    ?MODULE,
    {mod_increase_map,
      {mod_increase_map, start_link, []},
      permanent, 10000, worker, [mod_increase_map]}),
  %怪物
  {ok, _} = supervisor:start_child(
    ?MODULE,
    {mod_increase_monster,
      {mod_increase_monster, start_link, []},
      permanent, 10000, worker, [mod_increase_monster]}),
  %宠物
  {ok, _} = supervisor:start_child(
    ?MODULE,
    {mod_increase_pet,
      {mod_increase_pet, start_link, []},
      permanent, 10000, worker, [mod_increase_pet]}),
  %玩家
  {ok, _} = supervisor:start_child(
    ?MODULE,
    {mod_increase_player,
      {mod_increase_player, start_link, []},
      permanent, 10000, worker, [mod_increase_player]}),
  %竞技场
  %    {ok, _} = supervisor:start_child(
  %        ?MODULE,
  %        {mod_increase_athletics,
  %         {mod_increase_athletics, start_link, []},
  %         permanent, 10000, worker, [mod_increase_athletics]}),
  %副本
  {ok, _} = supervisor:start_child(
    ?MODULE,
    {mod_increase_duplicate,
      {mod_increase_duplicate, start_link, []},
      permanent, 10000, worker, [mod_increase_duplicate]}),
  ok.
