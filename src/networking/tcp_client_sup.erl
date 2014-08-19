%%%-----------------------------------
%%% @Module  : tcp_client_sup
%%% @Author  : fangjie008@gmail.com
%%% @Created : 2012.06.15
%%% @Description: 客户端服务监控树
%%%-----------------------------------
-module(tcp_client_sup).

-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
  {ok, {{simple_one_for_one, 10, 10},
    [{tcp_request_broker, {tcp_request_broker, start_link, []},
      temporary, 8000, worker, [tcp_request_broker]}]}}.
 