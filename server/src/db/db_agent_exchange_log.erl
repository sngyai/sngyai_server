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
  get_all/0
]).

add(ExchangeLog) ->
  ValueList = lists:nthtail(2, record2data(ExchangeLog)),
  [_Id | FieldList] = record_info(fields, exchange_log),
  {insert, _, _} = ?DB_GAME:insert(db_exchange_log, FieldList, ValueList),
  ok.

get_all() ->
  {record_list, Result} = ?DB_GAME:select_record_list_with(exchange_log, fun data2record/2, db_exchange_log, "*", []),
  Result.

data2record(account, Value) ->
  TrandNo = lib_util_type:string_to_term(Value),
  {account, TrandNo};
data2record(user_id, Value) ->
  {user_id, lib_util_type:string_to_term(Value)};
data2record(Key, Value) ->
  {Key, Value}.



record2data(Exchange) ->
  tuple_to_list(Exchange#exchange_log{
    account = lib_util_type:term_to_string(Exchange#exchange_log.account),
    user_id = lib_util_type:term_to_string(Exchange#exchange_log.user_id)
  }
  ).