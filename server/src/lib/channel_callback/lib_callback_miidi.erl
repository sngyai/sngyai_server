%%%-------------------------------------------------------------------
%%% @author Yudong
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. 九月 2014 4:27
%%%-------------------------------------------------------------------
-module(lib_callback_miidi).
-author("Yudong").
-include("channel.hrl").

%% API
-export([
  deal/4
  ]).

deal(Idfa, TrandNo, AppName, Cash) ->
  Time = lib_util_time:get_timestamp(),
  add_task_log(Idfa, Time, AppName, Cash),

