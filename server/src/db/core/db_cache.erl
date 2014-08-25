%%%--------------------------------------
%%% @Module  : db_cache
%%% @Author  : tj
%%% @Created : 2012.6.16
%%% @Description: 内存数据操作
%%%  考虑到跨服交互这样的需求，为了不依赖数据库操作达到一个统一的数据操作借口，抽象出一个内存数据操作层
%%%  如果切到这个模块，那么一般数据增删改是不会影响到数据库的数据
%%%  关于查询的话，通过ETS内存查询，数据格式尽量与数据库表结构保持一致，这样不需要在应用层变动
%%%--------------------------------------
-module(db_cache).
-include("common.hrl").
%% -include("record.hrl").
-compile([export_all]).

%%--------------------------------------------------
%% %% 插入数据表
%% 参数
%% Server 服务进程名(不传则使用缺省)
%% Table_name 表名
%% FieldList [列名]
%% ValueList [值]
%% 返回结果 {ok,Ret}影响行数 | {error,Reason}
%%--------------------------------------------------
%%----例如: db_mysql:insert(mysql_dispatcher,table_name, [user_id,name,sex], [10001,'angine',1])
insert(_Server, _Table_name, _FieldList, _ValueList) ->
  {ok, 1}.
%%----例如: db_mysql:insert(table_name, [user_id,name,sex], [10001,'angine',1])
insert(_Table_name, _FieldList, _ValueList) ->
  {ok, 1}.
%%----例如: db_mysql:insert(table_name, [{user_id,10001},{name,'angine'},{sex,1}])
insert(_Table_name, _Field_Value_List) ->
  {ok, 1}.

%%--------------------------------------------------
%% 修改数据表(replace方式)
%% 参数
%% Table_name 表名
%% Field_Value_List  [{列名,值}]
%% 例如: db_mysql:replace(table_name, [{user_id,10001},{name,"tj"},{sex,1}])
%% 返回结果 {ok,Ret}影响行数 | {error,Reason}
%%--------------------------------------------------
replace(_Table_name, _Field_Value_List) ->
  {ok, 1}.

%%--------------------------------------------------
%% 修改数据表(update方式)
%% 参数
%% Table_name 表名
%% FieldList [列名]
%% ValueList [值]
%% Where_Key 条件列
%% Where_Value 条件值
%% 例如: db_mysql:update(users, [name,sex], ['tj',1], "id", 10000314)
%% 返回结果 {ok,Ret}影响行数 | {error,Reason}
%%--------------------------------------------------
update(_Table_name, _FieldList, _ValueList, _Where_Key, _Where_Value) ->
  {ok, 1}.

%%--------------------------------------------------
%% 修改数据表(update方式)
%% 参数
%% Table_name 表名
%% Field_Value_List  [{列名,值}]
%% Where_List 条件[{条件列,条件值}]
%% 例如: db_mysql:update(users, [{name,'tj'},{sex,1}], {id,10001})
%% 返回结果 {ok,Ret}影响行数 | {error,Reason}
%%--------------------------------------------------
update(_Table_name, _Field_Value_List, _Where_List) ->
  {ok, 1}.
%% Server 服务进程名(不传则使用缺省)
update(_Server, _Table_name, _Field_Value_List, _Where_List) ->
  {ok, 1}.

%%--------------------------------------------------
%% 获取一个数据字段
%% 参数
%% Table_name 表名
%% Fields_sql  []
%% Where_List 条件[{条件列,条件值}]
%% 例如: db_mysql:select_one(users, "id", [{nick_name, NickName}], [], [1])
%% 返回结果 {ok,Value}数据字段 值 | {error,Reason}
%%--------------------------------------------------
select_one(_Table_name, _Fields_sql, _Where_List) ->
  {ok, []}.

%%--------------------------------------------------
%% 获取一条数据记录
%% 参数
%% Table_name 表名
%% Fields_sql  []
%% Where_List 条件[{条件列,条件值}]
%% 例如: db_mysql:select_row(users, "user_name, site", [{id, UserID}], [], [1])
%% 例如: db_mysql:select_row(users, "*", [{user_name, UserName}], [], [1])
%% 返回结果 {ok,Row}数据记录 | {error,Reason}
%%--------------------------------------------------
select_row(_Table_name, _Fields_sql, _Where_List) ->
  {ok, []}.

select_row(_Server, _Table_name, _Fields_sql, _Where_List) ->
  {ok, []}.

%% 获取记录个数 
select_count(_Table_name, _Where_List) ->
  {ok, 0}.

%%--------------------------------------------------
%% 获取所有数据
%% 参数
%% Table_name 表名
%% Fields_sql  []
%% Where_List 条件[{条件列,条件值}]
%% Order_List 排序方式
%% Limit_num 限制条目[Val]
%% 例如: db_mysql:select_all(users, "id, user_name, nick_name, sex, level, vip_id", [{user_name, UserName}, {site, Site}])
%% 返回结果 {ok,Rows}数据记录集合  | {error,Reason}
%%--------------------------------------------------
select_all(_Table_name, _Fields_sql, _Where_List, _Order_List, _Limit_num) ->
  {ok, []}.

select_all(_Server, _Table_name, _Fields_sql, _Where_List) ->
  {ok, []}.

select_all(_Table_name, _Fields_sql, _Where_List) ->
  {ok, []}.

%%--------------------------------------------------
%% 删除数据
%% 参数
%% Table_name 表名
%% Where_List 条件[{条件列,条件值}]
%% 例如: db_mysql:delete(users_items,[{id, ItemId}]).
%% 返回结果 {ok,Ret}影响行数 | {error,Reason}
%%--------------------------------------------------
delete(_Table_name, _Where_List) ->
  {ok, 1}.

execute(_Sql) ->
  {ok, []}.

%% 事务处理
transaction(_Fun) ->
  ok.

