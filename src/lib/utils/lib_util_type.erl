%%%==============================================================================
%%% Author      :fangjie008@163.com
%%% Created     :2012-6
%%% Description :类型相关处理
%%%==============================================================================
-module(lib_util_type).

-include("common.hrl").
-include("record.hrl").
-include("system_config.hrl").
-include("server_state.hrl").



-export([
  to_integer/1,
  to_atom/1,
  to_list/1,
  to_binary/1,
  to_bool/1,
  to_tuple/1,

  term_to_string/1,
  string_to_term/1,

  atomlist_to_dbfield/1,

  to_record/3,
  to_record/4,

  to_record_list/3,
  to_record_list/4
]).


%% --------------------------------------------------类型转换相关-----------------------------------------------------
%% 处理字转化为int类型
%% Item:需要转化的item
%% 目前支持的转化类型 integer/list
%% 返回值:Integer:转化后的整形数据,false:转化失败

%% @doc convert other type to integer
%% 目前支持的类型 integer,binary,list,float
to_integer(Msg) when is_integer(Msg) ->
  Msg;
to_integer(Msg) when is_binary(Msg) ->
  Msg2 = binary_to_list(Msg),
  list_to_integer(Msg2);
to_integer(Msg) when is_list(Msg) ->
  list_to_integer(Msg);
to_integer(Msg) when is_float(Msg) ->
  round(Msg);
to_integer(Msg) ->
  throw(lists:concat([to_integer_other_value_, io_lib:format("~p", [Msg])])).


%% 将原子/list二进制/list转化为atom 返回值原子,其他类型throw
%% @doc convert other type to atom
%% 目前支持  atom,binary,list
to_atom(Msg) when is_atom(Msg) ->
  Msg;
to_atom(Msg) when is_binary(Msg) ->
  list_to_atom(binary_to_list(Msg));
to_atom(Msg) when is_list(Msg) ->
  list_to_atom(Msg);
to_atom(Msg) ->
  throw(lists:concat([to_atom_other_value_, io_lib:format("~p", [Msg])])).

%% @doc convert other type to list
%% 转化为lists,目前支持 list,atom,binary,integer,is_float,tuple,
%% Item:需要转化的对象
%% 返回值:转化后的list 否则throw
to_list(Msg) when is_list(Msg) ->
  Msg;
to_list(Msg) when is_atom(Msg) ->
  atom_to_list(Msg);
to_list(Msg) when is_binary(Msg) ->
  binary_to_list(Msg);
to_list(Msg) when is_integer(Msg) ->
  integer_to_list(Msg);
to_list(Msg) when is_float(Msg) ->
  float_to_list(Msg);
to_list(Msg) when is_tuple(Msg) ->
  tuple_to_list(Msg);
to_list(Msg) ->
  throw(lists:concat([to_list_other_value_, io_lib:format("~p", [Msg])])).

%% @doc convert other type to binary
%% 目前支持 binary, atom, list, integer,float,tuple
to_binary(Msg) when is_binary(Msg) ->
  Msg;
to_binary(Msg) when is_atom(Msg) ->
  list_to_binary(atom_to_list(Msg));
%%atom_to_binary(Msg, utf8);
to_binary(Msg) when is_list(Msg) ->
  list_to_binary(Msg);
to_binary(Msg) when is_integer(Msg) ->
  list_to_binary(integer_to_list(Msg));
to_binary(Msg) when is_float(Msg) ->
  list_to_binary(float_to_list(Msg));
to_binary(Msg) when is_tuple(Msg) ->
  list_to_binary(tuple_to_list(Msg));
to_binary(Msg) ->
  throw(lists:concat([to_binary_other_value_, io_lib:format("~p", [Msg])])).

%% @doc convert other type to bool
%% 目前支持 integer:0为false,其他为true | boolean | 列表不为空即为true
to_bool(D) when is_integer(D) ->
  D =/= 0;
to_bool(D) when is_list(D) ->
  length(D) =/= 0;
to_bool(D) when is_binary(D) ->
  to_bool(binary_to_list(D));
to_bool(D) when is_boolean(D) ->
  D;
to_bool(D) ->
  throw(lists:concat([to_bool_other_value_, io_lib:format("~p", [D])])).

%% @doc convert other type to tuple
%% 目前支持的类型 tuple, list, 其他类型转化为{Item}
to_tuple(T) when is_tuple(T) -> T;
to_tuple(T) when is_list(T) ->
  list_to_tuple(T);
to_tuple(T) -> {T}.


%% 序列化字符串相关----string-term------------------------------------------------------------------------------------------
%% term序列化，term转换为string格式，e.g., [{a},1] => "[{a},1]"
term_to_string(Term) ->
  %binary_to_list(list_to_binary(io_lib:fwrite("~p", [Term]))). % ~p会产生自动换行
  binary_to_list(list_to_binary(io_lib:format("~w", [Term]))).

%% term反序列化，string转换为term，e.g., "[{a},1]"  => [{a},1]
string_to_term(String) when is_binary(String) ->
  string_to_term(to_list(String));
string_to_term(String) ->
  case erl_scan:string(String ++ ".") of
    {ok, Tokens, _} ->
      case erl_parse:parse_term(Tokens) of
        {ok, Term} -> Term;
        _Err -> undefined
      end;
    _Error ->
      undefined
  end.



atomlist_to_dbfield(AtomList) when length(AtomList) > 0 ->
  String = make_atomlist_to_dbfield("~s", length(AtomList)),
  io_lib:format(String, AtomList).


make_atomlist_to_dbfield(Data, Count) ->
  case Count > 1 of
    true ->
      NewData = lists:concat([Data, ",~s"]),
      make_atomlist_to_dbfield(NewData, Count - 1);
    false ->
      Data
  end.


%% 数据库数据转化为record,根据数据字段和数据以及record名称转化为record数据
%% Record_Name:记录名称
%% Value_List:要转化的数据
%% DB_Fields:数据表列信息,[{<<"player">>,<<"id">>,20,'LONGLONG'}, {<<"player">>,<<"acc_id">>,11,'LONG'}]
%% 返回值:指定的赋值后的record
to_record(_Record_Name, _DB_Fields, []) ->
  [];
to_record(Record_Name, DB_Fields, Value_List) ->
  Column_Name_List = [lib_util_type:to_atom(Column) || {_Table, Column, _Long, _Type} <- DB_Fields],
  Keyvalpairs = lists:zip(Column_Name_List, Value_List),
  list_to_tuple([Record_Name | [get_value_convert_default(X, Keyvalpairs) || X <- get_record_filed_list(Record_Name)]]).
%% Zip_With_Function: lists:zipwith方法的第一个参数,用来处理类型的转化,例如Fun = fun(A,B)-> Value = case A of name -> binary_to_list(B); _Other -> B end, {A, Value} end
to_record(_Record_Name, _DB_Fields, [], _Zip_With_Function) ->
  [];
to_record(Record_Name, DB_Fields, Value_List, Zip_With_Function) ->
  Column_Name_List = [lib_util_type:to_atom(Column) || {_Table, Column, _Long, _Type} <- DB_Fields],
  Keyvalpairs = lists:zipwith(Zip_With_Function, Column_Name_List, Value_List),
  %?T("to_record Record_Name:~p, DB_Fields:~p, Value_List:~p, Column_Name_List:~p, Keyvalpairs:~p", [Record_Name, DB_Fields, Value_List, Column_Name_List, Keyvalpairs]),
  list_to_tuple([Record_Name | [get_value_convert_default(X, Keyvalpairs) || X <- get_record_filed_list(Record_Name)]]).


%% 数据库数据转化为record list,根据数据字段和数据
%% Record_Name:记录名称
%% Value_List:要转化的数据的列表
%% DB_Fields:数据表列信息,[{<<"player">>,<<"id">>,20,'LONGLONG'}, {<<"player">>,<<"acc_id">>,11,'LONG'}]
%% 返回值:指定的赋值后的record列表数据
to_record_list(_Record_Name, _DB_Fields, []) ->
  [];
to_record_list(Record_Name, DB_Fields, Value_List_List) ->
  [to_record(Record_Name, DB_Fields, Value_List) || Value_List <- Value_List_List].
%% Zip_With_Function: lists:zipwith方法的第一个参数,用来处理类型的转化,例如Fun = fun(A,B)-> Value = case A of name -> binary_to_list(B); _Other -> B end, {A, Value} end
to_record_list(_Record_Name, _DB_Fields, [], _Zip_With_Function) ->
  [];
to_record_list(Record_Name, DB_Fields, Value_List_List, Zip_With_Function) ->
  [to_record(Record_Name, DB_Fields, Value_List, Zip_With_Function) || Value_List <- Value_List_List].


%% 取得key value对应key的数据,对其进行默认的转化,目前不转化二进制,尽量使用二进制在程序中流通
%% Key:key
%% Keyvalpairs:键值对对应列表
%% 返回值:实际的值
get_value_convert_default(Key, Keyvalpairs) ->
  Value = proplists:get_value(Key, Keyvalpairs),
  Value.
%    case is_binary(Value) of
%        true ->
%            binary_to_list(Value);
%        false ->
%            Value
%    end.


%% 根据record名称获取record对应的列名标识列表
%% Record_Name:record名称
%% 返回值:record列名列表
get_record_filed_list(Record_Name) ->
  case Record_Name of
    player_status ->
      record_info(fields, player_status);
    Other_Record ->
      ?T("get_record_filed_list record no define in lib_util_type.erl do it record_name is:~p", [Other_Record]),
      ?Error(default_logger, "no record ~p", [Other_Record]),
      throw("record name error")
  end.









