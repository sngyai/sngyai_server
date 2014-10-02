%%%-------------------------------------------------------------------
%%% @author yangyudong
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. 九月 2014 上午12:29
%%%-------------------------------------------------------------------
-module(lib_exchange).
-author("yangyudong").

-include("record.hrl").
-include("common.hrl").

%% API
-export([
  exchange/5,
  get_all/0,
  get_user_log/1,
  daily_exchange/0
  ]).

%%兑换
exchange(UserId, UserName, Type, Account, Num) ->
  case ets:lookup(?ETS_ONLINE, UserId) of
    [#user{score_current = SC}|_] ->
      case Num =< SC of
        true ->
          lib_user:add_score(UserId, -Num),
          Time = lib_util_time:get_timestamp(),
          Id = mod_increase_exchange_log:new_id(),
          ExchangeLog =
            #exchange_log{
              id = Id,
              user_id = UserId,
              name = UserName,
              time = Time,
              type = Type,
              account = Account,
              num = Num
            },
          ets:insert(?ETS_EXCHANGE_LOG, ExchangeLog),
          db_agent_exchange_log:add(ExchangeLog);
        false ->
          "score_not_enough"
      end;
    _Other ->
      "user_not_exist"
  end.



get_all() ->
  List = ets:tab2list(?ETS_EXCHANGE_LOG),
  lists:concat(["[", concat_result(List, []), "]"]).

get_user_log(UserId) ->
  List =
    case ets:match_object(?ETS_EXCHANGE_LOG, #exchange_log{user_id = UserId, _='_'}) of
      [] ->
        [];
      L ->
        lists:reverse(lists:keysort(#exchange_log.time, L))
    end,
  ?T("hello, world ***** get_user_log: ~p", [List]),
  lists:concat(["[", concat_result(List, []), "]"]).

concat_result([], Result) ->
  Result;
concat_result([Exchange|T], Result) ->
  #exchange_log{
    user_id = UserId,
    time = Time,
    type = Type,
    account = Account,
    num = Num,
    status = Status
  } = Exchange,
  CurResult = lists:concat(["{\"user_id\":\"", UserId,
    "\",\"time\":\"", Time,
    "\",\"type\":\"", Type,
    "\",\"account\":\"", Account,
    "\",\"num\":\"", Num,
    "\",\"status\":\"", Status,
    "\"}"
  ]),
  NewResult =
    case Result of
      [] ->
        CurResult;
      _Other ->
        lists:concat([Result, ",", CurResult])
    end,
  concat_result(T, NewResult).

%%每日兑换
daily_exchange() ->
  AllExchanges = ets:tab2list(?ETS_EXCHANGE_LOG),
  ?T("HELLO, WORLD*******DAILY_EXCHANGE:~p~n", [AllExchanges]),
  Fun =
    fun(#exchange_log{id = Id, account = Account, num = Num}, AccountSumList) ->
      OldSum =
        case proplists:get_value(Account, AccountSumList) of
          undefined ->
            0;
          Val ->
            Val
        end,
      NewSum = Num + OldSum,
      ets:delete(?ETS_EXCHANGE_LOG, Id),
      db_agent_exchange_log:set_status(Id), %更新状态
      [{Account, NewSum}|proplists:delete(Account, AccountSumList)]
    end,
  ExchangeList = lists:foldl(Fun, [], AllExchanges),
  ?T("HELLO, WORLD*******DAILY_EXCHANGE 2 :~p~n", [ExchangeList]),
  [db_agent_exchange:update_db_exchange(Account, Sum)||{Account, Sum} <- ExchangeList].


