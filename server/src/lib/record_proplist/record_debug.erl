-module(record_debug).

-export([
  print/2,
  field_list/1,
  record_to_proplist/1,
  record_to_json/1
]).

-include("common.hrl").
-include("record_info.hrl").
-include("record.hrl").

%此处必须将反射的record导出
-export_record_info(?EXPORT_RECORD_INFO).

%% 打印输出记录信息  键值对方式 print("---------player_status:~p~n",Player_Status)
print(Format, Record) ->
  Proplist = record_info:record_to_proplist(Record, ?MODULE),
  ?T("--------print record_info :~n " ++ Format, [Proplist]),
  ok.

%% 返回记录的所有字段列表
%% 返回 Fields
field_list(Record_Name) ->
  Fields = record_info:field_list(Record_Name, ?MODULE),
  Fields.

%% 将记录转换为proplists形式输出[{key,value}|...]
%% Proplist  @type proplists[{key,value}|...]
record_to_proplist(Record) ->
  Proplist = record_info:record_to_proplist(Record, ?MODULE),
  Proplist.

%% 将记录转换为Json格式内容输出
%% Json:{key:value}
%% 返回 Result_Json Json内容
record_to_json(Record) ->
  Proplist = record_debug:record_to_proplist(Record),
  Result_Json = rfc4627:encode(Proplist),
  Result_Json.


% ----------------------------------------------------------------------------
% End of File.
% ----------------------------------------------------------------------------
