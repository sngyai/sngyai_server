%%%==============================================================================
%%% Author      :fangjie008@163.com
%%% Created     :2012-8
%%% Description :系统配置
%%%==============================================================================
-module(lib_system_config).
-include("common.hrl").
-include("system_config.hrl").
-include("chat.hrl").

-export([
  get/0,
  get/1,
  send_config/0,
  send_config/1,

  init/0,
  manage/1
]).

-export([get_time_zone/0]).



%%--------------------------------------------------------
%% 用户使用
%%--------------------------------------------------------

%% 获取所有的系统配置
%% 返回值:[#system_config]
get() ->
  ets:tab2list(?ETS_SYSTEM_CONFIG).

%% 根据id获取配置的value值
%% Key:对应system_config.hrl配置文件中的宏定义 system_config_type_xxx
%% 返回值:undefined | Value
get(Key) ->
  case ets:lookup(?ETS_SYSTEM_CONFIG, Key) of
    [] ->
      undefined;
    [System_Config] ->
      System_Config#system_config.value
  end.

%% 将配置信息发送到所有在线玩家
%% 返回值:不使用
send_config() ->
  List = lib_system_config:get(),
  {ok, Bin} = ph_10_account:handle(pack_send_system_config_response, List),
  mod_chat:send_to_all(Bin, ?SENDER_SYSTEM).

%% 将config发送到sid
%% Sid:玩家消息发送进程pid列表
%% 返回值:不使用
send_config(Sid) ->
  List = lib_system_config:get(),
  ph_10_account:handle(send_system_config_response, {Sid, List}).

%%--------------------------------------------------------
%% 后台操作相关
%%--------------------------------------------------------
%% 后台管理
%% msg=1006&op=1&id=1&value=1

%% 配置管理
manage(QS) ->
  ParaResult =
    try
      Op_Now = lib_util_type:to_integer(mod_webserver:resolve_parameter(op, QS)),
      Op_Now
    catch
      _:_Reason ->
        lists:concat(["para wrong ", lib_util_type:to_list(_Reason)])
    end,
  %?T("manage res:~p", [ParaResult]),
  case ParaResult of
    Op_Real when Op_Real =:= 1;Op_Real =:= 2 ->
      manage(Op_Real, QS);
    Other ->
      ?T("manage final:~s", [Other]),
      Other
  end.

%% op :修改
%% 返回值:操作结果字符串
manage(1, QS) ->
  %?T("manage qs:~p", [QS]),
  ParaResult =
    try
      Id_Now = lib_util_type:to_integer(mod_webserver:resolve_parameter(id, QS)),
      Value_Now = lib_util_type:to_integer(mod_webserver:resolve_parameter(value, QS)),
      {Id_Now, Value_Now}
    catch
      _:_Reason ->
        lists:concat(["para wrong ", lib_util_type:to_list(_Reason)])
    end,
  %?T("manage res:~p", [ParaResult]),
  case ParaResult of
    {Id, Value} ->
      manage(1, Id, Value);
    Other ->
      ?T("manage final:~s", [Other]),
      Other
  end;

%% 查询当前最新数据
manage(2, _QS) ->
  List = lib_system_config:get(),
  Key_Value_Pair = [{Id, Value} || #system_config{id = Id, value = Value} <- List],
  lib_util_string:key_value_to_json(Key_Value_Pair).

%% 修改
manage(1, Id, Value) ->
  case db_agent_system_config:replace(#system_config{id = Id, value = Value}) of
    true ->
      ets:insert(?ETS_SYSTEM_CONFIG, #system_config{id = Id, value = Value}),
      spawn(fun() -> send_config() end),
      "true";
    _Other ->
      lists:concat(["fail", lib_util_type:to_list(_Other)])
  end.


%%--------------------------------------------------------
%% 系统初始化相关
%%--------------------------------------------------------
%% 创建ets表初始化数据库数据到ets表中
%% 返回值:ok
init() ->
  ets:new(?ETS_SYSTEM_CONFIG, [{keypos, #system_config.id}, named_table, public, set]),      %%系统配置数据
  load_data(),

  ets:new(?ETS_TIME_ZONE_CONFIG, [{keypos, 2}, named_table, public, set]),      %%系统配置数据
  load_time_zone(),
  ok.


%% 数据库数据加载进ets表中
%% 返回值:不使用
load_data() ->
  case db_agent_system_config:list() of
    {record_list, System_config_list} when System_config_list =/= [] ->
      %?T("load_data ~p", [System_config_list]),
      ets:insert(?ETS_SYSTEM_CONFIG, System_config_list);
    _Other -> skip
  end.


%%--------------------------------------------------------
%% 时区相关
%%--------------------------------------------------------

%% 时区初始化
load_time_zone() ->
  Time_zone = (calendar:datetime_to_gregorian_seconds(erlang:localtime()) - calendar:datetime_to_gregorian_seconds(erlang:universaltime())) div 3600,
  ets:insert(?ETS_TIME_ZONE_CONFIG, {time_zone, Time_zone}),
  Time_zone.

%% 获取时区,返回小时数
get_time_zone() ->
  case ets:lookup(?ETS_TIME_ZONE_CONFIG, time_zone) of
    [] ->
      load_time_zone();
    [{time_zone, Time_Zone}] ->
      Time_Zone
  end.











