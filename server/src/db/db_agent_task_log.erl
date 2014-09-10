%%%-------------------------------------------------------------------
%%% @author Yudong
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. 九月 2014 4:47
%%%-------------------------------------------------------------------
-module(db_agent_task_log).
-author("Yudong").

-include("common.hrl").
-include("record.hrl").


%% API
-export([
  add/1,
  get_user_task/1,
  get_all_tasks/0
]).

%%创建新用户
add(Task) ->
  ValueList = lists:nthtail(2, record2data(Task)),
  [_Id | FieldList] = record_info(fields, task_log),
  {insert, _, _} = ?DB_GAME:insert(db_task_log, FieldList, ValueList),
  ok.

get_user_task(UserId) ->
  case ?DB_GAME:select_record_with(task_log, fun data2record/2, db_task_log, "*", [{user_id, UserId}]) of
    {record, TaskList} -> {ok, TaskList};
    Error ->
      ?T("get_user_by_name: ~p~n", [Error]),
      Error
  end.

get_all_tasks() ->
  {record_list, Result} = ?DB_GAME:select_record_list_with(task_log, fun data2record/2, db_task_log, "*", []),
  Result.

data2record(app_name, Value) ->
  AppName = lib_util_type:string_to_term(Value),
  {app_name, AppName};
data2record(user_id, Value) ->
  {user_id, binary_to_list(Value)};
%% data2record(app_name, Value) ->
%%   {app_name, binary_to_list(Value)};
data2record(Key, Value) ->
  {Key, Value}.



record2data(User) ->
  tuple_to_list(User#task_log{
    app_name = lib_util_type:term_to_string(User#task_log.app_name)
  }
  ).


