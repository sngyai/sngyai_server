%%%-----------------------------------
%%% @Module  : tcp_acceptor
%%% @Author  : fangjie008@gmail.com
%%% @Created : 2012.06.15
%%% @Description: tcp acceptor
%%%-----------------------------------
-module(tcp_acceptor).

-behaviour(gen_server).

-export([start_link/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {sock, ref}).

start_link(LSock) ->
  gen_server:start_link(?MODULE, {LSock}, []).

%% --------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%% --------------------------------------------------------------------
init({LSock}) ->
  put(tag, ?MODULE),
  gen_server:cast(self(), accept),
  {ok, #state{sock = LSock}}.

%% --------------------------------------------------------------------
%% Function: handle_call/3
%% Description: Handling call messages
%% Returns: {reply, Reply, State}          |
%%          {reply, Reply, State, Timeout} |
%%          {noreply, State}               |
%%          {noreply, State, Timeout}      |
%%          {stop, Reason, Reply, State}   | (terminate/2 is called)
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_call(_Request, _From, State) ->
  {reply, ok, State}.

%% --------------------------------------------------------------------
%% Function: handle_cast/2
%% Description: Handling cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_cast(accept, State) ->
  accept(State);

handle_cast(_Msg, State) ->
  {noreply, State}.

%% --------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
%% 接收到inet_async消息,设置option,然后启动对应进程,继续监听
handle_info({inet_async, LSock, Ref, {ok, Sock}}, State = #state{sock = LSock, ref = Ref}) ->
  case set_sockopt(LSock, Sock) of
    ok -> ok;
    {error, Reason} -> exit({set_sockopt, Reason})
  end,
  start_client(Sock),
  accept(State);

handle_info({inet_async, LSock, Ref, {error, closed}}, State = #state{sock = LSock, ref = Ref}) ->
  {stop, normal, State};

handle_info(_Info, State) ->
  {noreply, State}.

%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(_Reason, State) ->
  gen_tcp:close(State#state.sock),
  ok.

%% --------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
  {ok, State}.


%%-----------------------------------私有函数--------------------------
%% 设置socket
set_sockopt(LSock, Sock) ->
  true = inet_db:register_socket(Sock, inet_tcp),
  case prim_inet:getopts(LSock, [active, nodelay, keepalive, delay_send, priority, tos, send_timeout, exit_on_close]) of
    {ok, Opts} ->
      case prim_inet:setopts(Sock, Opts) of
        ok -> ok;
        Error ->
          gen_tcp:close(Sock),
          Error
      end;
    Error ->
      gen_tcp:close(Sock),
      Error
  end.

%% 接收socket连接请求
%% State:当前进程状态
accept(State = #state{sock = LSock}) ->
  %io:format("~p--accept ~n", [lib_util_time:get_timestamp()]),
  %% 自身进程会收到{inet_async, LSock, Ref, {ok, Sock}}消息
  case prim_inet:async_accept(LSock, -1) of
    {ok, Ref} -> {noreply, State#state{ref = Ref}};
    Error -> {stop, {cannot_accept, Error}, State}
  end.


%% 启动针对新建立的socket连接的对应子进程
%% Sock新建立的socket
start_client(Sock) ->
  %io:format("~p--start_client ~n", [lib_util_time:get_timestamp()]),
  {ok, Child} = supervisor:start_child(tcp_client_sup, []),
  ok = gen_tcp:controlling_process(Sock, Child),
  Child ! {go, Sock}.









