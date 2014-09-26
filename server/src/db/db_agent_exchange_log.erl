%%%-------------------------------------------------------------------
%%% @author yangyudong
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. 九月 2014 上午2:37
%%%-------------------------------------------------------------------
-module(db_agent_exchange_log).
-author("yangyudong").

-include("common.hrl").
-include("record.hrl").

%% API
-export([
  add/1,
  get_all/0,

  get_update/0
]).

add(ExchangeLog) ->
  ValueList = lists:nthtail(2, record2data(ExchangeLog)),
  [_Id | FieldList] = record_info(fields, exchange_log),
  {insert, _, _} = ?DB_GAME:insert(db_exchange_log, FieldList, ValueList),
  ok.

get_all() ->
  {record_list, Result} = ?DB_GAME:select_record_list_with(exchange_log, fun data2record/2, db_exchange_log, "*", []),
  Result.

get_update() ->
  TimeBegin = lib_util_time:get_timestamp() - (?RELOAD_TICK + 5),
  {record_list, Result} = ?DB_GAME:select_record_list_with(exchange_log, fun data2record/2, db_exchange_log, "*", [{last_update, ">" ,TimeBegin}]),
  Result.

data2record(account, Value) ->
  TrandNo =
    case Value of
      undefined ->
        undefined;
      Other ->
        binary_to_list(Other)
    end,
  {account, TrandNo};
data2record(user_id, Value) ->
  UserId =
    case Value of
      undefined ->
        undefined;
      Other ->
        binary_to_list(Other)
    end,
  {user_id, UserId};
data2record(Key, Value) ->
  {Key, Value}.



record2data(Exchange) ->
  tuple_to_list(Exchange#exchange_log{
  }
  ).