%%%------------------------------------------------
%%% File    : record.erl
%%% Author  :
%%% Created : 2012-06-14
%%% Description: record
%%%------------------------------------------------


-ifndef(RECORD).
-define(RECORD, true).

%%是否对外开放服务
-record(service_open,
{id = 1,
  is_open = 0
}).


-endif. % RECORD
%% 请将新增加的record记录名称 追加至里面
-define(EXPORT_RECORD_INFO, [server_node, user]).
%% 服务器节点
-record(server_node, {
  id = "",                                % server编号
  node = "",                              % node
  node_type = 0,                          % 节点类型(0--网关节点；1--游戏节点)
  ip = "",                                % ip地址
  port = 0                                % 端口号
}).

%% 玩家状态信息记录
%% player ==> player_status
-record(user, {
  id,                                     %% 玩家ID
  score_current,
  score_total,
  account
}).

-record(task_log,
{
  user_id,
  time,
  channel,
  trand_no,
  app_name,
  score
}).

