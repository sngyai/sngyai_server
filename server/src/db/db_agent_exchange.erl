%%%-------------------------------------------------------------------
%%% @author sngyai
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 九月 2014 上午1:47
%%%-------------------------------------------------------------------
-module(db_agent_exchange).
-author("sngyai").

-define(TABLE, db_exchange).

-include("common.hrl").
-include("record.hrl").

%% API
-export([
    get_exchange/1,
    update_db_exchange/2,
    new/1,
    update/1
]).

get_exchange(Account) ->
    case ?DB_GAME:select_record(exchange, db_exchange, "*", [{id, Account}]) of
        {record, []} ->
            error;
        {record, Exchange} ->
            {ok, Exchange};
        Error ->
            {error, Error}
    end.

new(Exchange) ->
    ValueList = lists:nthtail(1, tuple_to_list(Exchange)),
    FieldList = record_info(fields, exchange),
    {insert, _, _} = ?DB_GAME:insert(db_exchange, FieldList, ValueList),
    ok.

update(Exchange) ->
    ValueList = lists:nthtail(2, tuple_to_list(Exchange)),
    [_Id | FieldList] = record_info(fields, exchange),
    {update, _} = ?DB_GAME:update(db_exchange, FieldList, ValueList, [{"id", Exchange#exchange.id}]),
    ok.



%%更新兑换表
update_db_exchange(Account, Num) ->
  case ?DB_GAME:select_one(?TABLE, "sum", [{id, Account}]) of
    {scalar, []} ->%没有找到，初始化
      ?T("insert Reason~p~p", [Account, Num]),
      FieldList = [id,sum],
      ValueList = [Account,Num],
      {insert, _, _} = ?DB_GAME:insert(?TABLE, FieldList, ValueList);
    {scalar, _Sum} ->%数据库表中目前最大ID值
      ?T("update Reason~p", [_Sum]),
      {update, _} = ?DB_GAME:update(?TABLE, [{sum, {Num, add}}, {last_update,lib_util_time:get_timestamp()}, {status, 0}], [{"id", Account}]);
    {error, Reason} ->
      ?T("error Reason~p", [Reason]),
      {error, Reason}
  end.