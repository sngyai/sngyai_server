%%%--------------------------------------
%%% @Module     : main
%%% @Created    : 2012.06.18
%%% @Description: 服务器总入口
%%%--------------------------------------
-module(main).

%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------
-include("common.hrl").
-include_lib("stdlib/include/ms_transform.hrl").

%%--------------------------------------------------------------------
%%-define(Macro, value).
%%-record(state, {}).
%%--------------------------------------------------------------------
-define(SERVER_APPS, [log4erl, sasl, os_mon, server]).

%%--------------------------------------------------------------------
%% External exports
%%--------------------------------------------------------------------
-export([
  server_start/0,
  server_stop/0,
  rpc_server_stop/1
]).

%% 启动游戏服务器
server_start() ->
  try
    ok = start_applications(?SERVER_APPS)
    %?Fatal(default_logger, "server_started")
  after
    timer:sleep(100)
  end.


%% 停止游戏服务器
server_stop() ->
  %%首先关闭外部接入，然后停止目前的连接，等全部连接正常退出后，再关闭应用
  ok = stop_applications(?SERVER_APPS),
  io:format("server_stoped ~n"),
  ?Fatal(default_logger, "server_stoped"),
  timer:sleep(10000),
  erlang:halt(0, [{flush, false}]).

%% RPC停止游戏服务器
%% Node 节点名
rpc_server_stop([Node]) ->
  io:format("   rpc:call game server stopping ... ~p ~n", [Node]),
  rpc:call(Node, lib_manage, kick_all_player, []),% 踢掉在线玩家
  rpc:call(Node, main, server_stop, []),% 停止服务
  io:format("   server_stoped finish ...~n"),
  erlang:halt(),
  ok.

%% ############辅助调用函数##############
%% 启动应用程序列表
%% Apps:当前要启动的列表
%% 返回值:ok
start_applications(Apps) ->
  manage_applications(fun lists:foldl/3,
    fun application:start/1,
    fun application:stop/1,
    already_started,
    cannot_start_application,
    Apps).

%% 停止已启动的应用程序列表
%% Apps:当前要停止的应用程序列表
%% 返回值:ok
stop_applications(Apps) ->
  manage_applications(fun lists:foldr/3,
    fun application:stop/1,
    fun application:start/1,
    not_started,
    cannot_stop_application,
    Apps).

%% 管理应用程序的启动和停止
%% Iterate:遍历方法, Do:正常执行的方法, Undo:失败回滚方法, SkipError:已经处理的匹配, ErrorTag:失败的匹配, Apps:当前要处理的列表
%% 返回值:ok
manage_applications(Iterate, Do, Undo, SkipError, ErrorTag, Apps) ->
  Iterate(fun(App, Acc) ->
    case Do(App) of
      ok -> [App | Acc];%合拢
      {error, {SkipError, _}} -> Acc;
      {error, Reason} ->
        lists:foreach(Undo, Acc),
        throw({error, {ErrorTag, App, Reason}})
    end
  end, [], Apps),
  ok.


	
