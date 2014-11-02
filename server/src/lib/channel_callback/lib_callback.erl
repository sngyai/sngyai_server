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
      case check_ip(Idfa, AppName) of
        {error, ErrorMsg} ->
          ?Error(trand_logger, "ip conficts trand req:~n  Idfa:~p~n, Channel:~p~n  TrandNo:~p~n  AppName:~p~n  Cash:~p~n", [Idfa, ChannelId, TrandNo, AppName, Cash]),
          case lib_user:get_tokens(Idfa) of
            [] ->
              ?Error(default_logger, "no tokens: ~p~n", [Idfa]);
            Token ->
              apns:send_message(?APNS_NAME,
                #apns_msg{
                  device_token = Token,
                  alert = ErrorMsg,
                  sound = "default"
                })
            end;
        {ok, IPAddress} ->
          %%添加任务记录
          lib_task_log:add(Idfa, ChannelId, TrandNo, AppName, Cash, IPAddress),
          %%增加积分
          lib_user:add_score(Idfa, Cash),
          push_notification(Idfa, ChannelId, AppName, Cash);
        _Other ->
          ?Error(trand_logger, "no ip_bind trand trand req:~n  Idfa:~p~n, Channel:~p~n  TrandNo:~p~n  AppName:~p~n  Cash:~p~n", [Idfa, ChannelId, TrandNo, AppName, Cash])
      end;
    _Other -> %%重复的流水
      ?Error(trand_logger, "duplicate trand req:~n  Idfa:~p~n, Channel:~p~n  TrandNo:~p~n  AppName:~p~n  Cash:~p~n", [Idfa, ChannelId, TrandNo, AppName, Cash])
  end.

push_notification(Idfa, Channel, AppName, Score) ->
  AppNameStr = mochiutf8:bytes_to_codepoints(list_to_binary(AppName)),
  case lib_user:get_tokens(Idfa) of
    [] ->
      ?Error(default_logger, "no tokens: ~p~n", [Idfa]);
    Token ->
      Msg =
        lists:concat(["恭喜你在", config_channel_name(Channel), "中通过", AppNameStr, "获得", Score, "积分"]),
      apns:send_message(?APNS_NAME,
        #apns_msg{
          device_token = Token,
          alert = Msg,
          sound = "default"
        })
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
config_channel_name(?CHANNEL_QUMI) ->
  "趣米";
config_channel_name(?CHANNEL_JUPENG) ->
  "巨朋";
config_channel_name(?CHANNEL_LIMEI) ->
  "力美";
config_channel_name(?CHANNEL_COOLAD) ->
  "酷告";
config_channel_name(?CHANNEL_MOPAN) ->
  "磨盘";
config_channel_name(_) ->
  "".



%%验证IP
check_ip(UserId, AppName) ->
  case ets:lookup(?ETS_ONLINE, UserId) of
    [#user{ip = IPAddress}| _] ->
      case ets:match_object(?ETS_TASK_LOG, #task_log{ip = IPAddress, app_name = AppName, _='_'}) of
        [] ->
          {ok, IPAddress};
        _Other ->
          ?Error(trand_logger, "ip conficts trand req:~n  Idfa:~p~n, AppName:~p~n, AppName2:~p~n,  IPAddress:~p~n, OtherIp:~p~n",
            [UserId,AppName,mochiutf8:bytes_to_codepoints(list_to_binary(AppName)),IPAddress, _Other]),
          ErrorMsg = lists:concat(["IP冲突，重复的任务: ", mochiutf8:bytes_to_codepoints(list_to_binary(AppName))]),
          {error, ErrorMsg}
      end;
    _Other ->
      skip
  end.



