%%%--------------------------------------
%%% @Module  : db_mysqlutil
%%% @Author  : all
%%% @Created : 2012-6-16
%%% @Description: MYSQL数据库操作 , 注意此模块方法只允许在 db_mysql.erl进行调用,外部不允许直接调用
%%%
%%% where 条件格式:
%%% 每一个条件形式(一共三种)：
%%%		1、{idA, "<>", 10, "or"}   	<===>   {字段名, 操作符, 值，下一个条件的连接符} 完整形式
%%%	    2、{idB, ">", 20}   			<===>   {idB, ">", 20，"and"} 省略 and
%%% 	3、{idB, 20}   				<===>   {idB, "=", 20，"and"} 省略
%%%
%%% order by 格式:
%%% Order_List:排序规则格式[{Field_Name, desc},{Field_Name}]
%%%
%%% %% limit num 格式 限制几行就是几行,不限制填写0
%%%--------------------------------------
-module(db_mysqlutil).

-include("common.hrl").

-compile(export_all).

-export([
  make_insert_sql/3,
  make_insert_sql_muti/3,

  make_replace_sql/3,
  make_replace_sql_muti/3,

  make_update_sql/4,

  make_delete_sql/2,

  make_select_sql/5,

  handle_result/1,
  handle_result/2,

  handle_transaction/1,

  field_value_join/2,
  field_name_join/2,
  encode/1
]).


%% 处理数据库操作结果 start -------------------------------------------------------------

%% 对结果进行处理
%% 匹配不同的处理结果,查询,更新等
%% 返回值:{select, Field_Info, Rows}:查询 | {update, Affected_rows, Insert_id}:更新(插入,删除,修改) | {error, Reason}:出错
handle_result({data, MySQLRes}) ->
  {select, mysql:get_result_field_info(MySQLRes), mysql:get_result_rows(MySQLRes)};
handle_result({updated, MySQLRes}) ->
  {update, mysql:get_result_affected_rows(MySQLRes), mysql:get_result_insert_id(MySQLRes)};
handle_result({error, MySQLRes}) when is_tuple(MySQLRes) ->
  Reason = mysql:get_result_reason(MySQLRes),
  ?Error(db_logger, "mysql error:~p res:~p", [Reason, MySQLRes]),
  {error, mysql_halt(Reason)};
handle_result({'EXIT', {Reason, _}}) ->
  ?Error(db_logger, "mysql error:~w", [Reason]),
  {error, Reason}.

%% 再次提炼生成返回结果
%% 返回值:{insert, Affected_Rows, Insert_id}:插入操作
handle_result(insert, MySQLRes) ->
  case MySQLRes of
    {update, Affected_rows, Insert_id} ->
      {insert, Affected_rows, Insert_id};
    Other -> Other
  end;
%% {replace, Affected_Rows, Insert_id}:replace操作
handle_result(replace, MySQLRes) ->
  case MySQLRes of
    {update, Affected_rows, Insert_id} ->
      {replace, Affected_rows, Insert_id};
    Other -> Other
  end;
%% {update, Affected_Rows}:update操作
handle_result(update, MySQLRes) ->
  case MySQLRes of
    {update, Affected_rows, _Insert_id} ->
      {update, Affected_rows};
    Other -> Other
  end;
%% {delete, Affected_Rows}:delete操作
handle_result(delete, MySQLRes) ->
  case MySQLRes of
    {update, Affected_rows, _Insert_id} ->
      {delete, Affected_rows};
    Other -> Other
  end;
%% {scalar, Value}:select_one操作
handle_result(scalar, MySQLRes) ->
  %?T(MySQLRes),
  case MySQLRes of
    {select, _Field_Info, []} ->
      {scalar, []};
    {select, _Field_Info, [[Value]]} ->
      {scalar, Value};
    Other -> Other
  end;
%% {row, Row}:select_row操作
handle_result(row, MySQLRes) ->
  case MySQLRes of
    {select, Field_Info, []} ->
      {row, Field_Info, []};
    {select, Field_Info, [Row]} ->
      {row, Field_Info, Row};
    Other -> Other
  end;
%% {row_list, Row_list}:select_row_list操作
handle_result(row_list, MySQLRes) ->
  case MySQLRes of
    {select, Field_Info, []} ->
      {row_list, Field_Info, []};
    {select, Field_Info, Row_List} ->
      {row_list, Field_Info, Row_List};
    Other -> Other
  end;
%% {record, Record}:select_record操作
handle_result({record, Record_Name}, MySQLRes) ->
  case MySQLRes of
    {select, _Field_Info, []} ->
      {record, []};
    {select, Field_Info, [Row]} ->
      {record, lib_util_type:to_record(Record_Name, Field_Info, Row)};
    Other -> Other
  end;
handle_result({record, Record_Name, Zip_With_Function}, MySQLRes) ->
  case MySQLRes of
    {select, _Field_Info, []} ->
      {record, []};
    {select, Field_Info, [Row]} ->
      {record, lib_util_type:to_record(Record_Name, Field_Info, Row, Zip_With_Function)};
    Other -> Other
  end;
%% {record_list, Record_List}:select_record_list操作
handle_result({record_list, Record_Name}, MySQLRes) ->
  case MySQLRes of
    {select, _Field_Info, []} ->
      {record_list, []};
    {select, Field_Info, Row_List} ->
      {record_list, lib_util_type:to_record_list(Record_Name, Field_Info, Row_List)};
    Other -> Other
  end;
%% {record_list, Record_List}:select_record_list操作
handle_result({record_list, Record_Name, Zip_With_Function}, MySQLRes) ->
  case MySQLRes of
    {select, _Field_Info, []} ->
      {record_list, []};
    {select, Field_Info, Row_List} ->
      {record_list, lib_util_type:to_record_list(Record_Name, Field_Info, Row_List, Zip_With_Function)};
    Other -> Other
  end.


%% 对事务结果进行处理
%% 返回值:{atomic, Result}:成功 | {rollback, Err}:失败 | {error, Reason}:错误
handle_transaction(Result) ->
  case Result of
    {atomic, Res} ->
      {atomic, Res};
    {aborted, {Err, {rollback_result, Res}}} ->
      ?T("transaction roolback reason:~p result:~p", [Err, Res]),
      ?Error(db_logger, "transaction roolback reason:~p result:~p", [Err, Res]),
      {rollback, Err};
    {error, Reason} ->
      ?T("transaction error:~p", [Reason]),
      ?Error(db_logger, "transaction error:~p", [Reason]),
      {error, Reason};
    {'EXIT', Reason} ->
      ?T("transaction exit:~p", [Reason]),
      ?Error(db_logger, "transaction error:~p", [Reason]),
      {error, Reason}
  end.


%% @doc 显示人可以看得懂的错误信息
mysql_halt(Reason) ->
  catch erlang:error({db_error, [Reason]}).

%% 处理数据库操作结果 end-------------------------------------------------------------


%% make sql 语句 start==================================================================================================================================

%% 组合insert语句 start-----------------------------------------------------------------------
%% 组合mysql insert语句
%% 使用sql格式:insert into `test`(`id`, `user_name`) VALUES(12311, '1'), (13411,'Mary');
%% Table_name:表名

%% FieldList：[字段名]
%% ValueList:[数值]
%% 例如:db_mysqlutil:make_insert_sql(test,["row","r"],["测试",123]) 相当 insert into `test`(`row`,`r`) values('测试','123')
make_insert_sql(Table_name, FieldList, ValueList) when is_list(FieldList), is_list(ValueList) ->
  Fields = field_name_join(FieldList, ","),
  Values = field_value_join(ValueList, ","),
  ["insert into `", lib_util_type:to_list(Table_name), "`(", Fields, ") values(", Values, ");"].

%% 组合多条插入sql语句
%% ValueList_List:[[数值]]
make_insert_sql_muti(Table_name, FieldList, ValueList_List) when is_list(FieldList), is_list(ValueList_List) ->
  Fields = field_name_join(FieldList, ","),
  ValsStrList = ["(" ++ field_value_join(ValueList, ",") ++ ")" || ValueList <- ValueList_List],
  ["insert into `", lib_util_type:to_list(Table_name), "`(", Fields, ") values", string:join(ValsStrList, ","), ";"].

%% 组合insert语句 end-----------------------------------------------------------------------

%% 组合replace语句 start-------------------------------------------------------------------
%% 采用sql格式:replace into `test`(`id`, `user_name`) VALUES(12311, '1'), (13411,'Mary');

%% FieldList：[字段名]
%% ValueList:[数值]
%% 例如:db_mysqlutil:make_replace_sql(test,["row","r"],["测试",123]) 
make_replace_sql(Table_name, FieldList, ValueList) when is_list(FieldList), is_list(ValueList) ->
  Fields = field_name_join(FieldList, ","),
  Values = field_value_join(ValueList, ","),
  ["replace into `", lib_util_type:to_list(Table_name), "`(", Fields, ") values(", Values, ");"].
%% 组合多条replace sql语句
%% ValueList_List:[[数值]]
make_replace_sql_muti(Table_name, FieldList, ValueList_List) when is_list(FieldList), is_list(ValueList_List) ->
  Fields = field_name_join(FieldList, ","),
  ValsStrList = ["(" ++ field_value_join(ValueList, ",") ++ ")" || ValueList <- ValueList_List],
  ["replace into `", lib_util_type:to_list(Table_name), "`(", Fields, ") values", string:join(ValsStrList, ","), ";"].
%% 组合replace语句 end---------------------------------------------------------------


%% 组合udpate语句 start---------------------------------------------------------------
%% db_mysqlutil:make_update_sql(player,[{status, 0}, {online_flag,1}, {hp, {50, add}}, {mp, {30, sub}}],[{id, 11}]).
%% Table_name:表名称
%% Field_Value_List:列名列表
make_update_sql(Table_name, Field_List, Value_List, Where_List) ->
  UPairs = lists:zipwith(
    fun(Field_E, Value_E) ->
      Value_Str_E =
        case Value_E of
          {Val, add} -> to_name_style(Field_E) ++ "+" ++ encode(Val);
          {Val, sub} -> to_name_style(Field_E) ++ "-" ++ encode(Val);
          Normal_Value -> encode(Normal_Value) end,
      to_name_style(Field_E) ++ " = " ++ Value_Str_E end,
    Field_List, Value_List),

  {WhereSql, Where_Count} = get_where_sql(Where_List),
  WhereSql_Full =
    if Where_Count > 1 -> [" where ", WhereSql];
      true -> ""
    end,
  ["update `", lib_util_type:to_list(Table_name), "` set ", string:join(UPairs, ","), WhereSql_Full, ";"].

%% 组合udpate语句 end---------------------------------------------------------------


%% 组合delete语句 start---------------------------------------------------------------
%% db_mysqlutil:make_delete_sql(player, [{id, "=", 11, "and"},{status, 0}]).
make_delete_sql(Table_name, Where_List) ->
  {WhereSql, Where_Count} = get_where_sql(Where_List),
  WhereSql_Full =
    if Where_Count > 1 -> ["where ", WhereSql];
      true -> ""
    end,
  ["delete from `", lib_util_type:to_list(Table_name), "` ", WhereSql_Full, ";"].
%% 组合delete语句 end---------------------------------------------------------------

%% 组合select语句 start---------------------------------------------------------------
%% Table_name:表名称
%% Fields_Str:列字符串例如"id,name"
%% Where_List:
%% db_mysqlutil:make_select_sql(player, "*", [{status, 1}], [{id,desc},{status}],[]).
%% db_mysqlutil:make_select_sql(player, "id, status", [{id, 11}], [{id,desc},{status}],[]).
make_select_sql(Table_name, Fields_Str, Where_List, Order_List, Limit_num) when is_integer(Limit_num) ->
  {WhereSql, Where_Count} = get_where_sql(Where_List),
  WhereSql_Full =
    if Where_Count > 1 -> ["where ", WhereSql];
      true -> ""
    end,
  OrderSql = get_order_sql(Order_List),
  OrderSql_Full =
    if length(OrderSql) > 0 -> [" order by ", OrderSql];
      true -> ""
    end,
  LimitSql = case Limit_num of
               0 -> "";
               Num -> [" limit ", lib_util_type:to_list(Num)]
             end,
  ["select ", Fields_Str, " from `", lib_util_type:to_list(Table_name), "` ", WhereSql_Full, OrderSql_Full, LimitSql].


%% order by语句组织--更新/删除/查询通用order by格式------------------------------------
%% 排序用列表方式：[{id, desc},{status},lv]
%% Order_List:规定格式排序元组
%% 返回值:排序字符串
get_order_sql(Order_List) when is_list(Order_List) ->
  Fun_Order = fun(Field_Order_E) ->
    case Field_Order_E of
      {Field, Order} ->
        lib_util_type:to_list(Field) ++ " " ++ lib_util_type:to_list(Order);
      {Field} ->
        lib_util_type:to_list(Field);
      _ ->
        lib_util_type:to_list(Field_Order_E)
    end
  end,
  Str_List = [Fun_Order(Order_E) || Order_E <- Order_List],
  string:join(Str_List, ",").

%% where语句组织--更新/删除/查询通用where格式------------------------------------
%% 条件用列表方式：[{},{},{}]
%% 每一个条件形式(一共三种)：
%%		1、{idA, "<>", 10, "or"} <===> {字段名, 操作符, 值，下一个条件的连接符}
%% 	    2、{idB, ">", 20}   		<===> {idB, ">", 20，"and"}
%% 	    3、{idB, 20}   			<===> {idB, "=", 20，"and"}
%% 返回值:{组合后的sql字符串, Index:最大index + 1}
get_where_sql(Where_List) when is_list(Where_List) ->
  Length = length(Where_List),
  Fun = fun(Field_Operator_Val, Index) ->
    {Sql_E, Link_E} =
      case Field_Operator_Val of
        {Field, Operator, Val, Or_And} ->
          {lib_util_type:to_list(Field) ++ Operator ++ encode(Val), lib_util_type:to_list(Or_And)};
        {Field, Operator, Val} ->
          {lib_util_type:to_list(Field) ++ Operator ++ encode(Val), "and"};
        {Field, Val} ->
          {lib_util_type:to_list(Field) ++ " = " ++ encode(Val), "and"};
        _ -> ""
      end,
    Str_Current =
      case Index == Length of
        true -> Sql_E;
        false -> Sql_E ++ " " ++ Link_E ++ " "
      end,
    {Str_Current, Index + 1}
  end,

  lists:mapfoldl(Fun, 1, Where_List).


%% make sql 语句 end==================================================================================================================================

%% 生成字段名称列表
%% 第一个参数为列表数据,第二个参数为分隔符
%% 例如 field_name_join(["A", b, "c", <<"d">>], ",") -> "`A`,`b`,`c`,`d`"
field_name_join([], Sep) when is_list(Sep) ->
  [];
field_name_join([H | T], Sep) when is_list(Sep) ->
  to_name_style(H) ++ lists:append([Sep ++ to_name_style(X) || X <- T]).

%% 转化为列明格式
to_name_style(Filed) ->
  "`" ++ lib_util_type:to_list(Filed) ++ "`".

%% 生成字段值列表
%% 第一个参数为列表数据,第二个参数为分隔符
%% 例如 field_value_join(["123", 123, abc], ",") -> "'123',123,'abc'"
field_value_join([], Sep) when is_list(Sep) ->
  [];
field_value_join([H | T], Sep) ->
  encode(H) ++ lists:append([Sep ++ encode(X) || X <- T]).


%% db底层字段值的编码
%% V:要编码的参数
%% 返回值:新的编码后的参数
encode(V) ->
  case mysql:encode(V) of
    {error, Reason} -> throw(Reason);
    Result -> Result
  end.












