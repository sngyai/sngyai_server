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
  login/3,
  add_score/2,
  dec_score/2,
  set_tokens/3,
  get_tokens/1,
  get_id/1,
  set_account/3,
  get_account/2,
  do_exchange/3,

  set_ip/2,

  get_user_name/1
]).

%%登录
login(Id, IDFA, IPAddress) ->
  {Name, ScoreCurrent, ScoreTotal} =
    case ets:lookup(?ETS_ONLINE, Id) of
      [#user{name = UserName, score_current = SC, score_total = ST}=Info|_] ->
        NewInfo =
          Info#user{
            ip = IPAddress,
            idfa = IDFA
          },
        update_user(NewInfo),
        {UserName, SC, ST};
      _Other -> %用户不存在，创建一个
        UserName = create_role(Id, IDFA, IPAddress),
        {UserName, 0, 0}
    end,
  Result =
    [
      {"user_name", lib_util_type:term_to_string(Name)},
      {"score_current", lib_util_type:term_to_string(ScoreCurrent)},
      {"score_total", lib_util_type:term_to_string(ScoreTotal)}
    ],
  lib_util_string:key_value_to_json(Result).

%%更新用户tokens
set_tokens(UserId, Tokens, IPAddress) ->
  case ets:lookup(?ETS_ONLINE, UserId) of
    [#user{} = UserInfo | _] ->
      NewUserInfo =
        UserInfo#user{
          tokens = Tokens,
          ip = IPAddress
        },
      update_user(NewUserInfo);
    _Other ->
      skip
  end.

%%根据用户IDFA查找用户token
get_tokens(Idfa) ->
  case ets:match_object(?ETS_ONLINE, #user{idfa = Idfa, _='_'}) of
    [#user{tokens = Tokens} | _] when Tokens =/= undefined ->
      Tokens;
    _Other ->
      []
  end.

%%根据用户IDFA查找用户ID
get_id(Idfa) ->
  case ets:match_object(?ETS_ONLINE, #user{idfa = Idfa, _='_'}) of
    [#user{id = Id} | _] when Id =/= undefined ->
      Id;
    _Other ->
      []
  end.

%%绑定支付宝
set_account(UserId, Account, IPAddress) ->
  case ets:lookup(?ETS_ONLINE, UserId) of
    [] ->
      lists:concat(["{\"error\":\"", "bind_failed", "\"}"]);
    [#user{account = Ac, ip = IP} = UserInfo | _]
      when Ac =/= Account; IP =/= IPAddress ->
      NewUserInfo =
        UserInfo#user{
          account = Account,
          ip = IPAddress
        },
      update_user(NewUserInfo);
    _Other ->
      skip
  end.

%%获取绑定的支付宝账号
get_account(UserId, IPAddress) ->
  Account =
    case ets:lookup(?ETS_ONLINE, UserId) of
      [#user{account = Ac,ip=IP}=UserInfo | _] when Ac =/= undefined ->
        case IP =/= IPAddress of
          true ->
            NewUser = UserInfo#user{ip = IPAddress},
            update_user(NewUser);
          false ->
            skip
        end,
        Ac;
      _Other ->
        ""
    end,
  lists:concat(["{\"alipay\":\"", Account, "\"}"]).

%%更新ip
set_ip(UserId, IPAddress) ->
  case ets:lookup(?ETS_ONLINE, UserId) of
    [#user{ip = IP}=UserInfo|_] when IP =/= IPAddress ->
      NewInfo =
        UserInfo#user{
          ip = IPAddress
        },
      update_user(NewInfo);
    _Other ->
      skip
  end.

%%兑换积分
do_exchange(UserId, Exchange, IPAddress) ->
  case Exchange > 0 of
    true ->
      case ets:lookup(?ETS_ONLINE, UserId) of
        [#user{name = UserName, score_current = SC, account = Account, ip = IP}=UserInfo| _] ->
          case IP =/= IPAddress of
            true ->
              NewUserInfo = UserInfo#user{ip = IPAddress},
              update_user(NewUserInfo);
            false ->
              skip
          end,
          case SC >= Exchange of
            true ->
              case Account =/= undefined andalso
                Account =/= [] andalso
                Account =/= "" of
                true ->
                  lib_exchange:exchange(UserId, UserName, ?EXCHANGE_TYPE_ALIPAY, Account, Exchange);
                false ->
                  lists:concat(["{\"error\":\"", "bind_account", "\"}"])
              end;
            false ->
              lists:concat(["{\"error\":\"", "score_not_enough", "\"}"])
          end;
        _Other ->
          lists:concat(["{\"error\":\"", "exchange_failed", "\"}"])
      end;
    false ->
      lists:concat(["{\"error\":\"", "wrong_num", "\"}"])
  end.

%%获取用户赚钱号
get_user_name(Id) ->
  case ets:lookup(?ETS_ONLINE, Id) of
    [#user{name = Name}| _] ->
      Name;
    _Other ->
      -1
  end.

%%完成任务，更新积分
%%UserId用户唯一标识
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
      update_user(NewUserInfo);
    _Other ->
      ?Error(default_logger, "add_score_error: ~p~n ~p~n ~p~n", [UserId, _Other, ets:tab2list(?ETS_ONLINE)])
  end.

%%兑换扣除积分
%%UserId 用户唯一标识符
%%Score 扣除积分
dec_score(UserId, Score) ->
  case ets:lookup(?ETS_ONLINE, UserId) of
    [#user{score_current = SC} = UserInfo | _] ->
      ScoreCurrent = SC - Score,
      NewUserInfo =
        UserInfo#user{
          score_current = ScoreCurrent
        },
      update_user(NewUserInfo);
    _Other ->
      ?Error(default_logger, "add_score_error: ~p~n ~p~n ~p~n", [UserId, _Other, ets:tab2list(?ETS_ONLINE)])
  end.

%%创建用户
create_role(Id, IDFA, IPAddress) ->
  {Role, Name} = role(Id, IDFA, IPAddress),
  ets:insert(?ETS_ONLINE, Role),
  db_agent_user:create(Role),
  Name.

%%创建角色
role(Id, IDFA, IPAddress) ->
  Name = mod_increase_user:new_id(),
  {#user{
    id = Id,
    idfa = IDFA,
    name = Name,
    ip = IPAddress,
    create_time = lib_util_time:get_timestamp()
  }, Name}.

update_user(UserInfo) ->
  ets:insert(?ETS_ONLINE, UserInfo),
  db_agent_user:update(UserInfo).






