%%%-------------------------------------------------------------------
%% Author: Angine
%% Created: 2012-6-17
%% Description: 玩家业务逻辑持久化模块
%%%-------------------------------------------------------------------
-module(db_agent_player).

-include("common.hrl").
-include("record.hrl").


%%%-------------------------------------------------------------------
%% Exported Functions
%%%-------------------------------------------------------------------
%% -export([
%%   create_role/1,
%%   save_player_table/1,
%%   update_player_table/3,
%%   get_player_id_by_nick_name/1,
%%
%%   get_info_by_id/1,
%%
%%   get_acc_id_and_player_account_by_playerid/1,
%%
%%
%%   daily_clear/0,
%%
%%   present_gold/2,
%%   get_players_by_lv/1,
%%   update_guild_id/3,
%%   add_coin/2,
%%   add_guild_contribute/2,
%%   add_xiuwei/2,
%%   update_peon_time/2,
%%   tencent_activity_present_gold/2
%% ]).
%%
%% -export([set_welfare/3, set_welfare_activated/2, get_welfare_player_list/0]).
%%
%%
%% -export([get_role_list_by_account_for_test/1, get_role_list_by_nickname_for_test/1]).
%%
%% -export([get_activity_last_do_timestamp/1, update_activity_last_do_timestamp/2]).
%% %%%-------------------------------------------------------------------
%% %% API Functions
%% %%%-------------------------------------------------------------------
%%
%% %%--------------------------------------------------------------------
%% %% 创建角色
%% %% 参数
%% %%      Player type #player_status{} 玩家状态信息记录
%% %% 返回结果 ok
%% %%--------------------------------------------------------------------
%% create_role(Player) ->
%%   ValueList = lists:nthtail(1, record2data(Player)),
%%   FieldList = record_info(fields, player_status),
%%   {insert, _, _} = ?DB_GAME:insert(player_status, FieldList, ValueList),
%%   ok.
%%
%% %%--------------------------------------------------------------------
%% %% 保存玩家基本信息
%% %% 参数
%% %%      Player type #player_status{} 玩家状态信息记录
%% %% 返回结果 ok
%% %%--------------------------------------------------------------------
%% save_player_table(Player) ->
%%   %?T("save_player_table1"),
%%   ValueList = lists:nthtail(2, record2data(Player)),
%%   [_Id | FieldList] = record_info(fields, player_status),
%%   try ?DB_GAME:update(player, FieldList, ValueList, [{"id", Player#player_status.id}]) of
%%     {update, _} ->
%%       %?T("save_player_table2"),
%%       ok;
%%     _Fail -> %如果数据库保存失败将玩家数据保存到dets中
%%       %?T("save_player_table3"),
%%       ?Error(player_logger, "save_player_table error reason:~p", [_Fail]),
%%       lib_storage_file_player:insert(Player)
%%   catch
%%     _:Reason ->
%%       %?T("save_player_table4"),
%%       ?Error(player_logger, "save_player_table catch reason:~p", [Reason]),
%%       lib_storage_file_player:insert(Player)
%%   end,
%%   %?T("save_player_table5"),
%%   ok.
%%
%% %%--------------------------------------------------------------------
%% %% 更新玩家字段信息
%% %% 参数
%% %%      PlayerId bigint 玩家ID
%% %%      FieldList [表字段]
%% %%      ValueList [值]
%% %% 返回结果 ok | 异常
%% %% 例: db_agent_player:update(10010000000221,[user_name,sex], ['tj',1]).
%% %%--------------------------------------------------------------------
%% update_player_table(PlayerId, FieldList, ValueList) ->
%%   {update, _} = ?DB_GAME:update(player, FieldList, ValueList, [{"id", PlayerId}]),
%%   ok.
%%
%% %%--------------------------------------------------------------------
%% %% 根据角色名称查找ID
%% %% 参数
%% %%      NickName string 玩家昵称
%% %% 返回结果 {ok, ID}ID值 | {ok, []} | {error, Reason}
%% %% 例: db_agent_player:get_player_id_by_nick_name("剪裁人生").
%% %%--------------------------------------------------------------------
%% get_player_id_by_nick_name(NickName) ->
%%   case ?DB_GAME:select_one(player, "id", [{nick_name, NickName}]) of
%%     {scalar, []} -> {ok, []};
%%     {scalar, Player_Id} -> {ok, Player_Id};
%%     Error -> Error
%%   end.
%%
%%
%% %%--------------------------------------------------------------------
%% %% 根据玩家ID获取玩家数据信息
%% %% 参数
%% %%      PlayerId bigint 玩家ID
%% %% 返回结果 {ok,Player_Status}:数据记录 | {ok,[]}:无数据 | {error,Reason}:出错
%% %% 例: db_agent_player:get_info_by_id(10010000002001).
%% %%--------------------------------------------------------------------
%% get_info_by_id(PlayerId) ->
%%   case ?DB_GAME:select_record(player_status, player, "*", [{id, PlayerId}]) of
%%     {record, []} -> {ok, []};
%%     {record, Player_Status} -> %?T("get_info_by_id recent_contacts ~p", [Player_Status#player_status.recent_contacts]),
%%       {ok, Player_Status};
%%     Error -> Error
%%   end.
%%
%%
%% %%--------------------------------------------------------------------
%% %% 根据玩家id获取玩家所属平台编号和玩家平台账号
%% %% Player_id:角色id
%% %% 返回结果 {ok, [Acc_Id, Player_Account]}数据记录 | {ok, []} | {error,Reason}
%% %%--------------------------------------------------------------------
%% get_acc_id_and_player_account_by_playerid(Player_id) ->
%%   case ?DB_GAME:select_row(player, "acc_id, player_account", [{id, Player_id}]) of
%%     {row, _Fields, Row} ->
%%       {ok, Row};
%%     Error -> Error
%%   end.
%%
%%
%% %%--------------------------------------------------------------------
%% %% 取得指定平台-帐号名称的角色列表
%% %% 参数
%% %%      Acc_Id:平台编号
%% %%      PlayerAccount:玩家平台账号
%% %%      ServerId:服编号
%% %% 返回结果 {ok, []} | {ok, Player_List} | {error, Reason}
%% %% 例: db_agent_player:get_role_list("tj@gmail.com").
%% %%--------------------------------------------------------------------
%% get_role_list_by_accid_account(Acc_Id, PlayerAccount) ->
%%   case ?DB_GAME:select_record_list(player_status, player, "id, nick_name, apc_id, lv", [{acc_id, Acc_Id}, {player_account, PlayerAccount}]) of
%%     {record_list, Player_List} -> {ok, Player_List};
%%     Error -> Error
%%   end.
%% get_role_list_by_accid_account_serverid(Acc_Id, ServerId, PlayerAccount) ->
%%   case ?DB_GAME:select_record_list(player_status, player, "id, nick_name, apc_id, lv", [{acc_id, Acc_Id}, {server_id, ServerId}, {player_account, PlayerAccount}]) of
%%     {record_list, Player_List} -> {ok, Player_List};
%%     Error -> Error
%%   end.
%%
%% %%--------------------------------------------------------------------
%% %% 取得指定平台,帐号角色数量信息
%% %% 参数
%% %%      Acc_Id:平台编号, Player_Account:玩家平台账号, Server_Id:服编号
%% %% 返回结果 {ok, Count}数据记录集合 | {error,Reason}
%% %%--------------------------------------------------------------------
%% get_role_count_by_accid_account(Acc_Id, Player_Account) ->
%%   case ?DB_GAME:select_count(player, [{acc_id, Acc_Id}, {player_account, Player_Account}]) of
%%     {scalar, Count} -> {ok, Count};
%%     Error -> Error
%%   end.
%% %% 添加服编号条件
%% get_role_count_by_accid_account_server(Acc_Id, Server_Id, Player_Account) ->
%%   case ?DB_GAME:select_count(player, [{acc_id, Acc_Id}, {server_id, Server_Id}, {player_account, Player_Account}]) of
%%     {scalar, Count} -> {ok, Count};
%%     Error -> Error
%%   end.
%%
%% %% 获取指定等级的玩家列表
%% %% 返回结果 [] || [[id, nickname]]
%% get_players_by_lv(Lv) ->
%%   case ?DB_GAME:select_row_list(player, "id, nick_name", [{lv, Lv}], [{"rand()"}], 1) of
%%     {row_list, _Fields, List} ->
%%       List;
%%     {error, _Reason} ->
%%       []
%%   end.
%%
%% %%--------------------------------------------------------------------
%% %% 每日一清
%% %%--------------------------------------------------------------------
%% daily_clear() ->
%%   SQL = "update player set
%%         apc_talk_times = 0,
%%         unreal_help_times = 0
%%         ",
%%   {update, _, _} = ?DB_GAME:fetch(SQL).
%%
%%
%% %%--------------------------------------------------------------------
%% %% 更新离线玩家帮会id
%% %%--------------------------------------------------------------------
%% update_guild_id(PlayerId, GuildId, GuildName) ->
%%   {update, _} = ?DB_GAME:update(player, [{guild_id, GuildId}, {guild_name, GuildName}], [{id, PlayerId}]).
%%
%%
%% %%--------------------------------------------------------------------
%% %% 添加离线玩家铜币
%% %%--------------------------------------------------------------------
%% add_coin(PlayerId, Count) ->
%%   {update, _} = ?DB_GAME:update(player, [coin], [{Count, add}], [{"id", PlayerId}]),
%%   true.
%%
%% %%--------------------------------------------------------------------
%% %% 添加离线玩家帮贡
%% %%--------------------------------------------------------------------
%% add_guild_contribute(PlayerId, Count) ->
%%   {update, _} = ?DB_GAME:update(player, [guild_contribute], [{Count, add}], [{"id", PlayerId}]).
%%
%% %%--------------------------------------------------------------------
%% %% 添加离线玩家修为
%% %%--------------------------------------------------------------------
%% add_xiuwei(PlayerId, Count) ->
%%   {update, _} = ?DB_GAME:update(player, [xiuwei], [{Count, add}], [{"id", PlayerId}]),
%%   true.
%%
%%
%% %%--------------------------------------------------------------------
%% %% 玩家充值-离线玩家
%% %% 参数
%% %%      PlayerId bigint 玩家ID
%% %%      Amount:充值数量
%% %% 返回结果 true | 异常
%% %% 例: db_agent_player:update(10010000000221,[user_name,sex], ['tj',1]).
%% %%--------------------------------------------------------------------
%% recharge(PlayerId, Amount) ->
%%   {update, _} = ?DB_GAME:update(player, [gold, total_recharge], [{Amount, add}, {Amount, add}], [{"id", PlayerId}]),
%%   true.
%%
%% %%--------------------------------------------------------------------
%% %% 设置玩家消费额
%% %% 参数
%% %%      PlayerId bigint 玩家ID
%% %%      Amount:数量
%% %% 返回结果 true | 异常
%% %% 例: db_agent_player:update(10010000000221,[user_name,sex], ['tj',1]).
%% %%--------------------------------------------------------------------
%% add_total_recharge(PlayerId, Amount) ->
%%   {update, _} = ?DB_GAME:update(player, ["total_recharge"], [{Amount, add}], [{"id", PlayerId}]),
%%   true.
%%
%% %%--------------------------------------------------------------------
%% %% 赠送元宝-离线玩家
%% %% 参数
%% %%      PlayerId bigint 玩家ID
%% %%      Amount:充值数量
%% %% 返回结果 true | 异常
%% %% 例: db_agent_player:update(10010000000221,[user_name,sex], ['tj',1]).
%% %%--------------------------------------------------------------------
%% present_gold(PlayerId, Amount) ->
%%   {update, _} = ?DB_GAME:update(player, [gold], [{Amount, add}], [{"id", PlayerId}]),
%%   true.
%%
%% %% 设置玩家为福利玩家
%% %% PlayerId:玩家id, Welfare_Num:福利号, Welfare_activated:是否激活
%% set_welfare(PlayerId, Welfare_Num, Welfare_activated) ->
%%   {update, _} = ?DB_GAME:update(player, [welfare_num, welfare_activated], [Welfare_Num, Welfare_activated], [{"id", PlayerId}]),
%%   true.
%%
%% %% 修改玩家福利号是否激活状态
%% %% PlayerId:玩家id, Welfare_activated:是否激活
%% set_welfare_activated(PlayerId, Welfare_activated) ->
%%   {update, _} = ?DB_GAME:update(player, [welfare_activated], [Welfare_activated], [{"id", PlayerId}]),
%%   true.
%%
%% %% 查询所有激活状态的福利号
%% %% 返回值:{ok, [#player_status]}
%% get_welfare_player_list() ->
%%   %?T("get_welfare_player_list1"),
%%   case ?DB_GAME:select_record_list(player_status, player, "id, welfare_num", [{welfare_num, ">", 0}, {welfare_activated, 1}]) of
%%     {record_list, Player_List} -> {ok, Player_List};
%%     Error -> Error
%%   end.
%%
%%
%% %% 根据Account获取玩家信息(注意:测试用)
%% get_role_list_by_account_for_test(PlayerAccount) ->
%%   case ?DB_GAME:select_record_list(player_status, player, "*", [{player_account, PlayerAccount}]) of
%%     {record_list, Player_List} -> {ok, Player_List};
%%     Error -> Error
%%   end.
%% %% 根据Nickname获取玩家信息(注意:测试用)
%% get_role_list_by_nickname_for_test(NickName) ->
%%   case ?DB_GAME:select_record_list(player_status, player, "*", [{nick_name, NickName}]) of
%%     {record_list, Player_List} -> {ok, Player_List};
%%     Error -> Error
%%   end.
%%
%%
%% %%--------------------------------------------------------------------
%% %% 更新离线玩家做苦工次数
%% %%--------------------------------------------------------------------
%% update_peon_time(PlayerId, PeonTime) ->
%%   {update, _} = ?DB_GAME:update(player, [{peon_peon_time, PeonTime}], [{id, PlayerId}]).
%%
%% %%--------------------------------------------------------------------
%% %% 腾讯发送活动金币-离线玩家
%% %% 参数
%% %%      PlayerId bigint 玩家ID
%% %%      Amount:数量
%% %% 返回结果 true | 异常
%% %%--------------------------------------------------------------------
%% tencent_activity_present_gold(PlayerId, Amount) ->
%%   {update, _} = ?DB_GAME:update(player, [delay_gold_tencent], [{Amount, add}], [{"id", PlayerId}]),
%%   true.
%%
%%
%% %%--------------------------------------------------------------------
%% %% 玩家最后参与活动记录字段获取和更新相关
%% %%
%% %% get  参数
%% %%      PlayerId bigint 玩家ID
%% %%      Amount:数量
%% %% 返回结果 {true, string()} | false:不存在数据
%% %%--------------------------------------------------------------------
%% get_activity_last_do_timestamp(PlayerId) ->
%%   case ?DB_GAME:select_one(player, "activity_last_do_timestamp", [{"id", PlayerId}]) of
%%     {scalar, []} -> false;
%%     {scalar, Activity_last_do_timestamp} -> {true, Activity_last_do_timestamp};
%%     _Error -> false
%%   end.
%%
%%
%% %% update
%% %% 将最新数据更新回写入数据库中
%% %% Player_Id:玩家id
%% %% Activity_last_do_timestamp:字段最新值
%% %% 返回值:不使用
%% update_activity_last_do_timestamp(Player_Id, Activity_last_do_timestamp) ->
%%   ?DB_GAME:update(player, [{activity_last_do_timestamp, Activity_last_do_timestamp}], [{"id", Player_Id}]).
%%
%%
%% %%%-------------------------------------------------------------------
%% %% Local Functions
%% %%%-------------------------------------------------------------------
%%
%%
%% %% 数据保存record转化为data数据
%% %% Player_Status:#player_status
%% %% 返回值: tuple_to_list 转化的玩家数据
%% record2data(Player_Status) ->
%%   %?T("record2data map_snap: ~p, map_snap1: ~p, recent_contacts:~p, recent_contacts2:~p", [Player_Status#player_status.map_snap, lib_util_type:term_to_string(Player_Status#player_status.map_snap),
%%   %    Player_Status#player_status.recent_contacts, lib_util_type:term_to_string(Player_Status#player_status.recent_contacts)]),
%%   %?T("player ~p", [Player_Status#player_status.award]),
%%   %?T("player ~p", [lib_util_type:term_to_string(Player_Status#player_status.award)]),
%%   %?T("player draw_yellowd_gift_lv:~p, draw_yellowd_gift_normal:~p, ", [Player_Status#player_status.draw_yellowd_gift_lv, Player_Status#player_status.draw_yellowd_gift_normal]),
%%   tuple_to_list(Player_Status#player_status{}).













