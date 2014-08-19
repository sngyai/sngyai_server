%%%-----------------------------------
%%% @Module  : tcp_listener_sup
%%% @Author  : fangjie008@gmail.com
%%% @Created : 2012.06.15
%%% @Description: tcp listerner �����
%%%-----------------------------------
-module(tcp_listener_sup).

-behaviour(supervisor).

-export([start_link/1]).
-export([init/1]).

start_link(Port) ->
  supervisor:start_link(?MODULE, {10, Port}).

init({AcceptorCount, Port}) ->
  {ok,
    {{one_for_all, 10, 10},
      [
        {
          tcp_acceptor_sup,
          {tcp_acceptor_sup, start_link, []},
          transient,
          infinity,
          supervisor,
          [tcp_acceptor_sup]
        },
        {
          tcp_listener,
          {tcp_listener, start_link, [AcceptorCount, Port]},
          transient,
          1000,
          worker,
          [tcp_listener]
        }
      ]
    }
  }.
