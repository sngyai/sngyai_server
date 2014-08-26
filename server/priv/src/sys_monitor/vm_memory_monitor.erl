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

%% In practice Erlang shouldn't be allowed to grow to more than a half
%% of available memory. The pessimistic scenario is when the Erlang VM
%% has a single process that's consuming all memory. In such a case,
%% during garbage collection, Erlang tries to allocate a huge chunk of
%% continuous memory, which can result in a crash or heavy swapping.
%%
%% This module tries to warn Rabbit before such situations occur, so
%% that it has a higher chance to avoid running out of memory.
%%------------------------------------------------------------------------------
%%          系统内存监视器
%%% @author tianjun  vm_memory_monitor:get_current_sys_memory_status().
%%% @doc
%%%     内存警戒线 MemLim 单位/字节
%%      当内存超过设置的预警线 将发出警报 Alarm 在 sys_alarm_handler 中处理
%%      当内存降低预警线以下 将发出清除警报 Alarm 在 sys_alarm_handler 中处理
%%------------------------------------------------------------------------------
-module(vm_memory_monitor).

-behaviour(gen_server).

-export([start_link/1, start_link/3]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
  terminate/2, code_change/3]).

-export([
  get_total_memory/0,
  get_total_memory/1,
  get_vm_limit/0,
  get_check_interval/0,
  set_check_interval/1,
  get_vm_memory_high_watermark/0,
  set_vm_memory_high_watermark/1,
  get_current_sys_memory_status/0
]).

-include("common.hrl").

-define(SERVER, ?MODULE).

%%----------
%% 宏定义
%%----------
-ifdef(product).
-define(DEFAULT_MEMORY_CHECK_INTERVAL, 30000).%检测间隔时间 毫秒
-else.
-define(DEFAULT_MEMORY_CHECK_INTERVAL, 10000).%检测间隔时间 毫秒
-endif.
-define(ONE_MB, 1048576).

%% For an unknown OS, we assume that we have 1*4 GB of memory. It'll be
%% wrong. Scale by vm_memory_high_watermark in configuration to get a
%% sensible value.
-define(MEMORY_SIZE_FOR_UNKNOWN_OS, 1073741824 * 4).%缺省位置系统 4GB
%% 单位/字节
-record(state, {total_memory,
  memory_limit,
  timeout,
  timer,
  alarmed,
  alarm_funs
}).

%%----------------------------------------------------------------------------
%% Public API
%%----------------------------------------------------------------------------

get_total_memory() -> get_total_memory(os:type()).

get_vm_limit() -> get_vm_limit(os:type()).

get_check_interval() ->
  gen_server:call(?MODULE, get_check_interval, infinity).

set_check_interval(Timeout) ->
  gen_server:call(?MODULE, {set_check_interval, Timeout}, infinity).

get_vm_memory_high_watermark() ->
  gen_server:call(?MODULE, get_vm_memory_high_watermark, infinity).

set_vm_memory_high_watermark(MemLim) ->
  gen_server:call(?MODULE, {set_vm_memory_high_watermark, MemLim},
    infinity).

%% 获取内存详细情况
get_current_sys_memory_status() ->
  gen_server:call(?MODULE, current_sys_memory_status, infinity).

%%----------------------------------------------------------------------------
%% gen_server callbacks
%%----------------------------------------------------------------------------

%% 内存警戒线值 MemLim 单位/字节
start_link(MemLim) ->
  start_link(MemLim,
    fun alarm_handler:set_alarm/1, fun alarm_handler:clear_alarm/1).

start_link(MemLim, AlarmSet, AlarmClear) ->
  gen_server:start_link({local, ?SERVER}, ?MODULE,
    [MemLim, {AlarmSet, AlarmClear}], []).

init([MemLim, AlarmFuns]) ->
  TRef = start_timer(?DEFAULT_MEMORY_CHECK_INTERVAL),
  State = #state{timeout = ?DEFAULT_MEMORY_CHECK_INTERVAL,
    timer = TRef,
    alarmed = false,
    alarm_funs = AlarmFuns},
  {ok, set_mem_limits(State, MemLim)}.

handle_call(get_vm_memory_high_watermark, _From, State) ->
  {reply, State#state.memory_limit, State};
%% 内存警戒线值 MemLim 单位/字节
handle_call({set_vm_memory_high_watermark, MemLim}, _From, State) ->
  {reply, ok, set_mem_limits(State, MemLim)};

handle_call(get_check_interval, _From, State) ->
  {reply, State#state.timeout, State};

handle_call({set_check_interval, Timeout}, _From, State) ->
  {ok, cancel} = timer:cancel(State#state.timer),
  {reply, ok, State#state{timeout = Timeout, timer = start_timer(Timeout)}};

%% 获取当前系统内存状态
handle_call(current_sys_memory_status, _From, State) ->
  Status = [
    {os_total_memory, round(State#state.total_memory / (1024 * 1024)), 'Mb'},%系统总内存
    {vm_memory_used, round(erlang:memory(total) / (1024 * 1024)), 'Mb'},%虚拟机已占用内存
    {memory_limit, round(State#state.memory_limit / (1024 * 1024)), 'Mb'}%内存警戒线
  ],
  {reply, Status, State};

handle_call(_Request, _From, State) ->
  {noreply, State}.

handle_cast(_Request, State) ->
  {noreply, State}.

handle_info(update, State) ->
  {noreply, internal_update(State)};

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

%%----------------------------------------------------------------------------
%% Server Internals
%%----------------------------------------------------------------------------
%% 内存警戒线值 MemLim 单位/字节
set_mem_limits(State, MemLim) when is_integer(MemLim) andalso MemLim > 0 ->
  TotalMemory =
    case get_total_memory() of
      unknown ->
        case State of
          #state{total_memory = undefined,
            memory_limit = undefined} ->
            ?Error(sys_monitor_logger, "Unknown total memory size for your OS ~p. Assuming memory size is ~pMB.~n", [os:type(), trunc(?MEMORY_SIZE_FOR_UNKNOWN_OS / ?ONE_MB)]);
          _ ->
            ok
        end,
        ?MEMORY_SIZE_FOR_UNKNOWN_OS;
      M -> M
    end,
  UsableMemory = case get_vm_limit() of
                   Limit when Limit < TotalMemory ->
                     Limit;
                   _ ->
                     TotalMemory
                 end,
  FinalMemLim = case MemLim > UsableMemory of
                  true ->
                    UsableMemory;
                  false ->
                    MemLim
                end,
  internal_update(State#state{total_memory = TotalMemory,
    memory_limit = FinalMemLim}).

internal_update(State = #state{memory_limit = MemLimit,
  alarmed = Alarmed,
  alarm_funs = {AlarmSet, AlarmClear}}) ->
  MemUsed = erlang:memory(total),
  NewAlarmed = MemUsed > MemLimit,
  case {Alarmed, NewAlarmed} of
    {false, true} -> emit_update_info(set, MemUsed, MemLimit),%超过内存警戒线
      AlarmSet({{resource_limit, memory, node()}, []});
    {true, false} -> emit_update_info(clear, MemUsed, MemLimit),%低于内存警戒线
      AlarmClear({resource_limit, memory, node()});
    _ -> ok
  end,
  State#state{alarmed = NewAlarmed}.

emit_update_info(AlarmState, MemUsed, MemLimit) ->
  ?Error(sys_monitor_logger, "vm_memory_high_watermark ~p. current Memory used:~p MB   allowed_limit:~p  MB ~n", [AlarmState, round(MemUsed / (1024 * 1024)), round(MemLimit / (1024 * 1024))]).

start_timer(Timeout) ->
  {ok, TRef} = timer:send_interval(Timeout, update),
  TRef.

%% According to http://msdn.microsoft.com/en-us/library/aa366778(VS.85).aspx
%% Windows has 2GB and 8TB of address space for 32 and 64 bit accordingly.
get_vm_limit({win32, _OSname}) ->
  case erlang:system_info(wordsize) of
    4 -> 2 * 1024 * 1024 * 1024;          %% 2 GB for 32 bits  2^31
    8 -> 8 * 1024 * 1024 * 1024 * 1024      %% 8 TB for 64 bits  2^42
  end;

%% On a 32-bit machine, if you're using more than 4 gigs of RAM you're
%% in big trouble anyway.
get_vm_limit(_OsType) ->
  case erlang:system_info(wordsize) of
    4 -> 4 * 1024 * 1024 * 1024;          %% 4 GB for 32 bits  2^32
    8 -> 256 * 1024 * 1024 * 1024 * 1024    %% 256 TB for 64 bits 2^48
  %%http://en.wikipedia.org/wiki/X86-64#Virtual_address_space_details
  end.

%%----------------------------------------------------------------------------
%% Internal Helpers
%%----------------------------------------------------------------------------
cmd(Command) ->
  Exec = hd(string:tokens(Command, " ")),
  case os:find_executable(Exec) of
    false -> throw({command_not_found, Exec});
    _ -> os:cmd(Command)
  end.

%% get_total_memory(OS) -> Total
%% Windows and Freebsd code based on: memsup:get_memory_usage/1
%% Original code was part of OTP and released under "Erlang Public License".

get_total_memory({unix, darwin}) ->
  File = cmd("/usr/bin/vm_stat"),
  Lines = string:tokens(File, "\n"),
  Dict = dict:from_list(lists:map(fun parse_line_mach/1, Lines)),
  [PageSize, Inactive, Active, Free, Wired] =
    [dict:fetch(Key, Dict) ||
      Key <- [page_size, 'Pages inactive', 'Pages active', 'Pages free',
        'Pages wired down']],
  PageSize * (Inactive + Active + Free + Wired);

get_total_memory({unix, freebsd}) ->
  PageSize = sysctl("vm.stats.vm.v_page_size"),
  PageCount = sysctl("vm.stats.vm.v_page_count"),
  PageCount * PageSize;

get_total_memory({unix, openbsd}) ->
  sysctl("hw.usermem");

get_total_memory({win32, _OSname}) ->
  %% Due to the Erlang print format bug, on Windows boxes the memory
  %% size is broken. For example Windows 7 64 bit with 4Gigs of RAM
  %% we get negative memory size:
  %% > os_mon_sysinfo:get_mem_info().
  %% ["76 -1658880 1016913920 -1 -1021628416 2147352576 2134794240\n"]
  %% Due to this bug, we don't actually know anything. Even if the
  %% number is postive we can't be sure if it's correct. This only
  %% affects us on os_mon versions prior to 2.2.1.
  case application:get_key(os_mon, vsn) of
    undefined ->
      unknown;
    {ok, _Version} ->
      [Result | _] = os_mon_sysinfo:get_mem_info(),
      {ok, [_MemLoad, TotPhys, _AvailPhys,
        _TotPage, _AvailPage, _TotV, _AvailV], _RestStr} =
        io_lib:fread("~d~d~d~d~d~d~d", Result),
      TotPhys
  end;

get_total_memory({unix, linux}) ->
  File = read_proc_file("/proc/meminfo"),
  Lines = string:tokens(File, "\n"),
  Dict = dict:from_list(lists:map(fun parse_line_linux/1, Lines)),
  dict:fetch('MemTotal', Dict);

get_total_memory({unix, sunos}) ->
  File = cmd("/usr/sbin/prtconf"),
  Lines = string:tokens(File, "\n"),
  Dict = dict:from_list(lists:map(fun parse_line_sunos/1, Lines)),
  dict:fetch('Memory size', Dict);

get_total_memory({unix, aix}) ->
  File = cmd("/usr/bin/vmstat -v"),
  Lines = string:tokens(File, "\n"),
  Dict = dict:from_list(lists:map(fun parse_line_aix/1, Lines)),
  dict:fetch('memory pages', Dict) * 4096;

get_total_memory(_OsType) ->
  unknown.

%% A line looks like "Foo bar: 123456."
parse_line_mach(Line) ->
  [Name, RHS | _Rest] = string:tokens(Line, ":"),
  case Name of
    "Mach Virtual Memory Statistics" ->
      ["(page", "size", "of", PageSize, "bytes)"] =
        string:tokens(RHS, " "),
      {page_size, list_to_integer(PageSize)};
    _ ->
      [Value | _Rest1] = string:tokens(RHS, " ."),
      {list_to_atom(Name), list_to_integer(Value)}
  end.

%% A line looks like "FooBar: 123456 kB"
parse_line_linux(Line) ->
  [Name, RHS | _Rest] = string:tokens(Line, ":"),
  [Value | UnitsRest] = string:tokens(RHS, " "),
  Value1 = case UnitsRest of
             [] -> list_to_integer(Value); %% no units
             ["kB"] -> list_to_integer(Value) * 1024
           end,
  {list_to_atom(Name), Value1}.

%% A line looks like "Memory size: 1024 Megabytes"
parse_line_sunos(Line) ->
  case string:tokens(Line, ":") of
    [Name, RHS | _Rest] ->
      [Value1 | UnitsRest] = string:tokens(RHS, " "),
      Value2 = case UnitsRest of
                 ["Gigabytes"] ->
                   list_to_integer(Value1) * ?ONE_MB * 1024;
                 ["Megabytes"] ->
                   list_to_integer(Value1) * ?ONE_MB;
                 ["Kilobytes"] ->
                   list_to_integer(Value1) * 1024;
                 _ ->
                   Value1 ++ UnitsRest %% no known units
               end,
      {list_to_atom(Name), Value2};
    [Name] -> {list_to_atom(Name), none}
  end.

%% Lines look like " 12345 memory pages"
%% or              "  80.1 maxpin percentage"
parse_line_aix(Line) ->
  [Value | NameWords] = string:tokens(Line, " "),
  Name = string:join(NameWords, " "),
  {list_to_atom(Name),
    case lists:member($., Value) of
      true -> trunc(list_to_float(Value));
      false -> list_to_integer(Value)
    end}.

sysctl(Def) ->
  list_to_integer(cmd("/sbin/sysctl -n " ++ Def) -- "\n").

%% file:read_file does not work on files in /proc as it seems to get
%% the size of the file first and then read that many bytes. But files
%% in /proc always have length 0, we just have to read until we get
%% eof.
read_proc_file(File) ->
  {ok, IoDevice} = file:open(File, [read, raw]),
  Res = read_proc_file(IoDevice, []),
  file:close(IoDevice),
  lists:flatten(lists:reverse(Res)).

-define(BUFFER_SIZE, 1024).
read_proc_file(IoDevice, Acc) ->
  case file:read(IoDevice, ?BUFFER_SIZE) of
    {ok, Res} -> read_proc_file(IoDevice, [Res | Acc]);
    eof -> Acc
  end.
