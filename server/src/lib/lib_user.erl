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
  ?T("user_id:~p, tab2list:~p", [UserId, ets:tab2list(?ETS_ONLINE)]),
  {ScoreCurrent, ScoreTotal} =
    case ets:lookup(?ETS_ONLINE, UserId) of
    [#user{score_current = SC, score_total = ST}|_] ->
      {SC, ST};
    _Other -> %用户不存在，创建一个
      create_role(UserId),
      {0, 0}
  end,
  Result =
    [
      {"score_current", lib_util_type:term_to_string(ScoreCurrent)},
      {"score_total", lib_util_type:term_to_string(ScoreTotal)}
    ],
  lib_util_string:key_value_to_json(Result).

%%完成任务，更新积分
%%UserId用户唯一标识T
%%Score获得积分
add_score(UserId, Score) ->
  case ets:lookup(?ETS_ONLINE, UserId) of
    [#user{score_current = SC, score_total = ST} = UserInfo|_] ->
      ?T("HELLO, WORLD ***********SC:~p, ST:~p, SCORE:~p~n",[SC, ST, Score]),
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
      ?T("add_score_error:~p~n ~p~n", [_Other, ets:tab2list(?ETS_ONLINE)]),
      ?Error(default_logger, "add_score_error:~p~n ~p~n", [_Other, ets:tab2list(?ETS_ONLINE)]),
      skip
  end.


t() ->
  create_role("1A2C").





