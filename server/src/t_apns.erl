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
  apns:send_message(?APNS_NAME, "12b8ce5a593bb25985e2d66de6588cee19734c324bfc60dc028267af80f04f27", "hello,这是一号话务员").

send_message(Msg) ->
  apns:send_message(?APNS_NAME, #apns_msg{
    alert  = Msg ,
%%     sound  = "beep.wav" ,
    sound  = "default",
    device_token = "12b8ce5a593bb25985e2d66de6588cee19734c324bfc60dc028267af80f04f27"
  }).

send_badge(Number)->
  apns:send_badge(?APNS_NAME,"12b8ce5a593bb25985e2d66de6588cee19734c324bfc60dc028267af80f04f27", Number).

handle_apns_error(MsgId, Status) ->
  ?Error(default_logger, "error: ~p - ~p~n", [MsgId, Status]),
  error_logger:error_msg("error: ~p - ~p~n", [MsgId, Status]).

handle_apns_delete_subscription(Data) ->
  ?Error(default_logger, "delete subscription: ~p~n", [Data]),
  error_logger:info_msg("delete subscription: ~p~n", [Data]).