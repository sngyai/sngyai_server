%%%-------------------------------------------------------------------
%%% @author yangyudong
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. ?? 2014 ??12:26
%%%-------------------------------------------------------------------
-module(lib_callback).
-author("yangyudong").

-include("common.hrl").
-include("channel.hrl").
-include("record.hrl").
-include("apns.hrl").

%% API
-export([deal/5]).

deal(Idfa, ChannelId, TrandNo, Cash, AppName) ->
  case ets:match_object(?ETS_TASK_LOG, #task_log{channel = ChannelId, trand_no = TrandNo, _='_'}) of
    [] ->
      %%添加任务记录
      lib_task_log:add(Idfa, ChannelId, TrandNo, AppName, Cash),
      %%增加积分
      lib_user:add_score(Idfa, Cash),
      push_notification(Idfa, ChannelId, AppName, Cash);
    _Other -> %%重复的流水
      ?T("duplicate trand req:~n  Idfa:~p~n  Channel:~p~n  TrandNo:~p~n  AppName:~p~n  Cash:~p~n", [Idfa, ChannelId, TrandNo, AppName, Cash]),
      ?Error(trand_logger, "duplicate trand req:~n  Idfa:~p~n, Channel:~p~n  TrandNo:~p~n  AppName:~p~n  Cash:~p~n", [Idfa, ChannelId, TrandNo, AppName, Cash])
  end.

push_notification(Idfa, Channel, AppName, Score) ->
%%   ?T("charset: ~p ~p ~p~n", [AppName, "??", lists:concat(["??", unicode:characters_to_list(AppName)])]),
  AppNameStr = mochiutf8:bytes_to_codepoints(list_to_binary(AppName)),
  case lib_user:get_tokens(Idfa) of
    [] ->
      ?T("no tokens: ~p~n", [Idfa]),
      ?Error(default_logger, "no tokens: ~p~n", [Idfa]);
    Token ->
      Msg =
        lists:concat(["恭喜你在", config_channel_name(Channel), "中通过", AppNameStr, "获得", Score, "积分"]),
      apns:send_message(?APNS_NAME, Token, Msg)
  end.

config_channel_name(?CHANNEL_ADWO) ->
  "安沃";
config_channel_name(?CHANNEL_YOUMI) ->
  "有米";
config_channel_name(?CHANNEL_MIIDI) ->
  "米迪";
config_channel_name(?CHANNEL_GUOMOB) ->
  "果盟";
config_channel_name(?CHANNEL_COCOUNION) ->
  "触控";
config_channel_name(?CHANNEL_DOMOB) ->
  "多盟";
config_channel_name(?CHANNEL_ADSAGE) ->
  "艾德思奇";
config_channel_name(?CHANNEL_JUPENG) ->
  "巨朋".




