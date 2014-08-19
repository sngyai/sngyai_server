%%%==============================================================================
%%% Author      :fangjie008@163.com
%%% Created     :2012-8
%%% Description :玩家行为模块规范
%%% @doc   gen_player behaviour
%%%     所有的mod都运行于mod_player进程，主要是用来处理一种标准逻辑
%%% 流程如下:
%%%     gen_player:start()      系统
%%%     modules_init/1          玩家实例进程
%%%     Module: cast/call/info  玩家实例进程,跨进程方法
%%%     Module: handle_interior  进程内部调用接口
%%%     modules_terminate/1     玩家实例进程
%%%     gen_player:stop()       系统
%%% @end
%%%
%%%----------------------------------------------------------------------
%%%==============================================================================
-module(gen_player).
-include("common.hrl").

%% -------------------------------
%% define
%% -------------------------------
-define(TABLE, gen_player_modules).

%% -------------------------------
%% export
%% -------------------------------
%% behaviour需导出方法
-export([behaviour_info/1]).
%% 启动和结束
-export([start/0, stop/0, module_list/0]).
%% 统一处理方法
-export([modules_init/1, modules_terminate/1]).

%% -------------------------------
%% behaviour 导出方法
%% -------------------------------
behaviour_info(callbacks) ->
  [
    {init, 1},              % 初始化mod,要求返回值为Player_Status
    {terminate, 1},         % 停止mod,返回值ok

    {call, 2},              %同步调用,路由到mod_player handle_call/3再返回,等价gen_server:call
    {cast, 2},              %异步调用,路由到mod_player handle_cast/2再返回,等价gen_server:cast
    {info, 2},              %异步调用,路由到mod_player handle_cast/2再返回,等价 !
    {send_after, 2},        %定时消息,路由到mod_player 再到对应子系统,等价 send_after
    {send_interval, 2},     %定时循环消息,路由到mod_player 再到对应子系统,等价 timer:send_interval

    {handle_call, 3},       %从mod_player模块路由到这里的gen_server 回调, 等价Module:handle_call
    {handle_cast, 2},       %从mod_player模块路由到这里的gen_server 回调, 等价Module:handle_cast
    {handle_info, 2},       %从mod_player模块路由到这里的gen_server 回调, 等价Module:handle_info

    {handle_interior, 2}     %处理子系统路由,内部接口方法,相当于内部调用接口
  ];
behaviour_info(_Other) ->
  undefined.

%% -------------------------------
%% gen_player统一处理方法
%% -------------------------------
%% application 启动时的数据初始化
start() ->
  ?TABLE = ets:new(?TABLE, [public, ordered_set, named_table, {keypos, 1}]),
  %% 所有模块插入
  module_insert(mod_player),
  module_insert(mod_player_extend),

  module_insert(mod_player_item),
  module_insert(mod_player_task),

  module_insert(mod_player_spirit),
  module_insert(mod_player_pet),
  module_insert(mod_player_apc),
  module_insert(mod_player_talisman),
  module_insert(mod_player_dungeon),
  module_insert(mod_player_liveness),
  module_insert(mod_player_battle),
  module_insert(mod_player_duplicate),
  module_insert(mod_player_gpm),
  ok.
%% application结束时的处理
%% 这里清理ets表
stop() ->
  true = ets:delete(?TABLE),
  ok.


%% 玩家进程初始化时调用,依次调用ets表中所有模块的初始化方法
%% 返回值:新的PlayerStatus
modules_init(PlayerStatus) ->
  Mods = module_list(),
  NewPlayerStatus =
    lists:foldl(
      fun(Mod, Acc) ->
        try
          %?T("-----------modules_init-----------, mod:~p", [Mod]),
          %?T
          Mod:init(Acc)
        catch
          _:Reason ->
            Stacktrace = erlang:get_stacktrace(),
            ?T("player_logger modules_init is mod:~p, state:~p, exception:~p, get_stacktrace:~p", [Mod, PlayerStatus, Reason, Stacktrace]),
            ?Error(player_logger, "player_logger modules_init is mod:~p, state:~p, exception:~p, get_stacktrace:~p", [Mod, PlayerStatus, Reason, Stacktrace]),
            Acc
        end
      end, PlayerStatus, Mods),
  NewPlayerStatus.


%% 玩家进程初始化时调用,依次调用ets表中所有模块的terminate方法
%% 返回值:ok
modules_terminate(PlayerStatus) ->
  Mods = lists:reverse(module_list()),
  [begin

     try
       Module:terminate(PlayerStatus)
     catch
       _:Reason ->
         Stacktrace = erlang:get_stacktrace(),
         ?T("player_logger modules_terminate is mod:~p, state:~p, exception:~p, get_stacktrace:~p", [Module, PlayerStatus, Reason, Stacktrace]),
         ?Error(player_logger, "player_logger modules_terminate is mod:~p, state:~p, exception:~p, get_stacktrace:~p", [Module, PlayerStatus, Reason, Stacktrace]),
         ok
     end
   end || Module <- Mods],
  ok.


%% -------------------------------
%% local functions
%% -------------------------------
%% 插入一条数据到ets中
module_insert(Module) ->
  Size = ets:info(?TABLE, size),
  ets:insert(?TABLE, {Size + 1, Module}).


%% @doc 获取module list,按照插入顺序返回
module_list() ->
  [Module || {_Key, Module} <- ets:tab2list(?TABLE)].





















