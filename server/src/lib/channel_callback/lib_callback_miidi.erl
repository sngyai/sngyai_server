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
-include("record.hrl").
-include("common.hrl").

%% API
-export([
  deal/4
  ]).

deal(Idfa, TrandNo, Cash, AppName) ->
  case ets:match_object(?ETS_TASK_LOG, #task_log{channel = ?CHANNEL_MIIDI, trand_no = TrandNo, _='_'}) of
    [] ->
      %%添加任务记录
      lib_task_log:add(Idfa, ?CHANNEL_MIIDI, TrandNo, AppName, Cash),
      %%更新用户积分
      lib_user:add_score(Idfa, Cash);
    _Other -> %%重复的交易
      ?T("duplicate miidi trand req:IDFA:~p~n, TrandNo:~p~n:AppName:~p~n Cash:~p~n", [Idfa, TrandNo, AppName, Cash]),
      ?Error(trand_logger, "duplicate miidi trand req:IDFA:~p~n, TrandNo:~p~n:AppName:~p~n Cash:~p~n", [Idfa, TrandNo, AppName, Cash])
  end.

