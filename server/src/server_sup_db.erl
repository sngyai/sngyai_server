%%%==============================================================================
%%% Author      :fangjie008@163.com
%%% Created     :2012-8
%%% Description :db的监控supervisor
%%%==============================================================================
-module(server_sup_db).

-behaviour(supervisor).

-define(MYSQL_SERVER, mysql_dispatcher).
-include("common.hrl").

-export([start_link/0, init/1]).

-export([start_db_conn/0, start_db_link/0]).

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

%% 与msyql建立连接
start_db_conn() ->
  ets:new(?ETS_STAT_DB, [set, public, named_table]),
  Spec =
    {?MYSQL_SERVER, {?MODULE, start_db_link, []},
      permanent, 100, worker, []},
  case catch supervisor:start_child(?MODULE, Spec) of
    {error, {already_started, _}} ->
      ok;
    {error, _Reason} ->
      ?Error(db_logger, "连接数据库失败:~p!", [_Reason]),
      ?T("DB_CON FAILED:~p!", [_Reason]),
      {error, _Reason};
    {ok, _} ->
      ?T("与中心数据库连接成功"),
      ok
  end.


%% 用来启动mysql的start_link
%% 返回值:{ok, Pid} | ignore
start_db_link() ->
  db_agent:init_db().





