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
-include("exchange.hrl").

%% API
-export([
  login/1,
  add_score/2,
  set_tokens/2,
  get_tokens/1,
  bind_account/2,
  get_account/1,
  do_exchange/2,

  get_user_name/1,

  t/0
]).

%%创建用户
create_role(Idfa) ->
  Name = mod_increase_user:new_id(),
  NewUser =
    #user{
      id = Idfa,
      name = Name,
      create_time = lib_util_time:get_timestamp()
    },
  ets:insert(?ETS_ONLINE, NewUser),
  db_agent_user:create(NewUser),
  Name.

create_role_with_tokens(Idfa, Tokens) ->
  Name = mod_increase_user:new_id(),
  NewUser =
    #user{
      id = Idfa,
      name = Name,
      score_current = 0,
      score_total = 0,
      account = "",
      tokens = Tokens
    },
  ets:insert(?ETS_ONLINE, NewUser),
  db_agent_user:create(NewUser),
  Name.

create_role_with_account(Idfa, Account) ->
  Name = mod_increase_user:new_id(),
  NewUser =
    #user{
      id = Idfa,
      score_current = 0,
      score_total = 0,
      account = Account,
      tokens = ""
    },
  ets:insert(?ETS_ONLINE, NewUser),
  db_agent_user:create(NewUser),
  Name.

%%登录
login(UserId, IPAddress) ->
  {Name, ScoreCurrent, ScoreTotal} =
    case ets:lookup(?ETS_ONLINE, UserId) of
      [#user{name = UserName, score_current = SC, score_total = ST}=Info|_] ->
          NewInfo =
            Info#user{
                ip = IPAddress
            },
          ets:insert(?ETS_ONLINE, NewInfo),
          db_agent_user:update(NewInfo),
        {UserName, SC, ST};
      _Other -> %用户不存在，创建一个
        UserName = create_role(UserId),
        {UserName, 0, 0}
    end,
  Result =
    [
      {"user_name", lib_util_type:term_to_string(Name)},
      {"score_current", lib_util_type:term_to_string(ScoreCurrent)},
      {"score_total", lib_util_type:term_to_string(ScoreTotal)}
    ],
  lib_util_string:key_value_to_json(Result).

%%完成任务，更新积分
%%UserId用户唯一标识T
%%Score获得积分
add_score(UserId, Score) ->
  case ets:lookup(?ETS_ONLINE, UserId) of
    [#user{score_current = SC, score_total = ST} = UserInfo | _] ->
      ScoreCurrent = SC + Score,
      ScoreTotal = ST + Score,
      NewUserInfo =
        UserInfo#user{
          score_current = ScoreCurrent,
          score_total = ScoreTotal
        },
      ets:insert(?ETS_ONLINE, NewUserInfo),
      db_agent_user:update_score(UserId, ScoreCurrent, ScoreTotal);
    _Other ->
      ?T("add_score_error:~p~n ~p~n", [_Other, ets:tab2list(?ETS_ONLINE)]),
      ?Error(default_logger, "add_score_error: ~p~n ~p~n ~p~n", [UserId, _Other, ets:tab2list(?ETS_ONLINE)])
  end.

%%更新用户tokens
set_tokens(UserId, Tokens) ->
  case ets:lookup(?ETS_ONLINE, UserId) of
    [#user{} = UserInfo | _] ->
      NewUserInfo = UserInfo#user{tokens = Tokens},
      ets:insert(?ETS_ONLINE, NewUserInfo),
      db_agent_user:set_tokens(UserId, Tokens);
    _Other ->
      create_role_with_tokens(UserId, Tokens)
  end.

%%获取用户token
get_tokens(UserId) ->
  case ets:lookup(?ETS_ONLINE, UserId) of
    [#user{tokens = Tokens} | _] when Tokens =/= undefined ->
      Tokens;
    _Other ->
      []
  end.

%%绑定支付宝
bind_account(UserId, Account) ->
  case ets:lookup(?ETS_ONLINE, UserId) of
    [#user{} = UserInfo | _] ->
      NewUserInfo = UserInfo#user{account = Account},
      ets:insert(?ETS_ONLINE, NewUserInfo),
      db_agent_user:set_account(UserId, Account);
    _Other ->
      create_role_with_account(UserId, Account)
  end.

%%获取绑定的支付宝账号
get_account(UserId) ->
  Account =
    case ets:lookup(?ETS_ONLINE, UserId) of
      [#user{account = Ac} | _] when Ac =/= undefined ->
        Ac;
      _Other ->
        ""
    end,
  lists:concat(["{\"alipay\":\"", Account, "\"}"]).

%%兑换积分
do_exchange(UserId, Exchange) ->
  ?T("exchange:~p~n ~p~n", [UserId, Exchange]),
  case Exchange > 0 of
    true ->
      case ets:lookup(?ETS_ONLINE, UserId) of
        [#user{name = UserName, score_current = SC, account = Account} | _] ->
          case SC >= Exchange of
            true ->
              case Account =/= undefined of
                true ->
                  lib_exchange:exchange(UserId, UserName, ?EXCHANGE_TYPE_ALIPAY, Account, Exchange);
                false ->
                  lists:concat(["{\"error\":\"", "bind_account", "\"}"])
              end;
            false ->
              lists:concat(["{\"error\":\"", "score_not_enough", "\"}"])
          end
      end;
    false ->
      lists:concat(["{\"error\":\"", "wrong_num", "\"}"])
  end.

%%获取用户赚钱号
get_user_name(Idfa) ->
  case ets:lookup(?ETS_ONLINE, Idfa) of
    [#user{name = Name}| _] ->
      Name;
    _Other ->
      0
  end.


t() ->
  create_role("1A2C").





