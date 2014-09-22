%%%--------------------------------------
%%% @Module  : db_mysql
%%% @Author  : all
%%% @Created : 2012.6.16
%%% @Description: mysql 数据库操作
%%%
%%% where 条件格式:
%%% 每一个条件形式(一共三种)：
%%%		1、{idA, "<>", 10, "or"}   	<===>   {字段名, 操作符, 值，下一个条件的连接符} 完整形式
%%%	    2、{idB, ">", 20}   			<===>   {idB, ">", 20，"and"} 省略 and
%%% 	3、{idB, 20}   				<===>   {idB, "=", 20，"and"} 省略
%%%
%%% order by 格式:
%%% Order_List:排序规则格式[{id, desc},{status},lv]
%%% 
%%% limit num 格式 限制几行就是几行,不限制填写0
%%%
%%% Field_Info:list() of {Table, Field, Length, Name}
%%%--------------------------------------
-module(db_mysql).
-include("common.hrl").
-compile(export_all).

%% -include("record.hrl").

-export([
  insert/2,
  insert/3,
  insert_muti/3,

  replace/2,
  replace/3,
  replace_muti/3,

  update/3,
  update/4,

  delete/2,

  select_one/3,
  select_one/4,
  select_count/2,

  select_row/3,

  select_row_list/3,
  select_row_list/5,

  select_record/4,
  select_record/5,
  select_record_with/5,
  select_record_with/6,

  select_record_list/4,
  select_record_list/5,
  select_record_list/6,
  select_record_list_with/5,
  select_record_list_with/6,
  select_record_list_with/7,

  transaction/1,
  transaction/2,

  fetch/1,
  fetch/2,

  execute/1,
  execute/2,
  execute/3,

  prepare/2,
  unprepare/1
]).


%%--------------------------------------------------
%% 插入数据表,
%% 参数
%% Table_name 表名
%% 返回值:参照db_mysqlutil:handle_result/2返回值:
%% {insert, Affected_rows, Insert_id}:更新(插入,删除,修改) | {error, Reason}:出错
%%--------------------------------------------------
%% 插入单条
%% Field_Value_List:[{Key, Value}]
%% ----例如: MODULE:insert(table_name, [{user_id,10001},{name,'angine'},{sex,1}])
insert(Table_name, Field_Value_List) ->
  {FieldList, ValueList} = lists:unzip(Field_Value_List),
  insert(Table_name, FieldList, ValueList).
%% 插入单条
%% FieldList [列名]
%% ValueList [值]
%% ----例如: MODULE:insert(table_name, [user_id,name,sex], [10001,'angine',1])
insert(Table_name, FieldList, ValueList) ->
  stat_db_access(Table_name, insert),
  Sql = db_mysqlutil:make_insert_sql(Table_name, FieldList, ValueList),
  db_mysqlutil:handle_result(insert, fetch_internal(Sql)).

%% 支持插入多条
%% %% ----例如: MODULE:insert(table_name, [user_id,name,sex], [[10001,'angine',1],[10002,'aaa',2]])
insert_muti(Table_name, FieldList, ValueList_List) ->
  stat_db_access(Table_name, insert),
  Sql = db_mysqlutil:make_insert_sql_muti(Table_name, FieldList, ValueList_List),
  db_mysqlutil:handle_result(insert, fetch_internal(Sql)).


%%--------------------------------------------------
%% 修改数据表(replace方式)
%% replace方式是删除一条数据然后插入的方式执行的,所以不是针对列的,是针对行的,作为update来使用的时候千万注意
%% 在执行REPLACE后，系统返回了所影响的行数，如果返回1，说明在表中并没有重复的记录，
%% 如果返回2，说明有一条重复记录，系统自动先调用了 DELETE删除这条记录，然后再记录用INSERT来插入这条记录。
%% 如果返回的值大于2，那说明有多个唯一索引，有多条记录被删除和插入。
%% 注意如果数据没有改变的话,那么没有执行数据库操作,影响行数返回的是1
%% 参数
%% Table_name 表名
%% 返回值:参照db_mysqlutil:handle_result/2返回值:
%% {replace, Affected_rows, Insert_id}:更新(插入,删除,修改) | {error, Reason}:出错
%%--------------------------------------------------
%% Field_Value_List  [{列名,值}]
%% FieldList:[Field]
%% ValueList:[Value]
%% 例如: db_mysql:replace(table_name, [{user_id,10001},{name,"tj"},{sex,1}])
replace(Table_name, Field_Value_List) ->
  {FieldList, ValueList} = lists:unzip(Field_Value_List),
  replace(Table_name, FieldList, ValueList).
%% 例如: db_mysql:replace(table_name, [user_id,name,sex], [10001,'angine',1])
replace(Table_name, FieldList, ValueList) ->
  stat_db_access(Table_name, replace),
  Sql = db_mysqlutil:make_replace_sql(Table_name, FieldList, ValueList),
  db_mysqlutil:handle_result(replace, fetch_internal(Sql)).
%% 支持多条
%% %% ----例如: MODULE:replace_muti(table_name, [user_id,name,sex], [[10001,'angine',1],[10002,'aaa',2]])
replace_muti(Table_name, FieldList, ValueList_List) ->
  stat_db_access(Table_name, replace),
  Sql = db_mysqlutil:make_replace_sql_muti(Table_name, FieldList, ValueList_List),
  db_mysqlutil:handle_result(replace, fetch_internal(Sql)).

%%--------------------------------------------------
%% 修改数据表(update方式)
%% 参数
%% Table_name 表名
%% 返回值:参照db_mysqlutil:handle_result/2返回值:
%% {update, Affected_rows}:更新 | {error, Reason}:出错
%% Field_Value_List  [{列名,值}]
%% FieldList [列名]
%% ValueList [值]
%% Where_List 条件[{条件列,条件值}]
%% Value的具体形式包括:普通值 | 元组形式{Value, add}:与原值+操作, {Value, sub}:与原值-操作
%%--------------------------------------------------
%% 例如: db_mysql:update(users, [{name,'tj'},{sex,1}], [{id,10001}])
update(Table_name, Field_Value_List, Where_List) when is_list(Where_List) ->
  {Field_List, ValueList} = lists:unzip(Field_Value_List),
  update(Table_name, Field_List, ValueList, Where_List).
%% 例如: db_mysql:update(users, [name,sex], ['tj',1], [{id,10001}])
update(Table_name, Field_List, ValueList, Where_List) when is_list(Where_List) ->
  stat_db_access(Table_name, update),
  Sql = db_mysqlutil:make_update_sql(Table_name, Field_List, ValueList, Where_List),
  db_mysqlutil:handle_result(update, fetch_internal(Sql)).
%%--------------------------------------------------
%% 删除数据
%% 参数
%% Table_name 表名
%% Where_List 条件[{条件列,条件值}]
%% 例如: db_mysql:delete(users_items,[{id, ItemId}]).
%% 返回值:参照db_mysqlutil:handle_result/2返回值:
%% {delete, Affected_rows}影响行数 | {error, Reason}
%%--------------------------------------------------
delete(Table_name, Where_List) ->
  stat_db_access(Table_name, delete),
  Sql = db_mysqlutil:make_delete_sql(Table_name, Where_List),
  db_mysqlutil:handle_result(delete, fetch_internal(Sql)).


%%--------------------------------------------------
%% 获取一个数据字段
%% 参数
%% Table_name:表名
%% Field_Name_Str:要查询的列名,这里一定是一列
%% Where_List:条件[{条件列,条件值}],见顶部定义
%% Order_List:排序规则格式[{Field_Name, desc},{Field_Name}]
%% 例如: db_mysql:select_one(users, "id", [{nick_name, NickName}])
%% 返回值:参照db_mysqlutil:handle_result/2返回值: {scalar, Value}数据字段 值  | {scalar, []} | {error, Reason}
%% 注意：使用该接口确保得到的结果只有空或者一个值，如果多条请用 select_row() 或者 select_all()
%%--------------------------------------------------
select_one(Table_name, Field_Name_Str, Where_List) ->
  select_one(Table_name, Field_Name_Str, Where_List, []).
select_one(Table_name, Field_Name_Str, Where_List, Order_List) ->
  stat_db_access(Table_name, select),
  Sql = db_mysqlutil:make_select_sql(Table_name, Field_Name_Str, Where_List, Order_List, 1),
  db_mysqlutil:handle_result(scalar, fetch_internal(Sql)).

%%--------------------------------------------------
%% 获取记录个数
%% Table_name :表名
%% Where_List :条件见顶部定义
%% 返回值:参照db_mysqlutil:handle_result/2返回值: {scalar, Num}数据记录 | {scalar, 0} | {error,Reason}
%%--------------------------------------------------
select_count(Table_name, Where_List) ->
  select_one(Table_name, "count(1)", Where_List).


%%--------------------------------------------------
%% 获取一条数据记录
%% 参数
%% Table_name 表名
%% Fields_Str:  列名字符串例如"id,name"
%% Where_List: 条件[{条件列,条件值}]
%% Order_List: 排序规则
%% 例如: db_mysql:select_row(users, "user_name, site", [{id, UserID}])
%% 例如: db_mysql:select_row(users, "*", [{user_name, UserName}])
%% 返回值:参照db_mysqlutil:handle_result/2返回值: {row, Fields, Row}数据记录 值 | {row, Fields, []} | {error, Reason}
%% 注意：使用该接口确保得到的结果只有一条，如果多条请用 select_all()
%%--------------------------------------------------
select_row(Table_name, Fields_Str, Where_List) ->
  select_row(Table_name, Fields_Str, Where_List, []).
select_row(Table_name, Fields_Str, Where_List, Order_List) ->
  stat_db_access(Table_name, select),
  Sql = db_mysqlutil:make_select_sql(Table_name, Fields_Str, Where_List, Order_List, 1),
  db_mysqlutil:handle_result(row, fetch_internal(Sql)).

%%--------------------------------------------------
%% 获取所有数据
%% 参数
%% Table_name 表名
%% Fields_Str:  列名字符串例如"id,name"
%% Where_List: 条件[{条件列,条件值}]
%% Order_List:排序条件,见顶部定义
%% Limit_num 限制条目[Val]
%% 例如: db_mysql:select_all(users, "id, user_name, nick_name, sex, level, vip_id", [{user_name, UserName}, {site, Site}])
%% 返回值:参照db_mysqlutil:handle_result/2返回值: {row_list, Fields, Row_List}数据记录集合  | {row_list, Fields, []}:无数据 | {error, Reason}
%%--------------------------------------------------
select_row_list(Table_name, Fields_Str, Where_List) ->
  select_row_list(Table_name, Fields_Str, Where_List, []).
select_row_list(Table_name, Fields_Str, Where_List, Order_List) ->
  select_row_list(Table_name, Fields_Str, Where_List, Order_List, 0).
select_row_list(Table_name, Fields_Str, Where_List, Order_List, Limit_num) ->
  stat_db_access(Table_name, select),
  Sql = db_mysqlutil:make_select_sql(Table_name, Fields_Str, Where_List, Order_List, Limit_num),
  db_mysqlutil:handle_result(row_list, fetch_internal(Sql)).


%%--------------------------------------------------
%% 获取一个record
%% 参数
%% Record_Name:record名称
%% Table_name 表名
%% Fields_Str:  列名字符串例如"id,name"
%% Where_List 条件[{条件列,条件值}]
%% Order_List:排序条件,见顶部定义
%% 例如: db_mysql:select_row(users, "user_name, site", [{id, UserID}], player_status)
%% 例如: db_mysql:select_row(users, "*", [{user_name, UserName}], player_status)
%% 返回结果 {record, Record}数据记录 值 | {record, []} | {error,Reason}
%% 注意：使用该接口确保得到的结果只有一条，如果多条请用 select_all()
%%--------------------------------------------------
select_record(Record_Name, Table_name, Fields_Str, Where_List) ->
  select_record(Record_Name, Table_name, Fields_Str, Where_List, []).
select_record(Record_Name, Table_name, Fields_Str, Where_List, Order_List) ->
  stat_db_access(Table_name, select),
  Sql = db_mysqlutil:make_select_sql(Table_name, Fields_Str, Where_List, Order_List, 1),
  db_mysqlutil:handle_result({record, Record_Name}, fetch_internal(Sql)).

%% Zip_With_Function: lists:zipwith方法的第一个参数,用来处理类型的转化,例如Fun = fun(A,B)-> Value = case A of name -> binary_to_list(B); _Other -> B end, {A, Value} end
select_record_with(Record_Name, Zip_With_Function, Table_name, Fields_Str, Where_List) ->
  select_record_with(Record_Name, Zip_With_Function, Table_name, Fields_Str, Where_List, []).
select_record_with(Record_Name, Zip_With_Function, Table_name, Fields_Str, Where_List, Order_List) ->
  stat_db_access(Table_name, select),
  Sql = db_mysqlutil:make_select_sql(Table_name, Fields_Str, Where_List, Order_List, 1),
  db_mysqlutil:handle_result({record, Record_Name, Zip_With_Function}, fetch_internal(Sql)).


%%--------------------------------------------------
%% 获取一个record_list
%% 参数
%% Record_Name:record名称
%% Table_name 表名
%% Fields_Str:  列名字符串例如"id,name"
%% Where_List 条件[{条件列,条件值}]
%% Order_List:排序条件,见顶部定义
%% Limit_Num:限制的行数
%% 例如: db_mysql:select_row(users, "user_name, site", [{id, UserID}], player_status)
%% 例如: db_mysql:select_row(users, "*", [{user_name, UserName}], player_status)
%% 返回结果 {record_list, [Record]}数据记录 值 | {record_list, []} | {error,Reason}
%% 注意：使用该接口确保得到的结果只有一条，如果多条请用 select_all()
%%--------------------------------------------------
select_record_list(Record_Name, Table_name, Fields_Str, Where_List) ->
  select_record_list(Record_Name, Table_name, Fields_Str, Where_List, []).
select_record_list(Record_Name, Table_name, Fields_Str, Where_List, Order_List) ->
  select_record_list(Record_Name, Table_name, Fields_Str, Where_List, Order_List, 0).
select_record_list(Record_Name, Table_name, Fields_Str, Where_List, Order_List, Limit_Num) ->
  stat_db_access(Table_name, select),
  Sql = db_mysqlutil:make_select_sql(Table_name, Fields_Str, Where_List, Order_List, Limit_Num),
  db_mysqlutil:handle_result({record_list, Record_Name}, fetch_internal(Sql)).

%% Zip_With_Function: lists:zipwith方法的第一个参数,用来处理类型的转化,例如Fun = fun(A,B)-> Value = case A of name -> binary_to_list(B); _Other -> B end, {A, Value} end
select_record_list_with(Record_Name, Zip_With_Function, Table_name, Fields_Str, Where_List) ->
  select_record_list_with(Record_Name, Zip_With_Function, Table_name, Fields_Str, Where_List, []).
select_record_list_with(Record_Name, Zip_With_Function, Table_name, Fields_Str, Where_List, Order_List) ->
  select_record_list_with(Record_Name, Zip_With_Function, Table_name, Fields_Str, Where_List, Order_List, 0).
select_record_list_with(Record_Name, Zip_With_Function, Table_name, Fields_Str, Where_List, Order_List, Limit_Num) ->
  stat_db_access(Table_name, select),
  Sql = db_mysqlutil:make_select_sql(Table_name, Fields_Str, Where_List, Order_List, Limit_Num),
  db_mysqlutil:handle_result({record_list, Record_Name, Zip_With_Function}, fetch_internal(Sql)).


%% --------------------------------------------------------------------------
%%统计数据表操作次数和频率
-ifdef(db_stat).
stat_db_access(Table_name, Operation) ->
  try
    Key = lists:concat([Table_name, "/", Operation]),
    [NowBeginTime, NowCount] =
      case ets:match(?ETS_STAT_DB, {Key, Table_name, Operation, '$4', '$5'}) of
        [[OldBeginTime, OldCount]] ->
          [OldBeginTime, OldCount + 1];
        _ ->
          [lib_util_time:get_timestamp(), 1]
      end,
    ets:insert(?ETS_STAT_DB, {Key, Table_name, Operation, NowBeginTime, NowCount}),
    ok
  catch
    _:_ -> no_stat
  end.
-else.
stat_db_access(_Table_name, _Operation) ->
  ok.
-endif.


%%--------------------------------------------------
%% 执行一个SQL 语句
%% 返回值:参照db_mysqlutil:handle_result()返回值:
%% {select, Field_Info, Rows}:查询 | {update, Affected_rows, Insert_id}:更新(插入,删除,修改) | {error, Reason}:出错
%%--------------------------------------------------
fetch(Sql) ->
  %?T(Sql),
  fetch(Sql, ?DB_EXECUTE_TIMEOUT).
fetch(Sql, Timeout) ->
  stat_db_access(Sql, fetch),
  fetch_internal(Sql, Timeout).

%% 内部执行,不记录sql统计
fetch_internal(Sql) ->
  fetch_internal(Sql, ?DB_EXECUTE_TIMEOUT).
fetch_internal(Sql, Timeout) ->
  %?Error(db_logger, "mysql fetch_internal sql:~p", [Sql]),
  try mysql:fetch(?MYSQL_DB_POOL_GAME, Sql, Timeout) of
    {error, Reason} -> %执行失败
      ?Error(db_logger, "sql fail sql:~p, reason:~p", [Sql, Reason]),
      {error, Reason};
    Normal_Result ->
      db_mysqlutil:handle_result(Normal_Result)
  catch
    _:Reason_catch ->
      ?Error(db_logger, "sql fail sql:~p, reason:~p", [Sql, Reason_catch]),
      {error, Reason_catch}
  end.


%% @doc 执行prepare的sql请求
%% 返回值:参照handle_result()返回值:
%% {select, Field_Info, Rows}:查询 | {update, Affected_rows, Insert_id}:更新(插入,删除,修改) | {error, Reason}:出错
execute(Name) when is_atom(Name) ->
  execute(Name, []);
execute(Name) ->
  prepare(s, lib_util_type:to_binary(Name)),
  execute(s, []).

execute(Name, Params) when is_atom(Name) ->
  execute(Name, Params, ?DB_EXECUTE_TIMEOUT);
execute(Name, Params) ->
  prepare(s, lib_util_type:to_binary(Name)),
  execute(s, Params, ?DB_EXECUTE_TIMEOUT).

execute(Name, Params, Timeout) when is_atom(Name) ->
  db_mysqlutil:handle_result(mysql:execute(?MYSQL_DB_POOL_GAME, Name, Params, Timeout));
execute(Name, Params, Timeout) ->
  prepare(s, lib_util_type:to_binary(Name)),
  execute(s, Params, Timeout).


%%--------------------------------------------------
%% @doc 执行事务
%% 参照db_mysqlutil:handle_transaction/1返回值:{atomic, Result} | {error, Reason) | {rollback, Reason}.
%%--------------------------------------------------
transaction(Fun) ->
  transaction(Fun, ?DB_EXECUTE_TIMEOUT).
%% @doc 同上
transaction(Fun, Timeout) ->
  db_mysqlutil:handle_transaction(catch mysql:transaction(?MYSQL_DB_POOL_GAME, Fun, Timeout)).


%%--------------------------------------------------
%% prepare注册与反注册
%%--------------------------------------------------
%% @doc 注册一个名为Name的语句，方便调用,
%% 注册到mysql根服务(mysql_dispatcher)上,与pool无关
prepare(Name, Query) ->
  mysql:prepare(Name, Query).
%% @doc 取消注册,特殊地段不要删
unprepare(Name) ->
  mysql:unprepare(Name).



