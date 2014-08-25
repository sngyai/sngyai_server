%%%-----------------------------------
%%% @Module  : tcp_acceptor_sup
%%% @Author  : fangjie008@gmail.com
%%% @Created : 2012.06.15
%%% @Description: tcp acceptor �����
%%%-----------------------------------
-module(tcp_acceptor_sup).

-behaviour(supervisor).

-export([start_link/0, init/1]).

start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).


init([]) ->
  {ok, {{simple_one_for_one, 10, 10},
    [{tcp_acceptor, {tcp_acceptor, start_link, []},
      transient, brutal_kill, worker, [tcp_acceptor]}]}}.
