%%%-------------------------------------------------------------------
%%% Module  : db_agent
%%% Author  : 
%%% Description : 统一的数据库处理模块
%%%-------------------------------------------------------------------
-module(db_agent).

%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------
-include("common.hrl").

%%-define(Macro, value).
%%-record(state, {}).


%% 调试输出相关-------------------------------------------------------------------------------------------------------------------
%condition macro


%%--------------------------------------------------------------------
%% External exports
%%--------------------------------------------------------------------
-export([
  init_db/0,
  init_mysql/1
]).

%%############数据库初始化##############
%% 数据库连接初始化
%% 返回值:ignore | {ok, Pid}
init_db() ->
  case lib_config:get_server_type() of
    0 ->
      init_mysql();
    _Other ->
      ignore
  end.

%% mysql数据库连接初始化
%% 返回值:{ok, Pid} | ignore
init_mysql() ->
  init_mysql(lib_config:get_mysql_config()).

init_mysql({Host, Port, User, Password, DB, Encode, Pool_size}) ->
  case mysql:start_link(?MYSQL_DB_POOL_GAME, Host, Port, User, Password, DB, fun mysqllogfun/4, Encode) of
    {ok, Pid} ->
      LTemp = lists:duplicate(Pool_size, dummy),
      % 启动conn pool
      [begin
         mysql:connect(?MYSQL_DB_POOL_GAME, Host, Port, User, Password, DB, Encode, true, true)
       end || _ <- LTemp],
      {ok, Pid};
    {error, {already_started, _}} ->
      ignore;
    {error, _Reason} ->
      ?Error(db_logger, "连接数据库失败:~p!", [_Reason]),
      throw(io_lib:format("连接数据库失败~p", [_Reason])),
      {error, _Reason}
  end.



-ifdef(product).
mysqllogfun(_Module, _Line, debug, _FormatFun) ->
  ok;
mysqllogfun(_Module, _Line, _Level, FormatFun) ->
  {Format, Arguments} = FormatFun(),
  ?T("mysql info module:~p, line:~p, level:~p, des:" ++ Format, [_Module, _Line, _Level] ++ Arguments).
-else.
mysqllogfun(_Module, _Line, debug, _FormatFun) ->
  ok;
mysqllogfun(_Module, _Line, _Level, _FormatFun) ->
  %    {Format, Arguments} = FormatFun(),
  %    ?T("mysql info module:~p, line:~p, level:~p, des:" ++ Format, [_Module, _Line, _Level] ++ Arguments).
  ok.
-endif.

