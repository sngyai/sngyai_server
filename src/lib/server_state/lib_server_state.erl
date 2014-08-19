%%%==============================================================================
%%% Author      :fangjie008@163.com
%%% Created     :2012-11
%%% Description :服务器状态数据,基本操作接口
%%%==============================================================================
-module(lib_server_state).
-include("common.hrl").
-include("server_state.hrl").


-export([
  get/1,
  add/1
]).

-export([
  init_internal/0,
  save_internal/1,
  get_internal/2,
  add_internal/2
]).

%%-------------------------------------------------------
%% 对外调用接口,路由路径 XX -> this -> mod_server_state
%%-------------------------------------------------------
%% 根据id查找数据
%% Id:server_state_key_XX宏定义
%% 返回值:[] | #server_state
get(Id) ->
  gen_server:call(mod_server_state, {select, Id}).


%% 将一条记录增加到服务器状态列表中,存在替换,不存在插入
%% Server_State:#server_state
%% 返回值:不使用
add(Server_State) ->
  gen_server:cast(mod_server_state, {add, Server_State}).


%%----------------------------------------------
%% mod_server_state进程中执行方法
%%----------------------------------------------

%% 初始化,读取数据库数据
%% 返回值:{ok, [#server_state]}
init_internal() ->
  {ok, Server_State_List} = db_agent_server_state:get(),
  {ok, Server_State_List}.

%% 保存数据到数据库
%% Server_State_List:[#server_state]
%% 返回值:不使用
save_internal(Server_State_List) ->
  db_agent_server_state:save(Server_State_List).

%% 根据id查找数据
%% Id:server_state_key_XX宏定义
%% 返回值:[] | #server_state
get_internal(Server_State_List, Id) ->
  %?T("get_internal list:~p, id:~p", [Server_State_List, Id]),
  case lists:keyfind(Id, #server_state.id, Server_State_List) of
    false ->
      [];
    Server_State ->
      Server_State
  end.

%% 添加,存在替换,不存在添加
%% Server_State_List:[#server_state]
%% Server_State:#server_state
%% 返回值:[#server_state]
add_internal(Server_State_List, Server_State) ->
  %?T("add_internal a:~p, b:~p", [Server_State_List, Server_State]),
  List_Delete = lists:keydelete(Server_State#server_state.id, #server_state.id, Server_State_List),
  [Server_State | List_Delete].








