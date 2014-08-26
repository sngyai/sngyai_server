%% Author: Administrator
%% Created: 2011-4-2
%% Description: TODO: Add description to flash_start
-module(flash_start).

%%
%% Include files
%%
%% -define(TCP_OPTIONS, 
%% 		[binary, {packet, 0}, 
%% 		 {active, false}, 
%% 		 {reuseaddr, true}, 
%% 		 {nodelay, false}, 
%% 		 {delay_send, true}, 
%% 		 {send_timeout, 5000}, 
%% 		 {keepalive, true}, 
%% 		 {exit_on_close, true}]).

-define(TCP_OPTIONS, [binary, {packet, 0}, {active, false}, {reuseaddr, true}, {nodelay, false}, {delay_send, true}]).

-define(FLASHCOUNT, 10).

%%
%% Exported Functions
%%
-export([start/0]).

%% FLASH安全沙箱应答
-define(FL_POLICY_REQ, <<"<policy-file-request/>">>).
-define(FL_POLICY_FILE, <<"<cross-domain-policy><allow-access-from domain='*' to-ports='*' /></cross-domain-policy>">>).
%%
%% API Functions
%%
start() ->
  try
    case gen_tcp:listen(843, ?TCP_OPTIONS) of
      {ok, LSocket} ->
        lists:foreach(fun(_) ->
          spawn(fun() -> accept_socket(LSocket) end)
        end,
          lists:duplicate(?FLASHCOUNT, dummy)),
        ok;
      {error, Reason} ->
        io:format("listener start is error:~w~n", [Reason]),
        stop
    end
  catch
    _:Error ->
      io:format("Reason:~w~n", [Error]),
      error
  end,
  receive_cmd().

receive_cmd() ->
  register(flash_policy, self()),
  receive
    stop ->
      io:format("flash policy is stop~n"),
      stop;
    _ ->
      receive_cmd()
  end.





accept_socket(LSocket) ->
  try
    case gen_tcp:accept(LSocket) of
      {ok, Socket} ->
        spawn(fun() -> send_policy(Socket) end);
      {error, Reason} ->
        io:format("error:~w~n", [Reason]),
        error
    end
  catch
    _:Error ->
      io:format("accept_socket:~w", [Error]),
      error
  end,
  accept_socket(LSocket).

send_policy(Socket) ->
  gen_tcp:send(Socket, ?FL_POLICY_FILE),
  gen_tcp:close(Socket).

%% 	case gen_tcp:recv(Socket, 5, 5000) of
%% 		{ok, _}  ->
%% 				gen_tcp:send(Socket, ?FL_POLICY_FILE);
%% %% 				gen_tcp:close(Socket);
%% 		{error, _} ->
%% 			error
%% 	end.


%%
%% Local Functions
%%

