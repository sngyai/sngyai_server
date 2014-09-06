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
  create_role/0,
  login/1
]).

%%创建用户
create_role() ->
    NewUser =
      #user{
        id = mod_increase_player:new_id(),
        score_current = 0,
        score_total = 0,
        account = ""
      },
    ets:insert(?ETS_ONLINE, NewUser),
    db_agent_user:create(NewUser),
    "ok".

%%登录
login(UserId) ->
  case ets:match_object(?ETS_ONLINE, #user{id = UserId, _='_'}) of
    [#user{score_current = SC, score_total = ST}|_] ->
      {SC, ST};
    _Other ->
      ?T("check create: ~p~n", [_Other]),
      "user not exist"
  end.








