%%%-------------------------------------------------------------------
%%% @author Yudong
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. 八月 2014 22:13
%%%-------------------------------------------------------------------
-module(lib_user).
-author("Yudong").

-include("common.hrl").
-include("record.hrl").


%% API
-export([
  create_role/2,
  login/2
]).

%%创建用户
create_role(UserName, PassWd) ->
  case check_create(UserName) of
    error ->
      "user name already exist";
    ok ->
      NewUser =
        #user{
          id = mod_increase_player:new_id(),
          account = UserName,
          score = 0,
          money = 0,
          restrict_state = 0,
          passwd = PassWd
        },
      ets:insert(?ETS_ONLINE, NewUser),
      db_agent_user:create(NewUser),
      "ok"
  end.

%%验证用户名是否存在
check_create(UserName) ->
  ?T("create role:~p, ~p~n", [UserName, ets:tab2list(?ETS_ONLINE)]),
  case ets:match_object(?ETS_ONLINE, #user{account = UserName, _='_'}) of
    [User|_] when is_record(User, user)->
      error;
    _Other ->
      ?T("check create: ~p~n", [_Other]),
      ok
  end.

%%登录
login(UserName, Passwd) ->
  case check_login(UserName, Passwd) of
    {error, Error} ->
      Error;
    ok ->
      "ok"
  end.

%%验证登录是否合法
check_login(UserName, Passwd) ->
  case db_agent_user:get_user_by_name(UserName) of
    {ok, #user{passwd = Passwd}} ->
      ok;
    {ok, #user{passwd = Ps} = U} ->
      ?T("check_login: ~p ~p~n", [U, Ps]),
      {error, "passwd incorrect"};
    _Other ->
      ?T("check_login: ~p~n", [_Other]),
      {error, "user not exist"}
  end.

check_login_ets(UserName, Passwd) ->
  case ets:match_object(?ETS_ONLINE, #user{account = UserName, _='_'}) of
    [#user{passwd = Passwd}|_] ->
      ok;
    [#user{}] ->
      {error, "passwd incorrect"};
    _Other ->
      ?T("check create: ~p~n", [_Other]),
      {error, "user not exist"}
  end.








