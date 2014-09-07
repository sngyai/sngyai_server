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
  create_role/1,
  login/1,
  add_score/2,
  t/0
]).

%%创建用户
create_role(Idfa) ->
    NewUser =
      #user{
        id = Idfa,
        score_current = 0,
        score_total = 0,
        account = ""
      },
    ets:insert(?ETS_ONLINE, NewUser),
    db_agent_user:create(NewUser),
    "ok".

%%登录
login(UserId) ->
  case ets:lookup(?ETS_ONLINE, UserId) of
    [#user{score_current = SC, score_total = ST}|_] ->
      {SC, ST};
    _Other -> %用户不存在，创建一个
      create_role(UserId),
      {0, 0}
  end.

%%完成任务，更新积分
%%UserId用户唯一标识
%%Score获得积分
add_score(UserId, Score) ->
  case ets:lookup(?ETS_ONLINE, UserId) of
    [#user{score_current = SC, score_total = ST} = UserInfo|_] ->
      ScoreCurrent = SC + Score,
      ScoreTotal = SC + ST,
      NewUserInfo =
        UserInfo#user{
          score_current = ScoreCurrent,
          score_total = ScoreTotal
        },
      ets:insert(?ETS_ONLINE, NewUserInfo),
      db_agent_user:update_score(UserId, ScoreCurrent, ScoreTotal);
    _Other ->
      skip
  end.


t() ->
  create_role("1A2C").





