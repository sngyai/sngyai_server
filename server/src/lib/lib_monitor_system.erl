-module(lib_monitor_system).
%% 监控系统状态
-include("common.hrl").
-include("record.hrl").

-export([
  get_system_info/1,
  get_online_count/1,
  delete_monitor_pid/1
]).

%%查询在线人数，类型定义
-define(ONLINE_COUNT_TOTAL, 1).     %全部在线人数
-define(ONLINE_COUNT_MAP, 2).       %指定场景在线人数
-define(ONLINE_COUNT_COPY, 3).      %指定副本在线人数

-define(SYSTEM_INFO_GENERAL, 1).    %服务器运行状况概要
-define(SYSTEM_INFO_MEMRORY, 2).    %服务器内存状况
-define(SYSTEM_INFO_PROCESS, 3).    %服务器进程状况

%%------------------------------------- 对lib_manage接口 start---------------------------
%% 查询服务器运行状况
%% ParaList:参数列表:格式[{key, Value} | ...]
%% 返回值
%%      [{key, Value}|...]
get_system_info(ParaList) ->
  Type = lib_util_type:to_integer(mod_webserver:resolve_parameter("type", ParaList)),
  case Type of
    ?SYSTEM_INFO_GENERAL -> %查看系统概要状况
      get_system_info_general();
    ?SYSTEM_INFO_MEMRORY -> %查看系统内存使用状况
      get_system_info_memory();
    _OTHER ->   %参数错误
      "-100"
  end.

%%获取在线人数
%% ParaList:参数列表:格式[{key, Value} | ...]
%% 返回值
%%      {TYPE, OnlineCount} | 定义好的消息号:
%%          其中TYPE为ParaList中指定的要查询的范围（原子，如total_online，map_online）
%%          OnlineCount为TYPE对应的在线人数（整型）
get_online_count(ParaList) ->
  Type = lib_util_type:to_integer(mod_webserver:resolve_parameter("type", ParaList)),
  case Type of
    ?ONLINE_COUNT_TOTAL ->  %查询所有在线人数
      lists:concat(["{\"online_count_total\":", get_online_count_total(), "}"]);
    _Other -> %参数错误
      "-100"
  end.

%%------------------------------------- 对lib_manage接口 end---------------------------


%%------------------------------------- 系统监控内部方法 start -------------------------
%%查询服务器运行状况概要
get_system_info_general() ->
  MemTotal = erlang:memory(total),
  ProcCnt = erlang:system_info(process_count),
  ProcLmt = erlang:system_info(process_limit),
  PortCnt = length(erlang:ports()),
  [
    {memory_total, MemTotal},
    {process_count, ProcCnt},
    {process_limit, ProcLmt},
    {port_count, PortCnt}
  ].

%%查询服务器内存使用详细状况
get_system_info_memory() ->
  Memory = erlang:memory(),
  MemoryList =
    [begin
       MKey2 = lists:concat([memory, "_", MKey]),
       {list_to_atom(MKey2), MVal}
     end || {MKey, MVal} <- Memory],
  MemoryList.

%% 获取实时在线人数(全部)
%% 返回值 OnlineCount:在线人数(整型)
get_online_count_total() ->
  ets:info(?ETS_ONLINE, size).

%%------------------------------------- 系统监控内部方法 end -------------------------

%% 删除监控的进程
%% 参数
%%      Pid 进程ID
%% 不使用返回值
delete_monitor_pid(Pid) ->
  ets:delete(?ETS_MONITOR_PID, Pid).


