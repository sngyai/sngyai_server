%%%-------------------------------------------------------------------
%%% @author sngyai
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. 九月 2014 上午2:27
%%%-------------------------------------------------------------------
-module(t_apns).
-author("sngyai").

-compile(export_all).


-include("common.hrl").
-include("apns.hrl").
-include("localized.hrl").

conn_apns() ->
  ssl:start(),
  apns:start(),
  apns:connect(
    ?APNS_NAME,
    fun handle_apns_error/2,
    fun handle_apns_delete_subscription/1
  ).

send_message()->
  apns:send_message(?APNS_NAME, "31e45ec45977603adf584cf3d82447babe328849b5cbf9b0c30e96fdbfdf4db6", "hello,这是一号话务员").

send_message(Msg) ->
  apns:send_message(my_connection_name, #apns_msg{
    alert  = Msg ,
    badge  = 5,
    sound  = "beep.wav" ,
    expiry = 1348000749,
    device_token = "devicetoken31d1df3a324bb72c1ff2bcb3b87d33fd1a2b7578b359fb5494eff"
  }).

send_badge(Number)->
  apns:send_badge(qiaoqiao_apns,"devicetoken31d1df3a324bb72c1ff2bcb3b87d33fd1a2b7578b359fb5494eff", Number).

handle_apns_error(MsgId, Status) ->
  ?Error(default_logger, "error: ~p - ~p~n", [MsgId, Status]),
  error_logger:error_msg("error: ~p - ~p~n", [MsgId, Status]).

handle_apns_delete_subscription(Data) ->
  ?Error(default_logger, "delete subscription: ~p~n", [Data]),
  error_logger:info_msg("delete subscription: ~p~n", [Data]).