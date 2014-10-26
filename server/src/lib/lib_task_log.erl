%%%-------------------------------------------------------------------
%%% @author Yudong
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. 九月 2014 4:39
%%%-------------------------------------------------------------------
-module(lib_task_log).
-author("Yudong").

-include("record.hrl").
-include("common.hrl").

%% API
-export([
  add/6,
  query/1
]).

add(Id, Channel, TrandNo, AppName, Score, IPAddress) ->
  TaskLog =
    #task_log{
      id = {Channel, TrandNo},
      user_id = Id,
      name = lib_user:get_user_name(Id),
      time = lib_util_time:get_timestamp(),
      trand_no = TrandNo,
      channel = Channel,
      app_name = AppName,
      score = Score,
      ip = IPAddress
    },
  ets:insert(?ETS_TASK_LOG, TaskLog),
  db_agent_task_log:add(TaskLog).

%%查询用户完成任务记录
query(Id) ->
  List =
    case ets:match_object(?ETS_TASK_LOG, #task_log{user_id = Id, _ = '_'}) of
      [] ->
        [];
      L ->
        lists:reverse(lists:keysort(#task_log.time, L))
    end,
  lists:concat(["[", concat_result(List, []), "]"]).

concat_result([], Result) ->
  Result;
concat_result([TaskLog | T], Result) ->
  #task_log{
    user_id = UserId,
    time = Time,
    channel = Channel,
    trand_no = TrandNo,
    app_name = AppName,
    score = Score
  } = TaskLog,
  CurResult = lists:concat(["{\"user_id\":\"", UserId,
    "\",\"time\":\"", Time,
    "\",\"channel\":\"", Channel,
    "\",\"trand_no\":\"", TrandNo,
    "\",\"app_name\":\"", AppName,
    "\",\"score\":\"", Score,
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

