%%%==============================================================================
%%% Author      :fangjie008@163.com
%%% Created     :2012-8
%%% Description :系统配置 db相关操作
%%%==============================================================================
-module(db_agent_system_config).
-include("common.hrl").
-include("system_config.hrl").

-export([
  add/1,
  update/1,
  replace/1,

  list/0
]).


%% 系统配置添加到数据库中
%% System_config:系统配置record #system_config
%% 返回值: true:成功 | {false:失败,Reason}
add(System_config) ->
  ValueList = lists:nthtail(1, tuple_to_list(System_config)),
  FieldList = record_info(fields, system_config),
  case ?DB_GAME:replace(system_config, FieldList, ValueList) of
    {replace, _, _} ->
      true;
    {error, Reason} ->
      {false, Reason}
  end.


%% 系统配置数据修改
%% System_config:系统配置record #system_config
%% 返回值: true:成功 | {false:失败, Reason}
update(System_config) ->
  ValueList = lists:nthtail(2, tuple_to_list(System_config)),
  [_Id | FieldList] = record_info(fields, system_config),
  case ?DB_GAME:update(system_config, FieldList, ValueList, [{"id", System_config#system_config.id}]) of
    {update, _} ->
      true;
    {error, Reason} ->
      {false, Reason}
  end.

%% 系统配置数据修改
%% System_config:系统配置record #system_config
%% 返回值: true:成功 | {false:失败, Reason}
replace(System_config) ->
  ValueList = lists:nthtail(1, tuple_to_list(System_config)),
  FieldList = record_info(fields, system_config),
  {replace, _, _} = ?DB_GAME:replace(system_config, FieldList, ValueList),
  true.

%% 读取数据库所有系统配置数据
%% 返回结果 {record_list, [Record]}数据记录 值 | {record_list, []} | {error,Reason}
list() ->
  ?DB_GAME:select_record_list(system_config, system_config, "id, value", []).












