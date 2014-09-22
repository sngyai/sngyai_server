%% The contents of this file are subject to the Mozilla Public License
%% Version 1.1 (the "License"); you may not use this file except in
%% compliance with the License. You may obtain a copy of the License
%% at http://www.mozilla.org/MPL/
%%
%% Software distributed under the License is distributed on an "AS IS"
%% basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
%% the License for the specific language governing rights and
%% limitations under the License.
%%
%% The Original Code is RabbitMQ.
%%
%% The Initial Developer of the Original Code is VMware, Inc.
%% Copyright (c) 2007-2012 VMware, Inc.  All rights reserved.
%%
%%------------------------------------------------------------------------------
%%          系统垃圾回收器 GC
%%% @author tianjun
%%% @doc
%%      当内存超过设置的预警线 将发出警报 Alarm 在 sys_alarm_handler 中处理
%%------------------------------------------------------------------------------

-module(sys_background_gc).

-behaviour(gen_server).

-include("common.hrl").

-export([run/0, start_interval/0]).
-export([gc/0]). %% For run_interval only

-export([start_link/0, init/1, handle_call/3, handle_cast/2, handle_info/2,
  terminate/2, code_change/3]).

-define(MAX_RATIO, 0.01).


%%----------
%% 宏定义
%%----------
-ifdef(product).
-define(IDEAL_INTERVAL, 60000).%GC时间间隔周期 单位/毫秒
-else.
-define(IDEAL_INTERVAL, 20000).%GC时间间隔周期 单位/毫秒
-endif.

-record(state, {last_interval}).


start_link() -> gen_server:start_link({local, ?MODULE}, ?MODULE, [],
  [{timeout, infinity}]).

%% 执行一次GC
run() -> gen_server:cast(?MODULE, run).

%% 启动轮训间隔GC
start_interval() -> gen_server:cast(?MODULE, interval_gc).

%%----------------------------------------------------------------------------

init([]) -> {ok, #state{last_interval = ?IDEAL_INTERVAL}}.

handle_call(Msg, _From, State) ->
  {stop, {unexpected_call, Msg}, {unexpected_call, Msg}, State}.

handle_cast(run, State) -> gc(), {noreply, State};

handle_cast(interval_gc, State) -> interval_gc(State), {noreply, State};

handle_cast(Msg, State) -> {stop, {unexpected_cast, Msg}, State}.

handle_info(interval_gc, State) -> {noreply, interval_gc(State)};

handle_info(Msg, State) -> {stop, {unexpected_info, Msg}, State}.

code_change(_OldVsn, State, _Extra) -> {ok, State}.

terminate(_Reason, State) -> State.

%%----------------------------------------------------------------------------

interval_gc(State = #state{last_interval = LastInterval}) ->
  {ok, Interval} = interval_operation(
    {?MODULE, gc, []},
    ?MAX_RATIO, ?IDEAL_INTERVAL, LastInterval),
  erlang:send_after(Interval, self(), interval_gc),
  ?T("------background_gc----interval_gc last_interval : ~p ~n", [Interval]),
  State#state{last_interval = Interval}.

gc() ->
  ?T("------background_gc---- gc ---start----time:~p------~n", [lib_util_time:get_fine_timestamp()]),
  gc_pro(processes()),
%    [fun()-> garbage_collect(P), timer:sleep(50) end || P <- processes(),
%                           {status, waiting} == process_info(P, status)],
  garbage_collect(), %% since we will never be waiting...

  ?T("------background_gc---- gc ---end-----time:~p-----~n", [lib_util_time:get_fine_timestamp()]),
  ok.

%进程GC
gc_pro([]) ->
  ok;
gc_pro([P | Processes]) ->
  case process_info(P, status) of
    {status, waiting} ->
      garbage_collect(P),
      timer:sleep(10);
    _Other ->
      skip
  end,
  gc_pro(Processes).

%% Ideally, you'd want Fun to run every IdealInterval. but you don't
%% want it to take more than MaxRatio of IdealInterval. So if it takes
%% more then you want to run it less often. So we time how long it
%% takes to run, and then suggest how long you should wait before
%% running it again. Times are in millis.
interval_operation({M, F, A}, MaxRatio, IdealInterval, LastInterval) ->
  {Micros, Res} = timer:tc(M, F, A),
  {Res, case {Micros > 1000 * (MaxRatio * IdealInterval),
    Micros > 1000 * (MaxRatio * LastInterval)} of
          {true, true} -> round(LastInterval * 1.5);
          {true, false} -> LastInterval;
          {false, false} -> lists:max([IdealInterval,
            round(LastInterval / 1.5)])
        end}.