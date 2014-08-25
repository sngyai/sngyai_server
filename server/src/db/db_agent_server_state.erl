%%%==============================================================================
%%% Author      :fangjie008@163.com
%%% Created     :2012-11
%%% Description :des
%%%==============================================================================
-module(db_agent_server_state).
-include("common.hrl").
-include("server_state.hrl").

-export([
  get/0,
  save/1
]).


%% 获得当前服务器数据
%% 返回值:{ok, [#server_state]} | Error
get() ->
  case ?DB_GAME:select_record_list_with(server_state, fun data2record/2, server_state, "*", []) of
    {record_list, Server_State_List} -> {ok, Server_State_List};
    Error -> Error
  end.


%% 将数据保存数据库
%% Server_State_List:[#server_state]
%% 返回值:ok
save([]) ->
  ok;
save(Server_State_List) ->
  ValueList = [lists:nthtail(1, record2data(Server_State)) || Server_State <- Server_State_List],
  FieldList = record_info(fields, server_state),
  {replace, _Affected_rows, _Insert_id} = ?DB_GAME:replace_muti(server_state, FieldList, ValueList).


%%%-------------------------------------------------------------------
%% Local Functions
%%%-------------------------------------------------------------------

%% fun((X, Y) -> T)
%% value_complex数据从数据表转化为record的时候需要做的处理
%% Key:列名, value:值
%% 返回值:Value
data2record(value_complex, Value) ->
  %?T("get_info_by_id data2record recent_contacts ~p, final:~p", [Value, lib_util_type:string_to_term(Value)]),
  {value_complex, lib_util_type:string_to_term(Value)};
data2record(Key, Value) ->
  {Key, Value}.

%% 数据保存record转化为data数据
%% Server_State:#server_state
%% 返回值: tuple_to_list 转化的数据
record2data(Server_State) ->
  tuple_to_list(Server_State#server_state{
    value_complex = lib_util_type:term_to_string(Server_State#server_state.value_complex)
  }).


