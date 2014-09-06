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
  add/5
  ]).

add(Idfa, Time, Channel, AppName, Score) ->
  TaskLog =
    #task_log{
      user_id = Idfa,
      time = Time,
      channel = Channel,
      app_name = AppName,
      score = Score
    },
  ets:insert(?ETS_TASK_LOG, TaskLog),
  db_agent_task_log:add(TaskLog).
