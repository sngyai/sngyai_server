%%%-------------------------------------------------------------------
%%% @author yangyudong
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. 九月 2014 上午12:26
%%%-------------------------------------------------------------------
-module(lib_callback).
-author("yangyudong").

-include("common.hrl").
-include("channel.hrl").
-include("record.hrl").

%% API
-export([deal/5]).

deal(Idfa, ChannelId, TrandNo, Cash, AppName) ->
  case ets:match_object(?ETS_TASK_LOG, #task_log{channel = ChannelId, trand_no = TrandNo, _='_'}) of
    [] ->
      %%添加任务记录
      lib_task_log:add(Idfa, ChannelId, TrandNo, AppName, Cash),
      %%更新用户积分
      lib_user:add_score(Idfa, Cash);
    _Other -> %%重复的交易
      ?T("duplicate trand req:~n  Idfa:~p~n  Channel:~p~n  TrandNo:~p~n  AppName:~p~n  Cash:~p~n", [Idfa, ChannelId, TrandNo, AppName, Cash]),
      ?Error(trand_logger, "duplicate trand req:~n  Idfa:~p~n, Channel:~p~n  TrandNo:~p~n  AppName:~p~n  Cash:~p~n", [Idfa, ChannelId, TrandNo, AppName, Cash])
  end.