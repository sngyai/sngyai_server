%%%==============================================================================
%%% Author      :fangjie008@163.com
%%% Created     :2012-8
%%% Description :模块自动加载及热更新方法
%%%==============================================================================
-module(mod_reloader).

-include("common.hrl").
-include_lib("kernel/include/file.hrl").

-behaviour(gen_server).
-record(state, {last, tref}).

-export([start_link/1]).
-export([stop/0, reload/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-export([all_changed/0, is_changed/1]).
-export([reload_modules/1]).


%% @doc 启动服务器,Interval指定多少秒自动加载一次代码,注意,单位秒
%% 0表示不进行自动加载
start_link(Interval) ->
  ?T("RELOAD_INTERVAL interval:~p", [Interval]),
  gen_server:start_link({local, ?MODULE}, ?MODULE, Interval, ?Public_Service_Options).

%% @spec stop() -> ok
%% @doc Stop the reloader.
stop() ->
  gen_server:call(?MODULE, stop).

%% @doc 重新加载代码,返回加载失败的模块列表
reload() ->
  gen_server:call(?MODULE, doit).


%% gen_server callbacks

%% @spec init([]) -> {ok, State}
%% @doc gen_server init, opens the server in an initial state.
init(Interval) ->
  put(tag, ?MODULE),
  process_flag(trap_exit, true),
  case Interval of
    0 -> %如果是0不自动更新
      {ok, #state{last = stamp()}};
    _ ->
      {ok, TRef} = timer:send_interval(timer:seconds(Interval), doit),
      {ok, #state{last = stamp(), tref = TRef}}
  end.

%% @spec handle_call(Args, From, State) -> tuple()
%% @doc gen_server callback.
handle_call(stop, _From, State) ->
  {stop, shutdown, stopped, State};
handle_call(doit, _From, State) ->
  Now = stamp(),
  Reply = doit(State#state.last, Now),
  {reply, Reply, State};
handle_call(_Req, _From, State) ->
  {reply, {error, badrequest}, State}.

%% @spec handle_cast(Cast, State) -> tuple()
%% @doc gen_server callback.
handle_cast(_Req, State) ->
  {noreply, State}.

%% @spec handle_info(Info, State) -> tuple()
%% @doc gen_server callback.
handle_info(doit, State) ->
  Now = stamp(),
  doit(State#state.last, Now),
  {noreply, State#state{last = Now}};
handle_info(_Info, State) ->
  {noreply, State}.

%% @spec terminate(Reason, State) -> ok
%% @doc gen_server termination callback.
terminate(_Reason, #state{tref = {_Identifying, Ref} = TRef}) ->
  %?T("do_terminate"),
  %timer:sleep(1000),
  if
    is_reference(Ref) ->
      {ok, cancel} = timer:cancel(TRef);
    true ->
      ok
  end,
  ok.

%% @spec code_change(_OldVsn, State, _Extra) -> State
%% @doc gen_server code_change callback (trivial).
code_change(_Vsn, State, _Extra) ->
  {ok, State}.

%% @spec reload_modules([atom()]) -> [{module, atom()} | {error, term()}]
%% @doc code:purge/1 and code:load_file/1 the given list of modules in order,
%%      return the results of code:load_file/1.
reload_modules(Modules) ->
  [begin code:purge(M), code:load_file(M) end || M <- Modules].

%% @spec all_changed() -> [atom()]
%% @doc Return a list of beam modules that have changed.
all_changed() ->
  [M || {M, Fn} <- code:all_loaded(), is_list(Fn), is_changed(M)].

%% @spec is_changed(atom()) -> boolean()
%% @doc true if the loaded module is a beam with a vsn attribute
%%      and does not match the on-disk beam file, returns false otherwise.
is_changed(M) ->
  try
    module_vsn(M:module_info()) =/= module_vsn(code:get_object_code(M))
  catch _:_ ->
    false
  end.

%% Internal API

module_vsn({M, Beam, _Fn}) ->
  {ok, {M, Vsn}} = beam_lib:version(Beam),
  Vsn;
module_vsn(L) when is_list(L) ->
  {_, Attrs} = lists:keyfind(attributes, 1, L),
  {_, Vsn} = lists:keyfind(vsn, 1, Attrs),
  Vsn.

%% 检查所有文件,进行加载
doit(From, To) ->
  [begin
     case file:read_file_info(Filename) of
       {ok, #file_info{mtime = Mtime}} when Mtime >= From, Mtime < To ->
         io:format("doit module:~p ...~n", [Module]),
         reload(Module);
       {ok, _} ->
         unmodified;
       {error, enoent} ->
         %% The Erlang compiler deletes existing .beam files if
         %% recompiling fails.  Maybe it's worth spitting out a
         %% warning here, but I'd want to limit it to just once.
         gone;
       {error, Reason} ->
         io:format("Error reading ~s's file info: ~p~n",
           [Filename, Reason]),
         error
     end
  %         if
  %             Module =:= syntax_tests ->
  %                 {ok, #file_info{mtime = Mtime1}} = file:read_file_info(Filename),
  %                 io:format("doit module:~p, Mtime1:~p, from:~p, to:~p~n", [Module, Mtime1, From, To]);
  %             true -> skip
  %         end
   end
    || {Module, Filename} <- code:all_loaded(), is_list(Filename)].

reload(Module) ->
  io:format("Reloading ~p ...~n", [Module]),
  case code:soft_purge(Module) of %如果没有进程使用就清理
    true ->
      case code:load_file(Module) of
        {module, Module} ->
          reload;
        {error, Reason} ->
          io:format(" fail: ~p.~n", [Reason]),
          error
      end;
    false ->
      io:format(" can't purge.~n", []),
      not_purge
  end.

stamp() ->
  erlang:localtime().

%%
%% Tests
%%
-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.
