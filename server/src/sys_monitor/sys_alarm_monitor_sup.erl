%%------------------------------------------------------------------------------
%%          系统警报监控树
%%% @author tianjun
%%% @doc
%%      挂载
%%          垃圾回收进程 sys_background_gc
%%          内存监控进程 vm_memory_monitor
%%          警报处理进程 sys_alarm_handler
%%------------------------------------------------------------------------------

-module(sys_alarm_monitor_sup).
-behaviour(supervisor).

-include("common.hrl").

-export([start_link/0]).
-export([init/1]).


start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
  MemoryWatermark = lib_config:get_vm_memory_high_watermark(),%{vm_memory_high_watermark, 2048} 单位/MB 内存警戒线
  MemLim = MemoryWatermark * 1024 * 1024,% 单位/字节
  {ok,
    {
      {one_for_one, 10, 10},
      [
        {
          sys_background_gc,
          {sys_background_gc, start_link, []},
          permanent,
          10000,
          worker,
          [mod_background_gc]
        },
        {
          vm_memory_monitor,
          {vm_memory_monitor, start_link, [MemLim,
            fun sys_alarm_handler:handle_event_memory_set_alarm/1,
            fun sys_alarm_handler:handle_event_memory_clear_alarm/1]},
          permanent,
          10000,
          worker,
          [vm_memory_monitor]
        },
        {sys_alarm_handler,
          {sys_alarm_handler, start_link, []},
          permanent,
          10000,
          worker,
          dynamic
        }
      ]
    }
  }.
