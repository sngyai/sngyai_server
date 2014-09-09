%--------====== 协议宏定义文件 ============---------
%
%  本文件定义了系统中所使用协议的宏定义，用于消除协议号在系统中硬编码.
%  所有使用协议的地方都不显示使用协议号，而是通过宏定义实现.
%
%  本宏定义中提及的协议号所对应的协议规格说明请协议规格说明XML文件，例如p_10.xml
%  协议规格说明编写遵循protocol.xsd架构文件规约.
%

%--------------------------------------------------------举例-------------------------------------------------------------------
%module宏定义
-define(p_account, p_10). %角色账号相关
%c -> s

-define(p_heartbeat_request, 10001). %心跳包请求
-define(p_account_login_request, 10002). %账号登陆请求-先登录后才可进行其他请求
-define(p_account_check_role_request, 10003). %检查账号是否有角色请求--登陆后才可请求
-define(p_create_role_request, 10004). %创建角色请求-登陆成功后才能请求
-define(p_get_account_role_list_request, 10005). %获取账号的角色列表信息-登陆成功后才能请求
-define(p_check_in_by_playerid_request, 10006). %进入游戏请求-登陆成功后才能请求
-define(p_buy_strength_request, 10007). %购买体力请求,一次购买20点,购买次数跟vip等级相关
-define(p_worship_request, 10008). %祭拜财神请求
-define(p_get_system_config_request, 10009). %请求服务器配置信息(全服)
-define(p_get_player_accumulate_online_time_request, 10010). %请求玩家累积在线时间值
-define(p_buy_strength_batch_request, 10011). %批量购买体力请求,购买10次体力,购买次数跟vip等级相关
-define(p_get_daily_bulletin_request, 10012). %获取日常公告
-define(p_save_player_settings_request, 10013). %保存玩家个人设置数据
-define(p_send_data_type_test_request, 10014). %发送字段类型测试
-define(p_save_player_rookie_guide_request, 10015). %保存玩家个人新手引导相关数据
-define(p_is_nickname_occupied_request, 10016). %检查nickname是否已经存在

-define(p_get_draw_yellowd_gift_state_request, 10017). %登陆拉取黄钻礼包领取状态请求(腾讯服才需要)
-define(p_draw_yellowd_gift_main_request, 10018). %领取黄钻新手礼包请求
-define(p_draw_yellowd_gift_daily_request, 10019). %领取黄钻每日礼包请求
-define(p_draw_yellowd_gift_lv_request, 10020). %领取黄钻冲级礼包请求
-define(p_draw_yellowd_gift_normal_request, 10021). %领取黄钻普适礼包请求

-define(p_draw_first_recharge_gift_request, 10022). %领取首充礼包请求

-define(p_notify_gold_refresh_request, 10040). %通知后端刷新玩家金币数量(玩家调用腾讯放充值弹窗关闭后触发)-从腾讯方拉取
-define(p_draw_yellowd_special_apc_request, 10041). %请求领取黄钻特权apc伙伴
-define(p_can_draw_yellowd_special_apc_request, 10042). %请求玩家是否可以领取黄钻专属伙伴(是否在我们游戏开通或者续费黄钻)

-define(p_save_client_serialization_request, 10060). %保存客户端序列化数据
-define(p_check_is_entry_inhibited_request, 10061). %查询玩家是否被禁止登录

-define(p_get_open_server_activity_request, 10080). %请求开服活动相关数据
-define(p_draw_open_server_activity_award_request, 10081). %请求领取开服活动奖励

-define(p_pull_initializing_info_request, 10090). %客户端初始化完成后拉取相关初始化信息

-define(p_draw_delay_gold_tencent_request, 10100). %请求领取活动金币

-define(p_draw_login_award_request, 10120). %请求领取登陆奖励
-define(p_draw_level_award_request, 10121). %请求领取冲级奖励

-define(p_draw_offline_gift_request, 10140). %请求领取离线礼包

-define(p_draw_delay_strength_request, 10160). %请求领取体力

-define(p_draw_delay_goods_request, 10180). %请求领取待领取物品

-define(p_draw_recharge_consume_award_request, 10200). %请求领取充值或者消费奖励

%s -> c
-define(p_heartbeat_response, 10501). %服务端发送给客户端的心跳包
-define(p_account_login_response, 10502). %账号登陆消息号的返回
-define(p_account_check_role_response, 10503). %检查账号是否有角色的相应
-define(p_create_role_response, 10504). %创建角色消息号响应
-define(p_send_account_info_response, 10505). %发送账号角色信息数据
-define(p_check_in_by_playerid_response, 10506). %角色进入游戏消息号响应
-define(p_check_in_send_player_info_response, 10507). %玩家登陆成功发送玩家基础信息到客户端
-define(p_send_player_lost_connect_response, 10508). %断开客户端玩家连接原因通知
-define(p_send_server_timestamp_response, 10509). %发送服务端当前时间戳信息
-define(p_send_player_coin_response, 10510). %发送玩家最新铜币数量到客户端
-define(p_send_player_gold_response, 10511). %发送玩家最新元宝数量到客户端
-define(p_send_player_strength_response, 10512). %发送玩家最新体力值到客户端
-define(p_buy_strength_response, 10513). %玩家购买体力消息号回应
-define(p_send_player_buy_rest_strength_times_response, 10514). %发送玩家购买体力次数和剩余购买次数
-define(p_notify_player_vip_level_change_response, 10515). %玩家vip等级变化
-define(p_send_player_worship_times_response, 10516). %发送玩家祭拜财神次数和剩余次数
-define(p_worship_response, 10517). %祭拜财神失败消息号
-define(p_worship_success_response, 10518). %祭拜财神得到铜钱通知
-define(p_send_player_awaken_point_response, 10519). %发送玩家最新悟性点到客户端
-define(p_notify_player_total_recharge_change_response, 10520). %玩家总充值量变化
-define(p_send_system_config_response, 10521). %发送服务器配置信息
-define(p_send_player_accumulate_online_time_response, 10522). %发送玩家累积在线时间
-define(p_get_daily_bulletin_response, 10523). %获取日常公告
-define(p_send_data_type_test_response, 10524). %测试字段类型协议
-define(p_is_nickname_occupied_response, 10525). %检查角色名称是否存在相应

-define(p_get_draw_yellowd_gift_state_response, 10526). %返回角色黄钻礼包领取状态

-define(p_send_draw_first_recharge_gift_response, 10527). %是否已经领取首充礼包

-define(p_notify_end_awaiting_response, 10540). %通知客户端停止等待图标-目前腾讯支付使用
-define(p_send_tencent_pay_info_response, 10541). %腾讯消费通知客户端调用fusion2.dialog.buy需要的参数
-define(p_can_draw_yellowd_special_apc_response, 10542). %通知客户端是否可以领取黄钻专属伙伴(是否在我们游戏充值或者续费黄钻)
-define(p_check_is_entry_inhibited_response, 10543).   %查询玩家是否被禁止登录

-define(p_send_open_server_activity_response, 10580). %发送开服活动领取记录字段

-define(p_send_delay_gold_tencent_response, 10600). %通知客户端玩家待领取腾讯活动金币数量

-define(p_notify_tencent_relogin_response, 10620). %通知客户端弹出登录态失效

-define(p_send_draw_login_state_response, 10640). %通知客户端玩家连续登陆奖励领取状态
-define(p_send_draw_level_state_response, 10641). %通知客户端玩家待领取冲级奖励状态

-define(p_send_offline_gift_state_response, 10660). %通知客户端玩家离线礼包领取状态

-define(p_send_delay_strength_response, 10680). %通知客户端玩家可领取的体力值

-define(p_send_delay_goods_response, 10700). %通知客户端玩家可领取的物品模板id
-define(p_send_activepoint_response, 10720). %通知客户端玩家活跃点

-define(p_send_lv_difference_response, 10740). %通知客户端玩家与服务器平均等级差-用于玩家升级弹出面板

-define(p_send_total_consume_response, 10760). %通知客户端玩家消费总量变化
-define(p_send_draw_recharge_stage_response, 10761). %通知客户端玩家领取到的充值奖励阶段
-define(p_send_draw_consume_stage_response, 10762). %通知客户端玩家领取到的消费奖励阶段

%--------------------------------------------------------11段map-------------------------------------------------------------------
%c->s
-define(p_map, p_11).

-define(p_player_move_request, 11001). %玩家移动通知
-define(p_player_move_step_request, 11002). %玩家移动同步通知
-define(p_player_change_to_aim_pos_request, 11003). %指定方式切换至目标场景和坐标请求
-define(p_player_load_map_request, 11004). %加载场景动态信息请求(拉取场景动态信息),只考虑进入视野的对象,之前的都清空
-define(p_leave_explicit_map_request, 11005). %离开当前场景请求(例如离开秘境,回到之前的位置,服务端已知该如何处理,而客户端不知道应该放置到那个地方的情况使用此条),目前适用范围:秘境
-define(p_player_change_to_guild_hq_request, 11006). %进入家园请求

%s->c
-define(p_player_move_response, 11501). %玩家移动消息
-define(p_view_player_add_response, 11502). %视野内增加玩家
-define(p_view_player_del_response, 11503). %视野内移除玩家
-define(p_player_enter_map_response, 11504). %玩家进入场景(通知客户端),接到这条协议后,客户端需要改变地图资源,清空当前视野动态信息,请求加载新的动态信息
-define(p_player_change_to_aim_pos_response, 11505). %玩家场景切换请求(p_player_change_to_aim_pos_request)回应,切换失败的回应
-define(p_view_monster_add_response, 11506). %视野范围内怪物添加(更新)
-define(p_view_monster_del_response, 11507). %视野范围内怪物移除
-define(p_monster_move_response, 11508). %视野范围内怪物移动,怪物都是单步移动
-define(p_world_boss_appear_response, 11509). %世界boss从天而降,跟11506协议完全相同,只是处理动画
-define(p_player_change_to_guild_hq_response, 11510). %进入家园请求

%--------------------------------------------------------12段player-------------------------------------------------------------------
-define(p_player, p_12). %玩家
%c -> s

-define(p_array_rotation_request, 12001). %改变阵法
-define(p_array_location_upgrade_request, 12002). %阵位升级
-define(p_array_upgrade_request, 12003). %阵法升级
-define(p_get_array_location_request, 12004). %获取阵位信息
-define(p_get_array_info_request, 12005). %获取阵法信息
-define(p_get_other_player_all_info_request, 12006). %查看其他玩家详细信息
-define(p_player_relive_request, 12007). %玩家复活请求
-define(p_player_relive_time_start_request, 12008). %玩家复活CD计时开始通知
-define(p_get_xianfa_info_request, 12009). %仙法信息
-define(p_xianfa_common_practice_request, 12010). %仙法普通修炼
-define(p_xianfa_special_practice_request, 12011). %仙法秘法修炼
-define(p_spirit_tree_info_request, 12012). %元神树信息
-define(p_create_spirit_tree_request, 12013). %元神树炼神
-define(p_get_spirit_tree_request, 12014). %元神树收获元神
-define(p_buy_spirit_chip_request, 12015). %购买元神碎片
-define(p_award_remind_init_request, 12016). %奖励提醒初始化请求
-define(p_buy_apc_run_times_request, 12017). %购买神行次数
-define(p_unlock_storage_request, 12018). %开启仓库
-define(p_add_storage_cell_request, 12019). %扩展仓库
-define(p_get_apc_run_info_request, 12020). %获取神行相关信息
-define(p_get_player_award_request, 12021). %领取玩家奖励
-define(p_get_player_award_list_request, 12022). %获取玩家奖励列表
-define(p_change_mount_request, 12023). %改变坐骑
-define(p_change_mount_up_apc_request, 12024). %改变坐骑加成对象
-define(p_add_bag_cell_request, 12025). %扩展背包


%s -> c

-define(p_update_array_response, 12501). %更新玩家阵法
-define(p_array_location_upgrade_response, 12502). %阵位升级
-define(p_update_array_location_lv_response, 12503). %更新玩家阵位等级
-define(p_array_upgrade_response, 12504). %阵法升级
-define(p_update_array_lv_response, 12505). %更新玩家阵法等级
-define(p_update_xiuwei_response, 12506). %更新玩家修为
-define(p_get_array_location_response, 12507). %获取阵位信息
-define(p_get_array_info_response, 12508). %获取阵法信息
-define(p_lv_up_rank_response, 12509). %升级信息
-define(p_get_other_player_all_info_response, 12510). %查看其他玩家详细信息
-define(p_update_player_lv_response, 12511). %更新玩家等级
-define(p_update_player_exp_response, 12512). %更新玩家经验
-define(p_update_player_state_response, 12513). %更新玩家状态通知
-define(p_player_relive_msg_response, 12514). %玩家复活消息号返回
-define(p_player_relive_response, 12515). %玩家复活
-define(p_player_relive_time_start_response, 12516). %玩家复活CD计时开始返回
-define(p_update_pet_tag_response, 12517). %更新宠物战进度
-define(p_update_apc_gift_times_response, 12518). %更新伙伴送礼次数
-define(p_update_apc_treat_times_response, 12519). %更新伙伴宴请次数
-define(p_update_apc_talk_times_response, 12520). %更新伙伴谈话次数
-define(p_get_xianfa_info_response, 12521). %仙法信息
-define(p_xianfa_common_practice_response, 12522). %仙法普通修炼
-define(p_xianfa_special_practice_response, 12523). %仙法秘法修炼
-define(p_update_xianfa_lv_response, 12524). %更新玩家仙法等级
-define(p_update_xianfa_savvy_response, 12525). %更新玩家仙法悟性
-define(p_update_xianfa_common_practice_response, 12526). %更新人参果数量
-define(p_update_xianfa_special_practice_response, 12527). %更新紫晶琉璃果数量
-define(p_spirit_tree_info_response, 12528). %元神树信息
-define(p_create_spirit_tree_response, 12529). %元神树炼神
-define(p_get_spirit_tree_response, 12530). %元神树收获元神
-define(p_update_spirit_chip_response, 12531). %更新元神碎片数量
-define(p_buy_spirit_chip_response, 12532). %购买元神碎片
-define(p_update_guild_id_response, 12533). %更新帮会id

-define(p_login_award_remind_response, 12540). %登录活动奖励提醒
-define(p_notify_award_state_change_response, 12541). %活动奖励状态变化提醒
-define(p_msg_notify_response, 12542). %%向客户端发送提示信息（全局消息号）
-define(p_buy_apc_run_times_response, 12543). %购买神行次数
-define(p_update_apc_run_info_response, 12544). %更新神行相关信息
-define(p_update_today_buy_spirit_chip_times_response, 12545). %更新今日已购买元神碎片次数
-define(p_update_player_battle_flag_response, 12546). %更新玩家是否战斗中标记通知
-define(p_unlock_storage_response, 12547). %开启仓库
-define(p_update_storage_info_response, 12548). %更新仓库信息
-define(p_add_storage_cell_response, 12549). %扩展仓库
-define(p_send_player_award_response, 12550). %发送玩家奖励列表
-define(p_get_player_award_response, 12551). %% 玩家领取奖励返回消息
-define(p_update_guild_contribute_response, 12552). %更新家族贡献
-define(p_change_mount_response, 12553). %改变坐骑
-define(p_update_mount_list_response, 12554). %更新已激活坐骑列表
-define(p_add_bag_cell_response, 12555). %扩展背包
-define(p_update_bag_cells_response, 12556). %更新背包格子
-define(p_update_gpm_trade_times_response, 12557). %更新萌兽市场交易次数
-define(p_feed_guild_pet_times_response, 12558). %更新喂养萌兽次数


%--------------------------------------------------------13段item-------------------------------------------------------------------
%c->s
-define(p_item, p_13).

-define(p_get_item_list_request, 13001). %获取物品列表
-define(p_item_clean_request, 13003). %整理物品
-define(p_item_drag_request, 13004). %拖动物品
-define(p_item_throw_request, 13005). %丢弃物品
-define(p_equip_equipment_request, 13006). %穿装备
-define(p_unequip_equipment_request, 13007). %脱装备
-define(p_strengthen_equipment_request, 13008). %强化装备
-define(p_compose_equipment_request, 13009). %合成装备
-define(p_upgrade_equipment_quality_request, 13010). %提升装备品质
-define(p_equipment_random_attribute_request, 13011). %洗炼
-define(p_equipment_change_random_attribute_request, 13012). %替换洗炼
-define(p_use_item_request, 13013). %使用物品
-define(p_buy_item_request, 13014). %购买物品
-define(p_sell_item_request, 13015). %出售物品
-define(p_rebuy_item_request, 13016). %回购物品
-define(p_get_unreal_item_list_request, 13017). %获取虚拟物品列表
-define(p_create_from_temp_bag_request, 13018). %拾取零时背包中的虚拟物品
-define(p_use_scroll_request, 13019). %使用卷轴
-define(p_get_item_info_from_db_request, 13020). %查看数据库物品信息
-define(p_buy_pet_egg_request, 13021). %购买宠物蛋
-define(p_get_mall_bought_info_request, 13022). %获取商城限购信息
-define(p_clean_collection_bag_request, 13023). %整理采集背包
-define(p_create_from_collection_bag_request, 13024). %拾取采集背包中的单个虚拟物品
-define(p_create_all_from_collection_bag_request, 13025). %拾取采集背包中的全部虚拟物品
-define(p_delete_from_collection_bag_request, 13026). %删除采集背包中的单个虚拟物品
-define(p_delete_all_from_collection_bag_request, 13027). %删除采集背包中的全部虚拟物品
-define(p_gem_inlay_request, 13028). %宝石镶嵌
-define(p_gem_remove_request, 13029). %宝石摘除
-define(p_gem_compose_request, 13030). %宝石合成
-define(p_gem_auto_compose_request, 13031). %一键合成
-define(p_gem_create_request, 13032). %宝石制作


%s->c
-define(p_item_list_response, 13501). %物品列表
-define(p_add_item_response, 13502). %添加物品
-define(p_update_item_response, 13503). %更新物品
-define(p_delete_item_response, 13504). %删除物品
-define(p_item_drag_response, 13506). %拖动物品
-define(p_item_throw_response, 13507). %丢弃物品
-define(p_equip_equipment_response, 13508). %穿装备
-define(p_unequip_equipment_response, 13509). %脱装备
-define(p_strengthen_equipment_response, 13510). %强化装备
-define(p_compose_equipment_response, 13511). %合成装备
-define(p_upgrade_equipment_quality_response, 13512). %提升装备品质
-define(p_equipment_random_attribute_response, 13513). %洗炼
-define(p_equipment_random_attribute_result_response, 13514). %洗炼属性返回值
-define(p_equipment_change_random_attribute_response, 13515). %替换洗炼
-define(p_use_item_response, 13516). %使用物品
-define(p_buy_item_response, 13517). %购买物品
-define(p_sell_item_response, 13518). %出售物品
-define(p_rebuy_item_response, 13519). %回购物品
-define(p_unreal_item_list_response, 13520). %虚拟物品列表
-define(p_add_unreal_item_response, 13521). %添加虚拟物品
-define(p_update_unreal_item_response, 13522). %更新虚拟物品
-define(p_delete_unreal_item_response, 13523). %删除虚拟物品
-define(p_create_from_temp_bag_response, 13524). %拾取零时背包中的虚拟物品
-define(p_use_scroll_response, 13525). %使用卷轴
-define(p_get_item_info_from_db_response, 13526). %查看数据库物品信息
-define(p_giftbag_info_response, 13527). %礼包开出信息
-define(p_buy_pet_egg_response, 13528). %购买宠物蛋
-define(p_get_mall_bought_info_response, 13529). %获取商城限购信息
-define(p_clean_collection_bag_response, 13530). %整理采集背包
-define(p_create_from_collection_bag_response, 13531). %拾取采集背包中的单个虚拟物品
-define(p_create_all_from_collection_bag_response, 13532). %拾取采集背包中的全部虚拟物品
-define(p_delete_from_collection_bag_response, 13533). %删除采集背包中的单个虚拟物品
-define(p_delete_all_from_collection_bag_response, 13534). %删除采集背包中的全部虚拟物品
-define(p_gem_inlay_response, 13535). %宝石镶嵌
-define(p_gem_remove_response, 13536). %宝石摘除
-define(p_gem_compose_response, 13537). %宝石合成
-define(p_gem_auto_compose_response, 13538). %一键合成
-define(p_gem_create_response, 13539). %宝石制作


%module宏定义
-define(p_apc, p_14). %apc
%c -> s

-define(p_get_apc_list_request, 14001). %获取apc列表
-define(p_apc_employ_request, 14002). %雇佣apc
-define(p_apc_join_team_request, 14003). %apc归队
-define(p_apc_leave_team_request, 14004). %apc离队
-define(p_apc_drag_request, 14005). %布阵
-define(p_update_apc_priority_request, 14006). %更新apc优先级
-define(p_apc_send_gift_request, 14007). %apc赠送礼物
-define(p_apc_treat_request, 14008). %apc宴请
-define(p_apc_random_item_request, 14009). %更新apc随身物品
-define(p_apc_buy_random_item_request, 14010). %购买apc随身物品
-define(p_apc_talk_request, 14011). %apc对话
-define(p_apc_random_passive_skill_request, 14012). %参悟
-define(p_apc_change_random_passive_skill_request, 14013). %替换技能
-define(p_apc_run_request, 14014). %神行
-define(p_apc_select_magic_skill_request, 14015). %选技能
-define(p_apc_select_leixlaeg_skill_request, 14016). %选奥义
-define(p_apc_add_attribute_to_main_request, 14017). %点拨主角
-define(p_apc_drug_apc_request, 14018). %吃丹药
-define(p_apc_extend_request, 14019). %传承

%s -> c

-define(p_apc_list_response, 14501). %APC列表
-define(p_add_apc_response, 14502). %添加APC
-define(p_update_apc_response, 14503). %更新APC
-define(p_apc_employ_response, 14504). %雇佣apc
-define(p_apc_join_team_response, 14505). %apc归队
-define(p_apc_leave_team_response, 14506). %apc离队
-define(p_apc_drag_response, 14507). %布阵
-define(p_apc_send_gift_response, 14508). %apc赠送礼物
-define(p_apc_treat_response, 14509). %apc宴请
-define(p_apc_buy_random_item_response, 14510). %购买apc随身物品
-define(p_apc_talk_response, 14511). %apc对话
-define(p_apc_random_passive_skill_result_response, 14512). %参悟技能返回值
-define(p_apc_random_passive_skill_response, 14513). %参悟
-define(p_apc_change_random_passive_skill_response, 14514). %替换技能
-define(p_apc_run_response, 14515). %神行
-define(p_apc_run_random_num_response, 14516). %神行4个随机数
-define(p_apc_select_magic_skill_response, 14517). %选技能
-define(p_apc_select_leixlaeg_skill_response, 14518). %选奥义
-define(p_apc_send_gift_add_exp_response, 14519). %礼物增加的经验
-define(p_apc_add_attribute_to_main_response, 14520). %点拨主角
-define(p_apc_drug_apc_response, 14521). %吃丹药
-define(p_apc_extend_response, 14522). %传承


%% ----------------------------------------------------15段task---------------------------------------------------------------------
-define(p_task, p_15). %apc

%%c->s
-define(p_finish_task_request, 15000). %%提交任务请求
-define(p_get_task_list_request, 15001). %% 获取任务列表
-define(p_accept_task_request, 15002). %% 接受任务请求
-define(p_accept_exercise_task_request, 15004). %% 重置历练任务
-define(p_active_task_request, 15005). %激活任务
-define(p_give_up_task_request, 15006). %放弃任务
-define(p_lock_task_request, 15007). %锁定任务（任务状态0->2）
-define(p_get_player_exercise_info_request, 15008). %%获取玩家历练信息 
-define(p_deal_special_task_request, 15009). %做特殊任务的请求(花费金币的任务)
-define(p_grow_up_task_quality_request, 15010). %提升任务品质
-define(p_start_sweep_task_request, 15011). %开始任务扫荡
-define(p_stop_sweep_task_request, 15012). %停止任务扫荡
-define(p_do_anim_task_request, 15013). %完成动画类任务


-define(p_get_player_story_tag_request, 15100). %%获取玩家当前所处剧情
-define(p_trigger_story_request, 15101). %%触发剧情请求

%%s->c
-define(p_send_update_task_list_response, 15501). %% 发送受影响的任务列表
-define(p_finish_task_response, 15502). %% 提交任务返回消息
-define(p_accept_task_response, 15503). %% 接受任务返回消息
-define(p_active_task_response, 15504). %激活任务返回
-define(p_accept_exercise_task_response, 15505). %重置历练任务返回
-define(p_give_up_task_response, 15506). %放弃任务返回
-define(p_send_exercise_info_response, 15507). %发送历练信息
-define(p_send_reset_times_response, 15508). %发送当天重置历练任务次数
-define(p_send_grow_up_quality_times_response, 15509). %发送提升任务品质的次数
-define(p_task_sweep_info_response, 15510). %任务扫荡（一键历练）信息
-define(p_task_sweep_stop_response, 15511). %任务扫荡（一键历练）停止通知

-define(p_send_player_story_tag_response, 15601). %% 发送玩家当前剧情
-define(p_trigger_story_response, 15602). %% 触发剧情返回


%% ----------------------------------------------------16段chat---------------------------------------------------------------------
-define(p_chat, p_16). %聊天相关协议

%c -> s
-define(p_chat_channel_request, 16001). %频道聊天请求
-define(p_chat_whisper_request, 16002). %私聊请求
-define(p_get_mail_msg_request, 16003). %登录获取离线消息请求

%s -> c
-define(p_chat_channel_response, 16501). %频道聊天回应
-define(p_chat_channel_send_msg_response, 16502). %将频道聊天内容发送至目标玩家
-define(p_chat_whisper_response, 16503). %私聊回应
-define(p_chat_whisper_send_msg_response, 16504). %将私聊内容发送至目标玩家
-define(p_chat_system_send_msg_response, 16505). %发送系统消息
-define(p_send_mail_msg_response, 16506). %发送邮件——离线消息
-define(p_send_screen_notice_response, 16507). %向屏幕指定区域发送消息
-define(p_send_view_bubble_msg_response, 16508). %玩家发消息时候在头上显示的气泡，展示给九宫格内的所有玩家

%--------------------------------------------------------17段battle,战斗相关协议-------------------------------------------------------------------
%module宏定义
-define(p_battle, p_17). %战斗相关协议
%c -> s
-define(p_batttle_pvp_request, 17001). %PVP战斗请求
-define(p_batttle_pve_request, 17002). %PVE战斗请求
-define(p_batttle_play_over_request, 17003). %客户端战斗播放结束通知
-define(p_batttle_pvp_compare_request, 17004). %PVP玩家切磋战斗请求
-define(p_save_battle_script_file_request, 17005). %复制-长久存储战斗脚本动画请求
%s -> c
-define(p_batttle_msg_response, 17501). %战斗消息号响应
-define(p_batttle_result_data_response, 17502). %战斗结果数据响应
-define(p_update_battle_cd_response, 17503). %刷新具体战斗的CD时间通知
-define(p_save_battle_script_file_response, 17505). %复制-长久存储战斗脚本动画响应
-define(p_batttle_in_cd_response, 17506). %战斗冷却中提示响应
%--------------------------------------------------------18段activity,活动相关协议-------------------------------------------------------------------

%module宏定义
-define(p_activity, p_18). %活动相关协议
%c -> s
-define(p_activity_status_request, 18001). %玩家登陆请求活动状态信息
-define(p_get_guild_battle_info_request, 18002). %获取家族战信息
-define(p_apply_guild_battle_request, 18003). %报名家族战
-define(p_enter_guild_battle_request, 18004). %进入战场
-define(p_insert_flag_request, 18005). %插旗操作
-define(p_start_battle_in_guild_battle_request, 18006). %家族战中发起战斗
-define(p_get_guild_info_request, 18007). %获取家族战中 各家族的人数和积分
-define(p_quit_guild_battle_request, 18008). %% 退出战场
-define(p_get_guild_battle_report_request, 18009). %获取战报
-define(p_clear_battle_cd_request, 18010). %消除战斗cd
-define(p_buy_relive_times_request, 18011). %购买复活次数


-define(p_get_turntable_info_request, 18020). %获取奖池信息
-define(p_betting_request, 18021). %投注
-define(p_get_monster_invasion_info_request, 18030). %获取怪物入侵活动信息

-define(p_get_player_exam_info_request, 18040). %请求玩家答题状态信息(打开答题面板)
-define(p_answer_question_request, 18041). %回答请求
-define(p_score_award_double_request, 18042). %积分奖励翻倍请求
-define(p_draw_score_award_request, 18043). %请求领取积分奖励
-define(p_retry_exam_request, 18044). %请求再试一次
-define(p_close_exam_panel_request, 18045). %关闭面板通知
-define(p_next_question_request, 18046). %请求下一道题目
-define(p_retrieve_activity_award_request, 18060). %找回奖励请求


%s -> c
-define(p_send_monster_invasion_hurt_list_response, 18501). %发送在怪物入侵活动中各玩家攻击boss排名
-define(p_send_self_hurt_response, 18502). %发送自己对boss的伤害累计值
-define(p_send_monster_invasion_end_response, 18503). %通知怪物入侵活动结束
-define(p_activity_status_response, 18504). %通知玩家活动状态信息
-define(p_send_monster_invasion_result_response, 18505). %发送怪物入侵活动结果

-define(p_send_guild_battle_apply_list_response, 18510). %发送家族战报名信息列表（报名阶段）
-define(p_send_guild_battle_info_response, 18511). %发送家族战对战信息
-define(p_apply_guild_battle_response, 18512). %报名家族战返回消息
-define(p_enter_guild_battle_response, 18513). %报名家族战返回消息
-define(p_insert_flag_response, 18514). %插旗操作返回
-define(p_send_guild_info_list_response, 18515). %发送公告栏中帮会信息
-define(p_send_guild_battle_notice_response, 18516). %发送家族战中的公告信息
-define(p_start_battle_in_guild_battle_response, 18517). %家族战中挑战返回消息
-define(p_send_insert_flag_finish_response, 18518). %发送插旗完成通知
-define(p_send_guild_battle_player_info_response, 18519). %发送家族战中玩家信息
-define(p_send_guild_battle_state_and_time_response, 18530). %发送家族战状态和下次状态改变的时间戳
-define(p_insert_flag_break_response, 18531). %% 插旗打断 
-define(p_send_guild_battle_report_response, 18532). %发送家族战战报
-define(p_clear_battle_cd_response, 18533). %消除战斗cd返回
-define(p_send_player_extend_info_response, 18534). %发送家族战中玩家的扩展信息

-define(p_send_turntable_info_response, 18520). %发送奖池信息
-define(p_betting_response, 18521). %玩家投注返回

-define(p_send_player_exam_info_response, 18540). %发送玩家当前答题状态信息
-define(p_send_exam_rank_list_response, 18541). %发送答题活动排行信息
-define(p_send_answer_result_response, 18542). %发送答题结果
-define(p_send_player_score_rank_response, 18543). %发送玩家积分排行

-define(p_send_activity_retrieve_state_response, 18560). %通知玩家当前活动找回状态


%--------------------------------------------------------19段talisman,法宝相关-------------------------------------------------------------------

%module宏定义
-define(p_talisman, p_19). %法宝相关
%c -> s

-define(p_talisman_activate_request, 19001). %激活法宝请求
-define(p_talisman_upgrade_request, 19002). %法宝升阶请求
-define(p_talisman_set_battle_request, 19003). %法宝出战设定请求
-define(p_get_player_talisman_list_request, 19004). %获取玩家法宝列表


%s -> c

-define(p_talisman_activate_response, 19501). %激活法宝返回消息
-define(p_talisman_upgrade_response, 19502). %法宝升阶返回消息
-define(p_talisman_set_battle_response, 19503). %法宝出战设定返回消息
-define(p_send_player_talisman_list_response, 19504). %发送玩家拥有的法宝列表信息
-define(p_update_talisman_info_response, 19505). %更新玩家法宝信息


%--------------------------------------------------------20段relation,玩家好友相关-------------------------------------------------------------------

%module宏定义
-define(p_relation, p_20). %玩家好友相关
%c -> s

-define(p_get_relation_list_request, 20001). %玩家登陆后，客户端发送玩家好友列表请求
-define(p_lookup_friend_by_name_request, 20002). %根据名称查找好友
-define(p_add_friend_byid_request, 20003). %添加好友请求（按ID）
-define(p_respond_to_add_friend_request, 20004). %回应添加好友请求
-define(p_update_relation_request, 20005). %修改好友关系
-define(p_delete_relation_request, 20006). %删除 好友/特别好友/黑名单
-define(p_update_partner_remark_request, 20007). %修改备注名
-define(p_update_player_sign_request, 20008). %修改玩家个性签名
-define(p_update_player_online_state_request, 20009). %修改玩家在线状态
-define(p_get_partner_info_request, 20010). %请求陌生人(在线)的详情
-define(p_add_recent_contacts_request, 20011). %添加到最近联系人
-define(p_delete_recent_contacts_request, 20012). %删除指定最近联系人（手动）
-define(p_add_to_blacklist_request, 20013). %将陌生人添加到黑名单
-define(p_get_friend_share_exp_request, 20014). %领取好友分享的升级经验


%s -> c

-define(p_get_relation_list_response, 20501). %玩家登陆后，服务器发送玩家好友列表回应
-define(p_update_lv_broadcast_response, 20502). %玩家升级，通知关系玩家
-define(p_add_friend_response, 20503). %建立关系请求回应
-define(p_forward_add_relation_request_response, 20504). %服务器转发建立关系请求至目标玩家
-define(p_forward_respond_to_add_relation_request_response, 20505). %服务器转发目标玩家的回应至发起建立关系请求的玩家
-define(p_update_relation_response, 20506). %更新好友分组
-define(p_online_notice_partner_response, 20507). %上线通知好友
-define(p_offline_notice_partner_response, 20508). %下线通知好友
-define(p_get_partner_info_response, 20509). %推送 陌生人 和新添加好友、陌生人 的基础信息
-define(p_lookup_friend_by_name_response, 20510). %根据名称查找好友
-define(p_lookup_friend_by_name2_response, 20511). %根据名称查找好友
-define(p_respond_to_add_friend_response, 20512). %回应好友添加请求返回
-define(p_update_relation2_response, 20513). %修改关系返回
-define(p_delete_relation_response, 20514). %删除指定好友
-define(p_update_partner_remark_response, 20515). %更改关系玩家备注名
-define(p_update_player_sign_response, 20516). %更改玩家个性签名
-define(p_update_player_sign_notice_relation_response, 20517). %玩家更改签名，通知关系玩家
-define(p_update_player_online_state_response, 20518). %更改玩家在线状态
-define(p_update_player_online_state_notice_relation_response, 20519). %玩家更改在线状态通知在线好友
-define(p_recent_contacts_list_response, 20520). %
-define(p_add_to_blacklist_response, 20521). %添加到黑名单回应
-define(p_upgrade_level_share_exp_response, 20522). %玩家升级向好友分享经验
-define(p_get_friend_share_exp_response, 20523). %领取好友分享的升级经验


%--------------------------------------------------------21段pet,宠物-------------------------------------------------------------------

%module宏定义
-define(p_pet, p_21). %宠物
%c -> s

-define(p_get_pet_list_request, 21001). %获取宠物列表
-define(p_pet_throw_request, 21002). %宠物放生
-define(p_pet_rename_request, 21003). %宠物起名
-define(p_pet_merge_request, 21004). %宠物融合
-define(p_pet_feed_exp_request, 21005). %宠物喂养
-define(p_change_battle_pet_request, 21006). %宠物出战


%s -> c

-define(p_pet_list_response, 21501). %宠物列表
-define(p_add_pet_response, 21502). %添加宠物
-define(p_update_pet_response, 21503). %更新宠物
-define(p_delete_pet_response, 21504). %删除宠物
-define(p_pet_throw_response, 21505). %宠物放生
-define(p_pet_rename_response, 21506). %宠物起名
-define(p_pet_merge_response, 21507). %宠物融合
-define(p_pet_feed_exp_response, 21508). %宠物喂养
-define(p_change_battle_pet_response, 21509). %宠物出战


%--------------------------------------------------------22段feature,游戏内部分特色玩法协议放到一个段-------------------------------------------------------------------

%module宏定义
-define(p_feature, p_22). %游戏内部分特色玩法协议放到一个段
%c -> s

-define(p_get_player_dungeon_request, 22001). %请求秘境信息
-define(p_reset_player_dungeon_request, 22002). %重置秘境请求
-define(p_player_dungeon_battle_request, 22003). %请求秘境挑战
-define(p_player_ambrosia_start_request, 22004). %摘仙果——开局
-define(p_player_ambrosia_move_request, 22005). %摘仙果——移动玩家头像、仙果守卫
-define(p_player_get_ambrosia_info_request, 22006). %摘仙果——查看战局
-define(p_player_ambrosia_buy_step_request, 22007). %购买步数
-define(p_player_get_liveness_info_request, 22008). %请求活跃度信息
-define(p_player_get_liveness_award_request, 22009). %请求领取活跃度奖励
-define(p_get_card_gift_request, 22010). %请求领取卡对应的礼包-新手卡等
-define(p_get_online_award_request, 22011). %请求领取在线奖励
-define(p_get_salary_request, 22012). %请求领取俸禄
-define(p_get_player_buffer_list_request, 22013). %请求玩家buffer列表信息
-define(p_world_boss_yiguzuoqi_upgrade_request, 22014). %世界boss一鼓作气buffer升级
-define(p_player_special_show_save_request, 22015). %特殊功能展示信息保存
-define(p_zazen_request, 22016). %请求进入打坐
-define(p_quit_zazen_request, 22017). %玩家退出打坐通知(有些情况服务端不知道,所以需要客户端通知,比如剧情副本的行走)
-define(p_favorite_gift_request, 22018). %通知玩家进行收藏有礼操作

-define(p_get_source_card_request, 22040). %请求玩家卡号,不论此玩家是有已经请求过都回应

-define(p_start_sweep_dungeon_request, 22060). %请求扫荡
-define(p_stop_sweep_dungeon_request, 22061). %请求停止扫荡

-define(p_get_daily_invite_state_request, 22080). %当前每日邀请好友状态请求
-define(p_notify_daily_invite_success_request, 22081). %客户端通知玩家进行了邀请好友成功操作请求
-define(p_draw_daily_invite_award_request, 22082). %领取每日邀请好友奖励请求

-define(p_start_mine_request, 22101). %开始采集请求
-define(p_stop_mine_request, 22102). %停止采集请求

-define(p_draw_unclaimed_goods_request, 22120). %领取所有物品请求

%s -> c

-define(p_send_player_dungeon_response, 22501). %玩家秘境信息发送给玩家
-define(p_reset_player_dungeon_response, 22502). %玩家重置秘境消息号返回
-define(p_player_dungeon_battle_response, 22503). %玩家请求挑战秘境消息号返回
-define(p_player_get_ambrosia_info_response, 22504). %查看战局
-define(p_player_ambrosia_move_response, 22505). %摘仙果——移动玩家头像、仙果守卫
-define(p_player_ambrosia_buy_step_response, 22506). %摘仙果——购买步数
-define(p_player_ambrosia_finish_get_award_response, 22507). %玩家完成一局获得奖励
-define(p_player_get_liveness_info_response, 22508). %推送活跃度面板信息
-define(p_player_get_liveness_award_response, 22509). %请求领取活跃度奖励
-define(p_get_card_gift_response, 22510). %请求领取卡对应的礼包响应
-define(p_get_online_award_response, 22511). %请求领取在线奖励的响应
-define(p_notify_online_award_stage_response, 22512). %通知客户端领奖阶段变化
-define(p_notify_get_salary_response, 22513). %通知客户端领取到多少俸禄
-define(p_send_player_buffer_list_response, 22514). %将玩家buffer列表信息发送到客户端
-define(p_player_special_show_save_response, 22515). %%特殊功能展示信息保存响应
-define(p_send_player_special_show_info_response, 22516). %特殊功能展示信息推送
-define(p_player_start_response, 22517). %通知玩家开始打坐
-define(p_player_quit_response, 22518). %通知玩家退出打坐状态
-define(p_player_zazen_consume_response, 22519). %通知玩家今日已经打坐时间(凌晨刷新)
-define(p_favorite_gift_response, 22520). %通知玩家收藏是否成功

-define(p_send_source_card_response, 22540). %通知玩家请求的卡号-如果玩家可以得到的话
-define(p_send_player_card_history_response, 22541). %向玩家发送玩家当前已经领取过的序列号类型

-define(p_send_sweep_dungeon_status_response, 22560). %通知玩家秘境扫荡状态-是否扫荡中
-define(p_send_sweep_dungeon_result_response, 22561). %发送秘境扫荡结果

-define(p_send_daily_invite_state_response, 22580). %通知玩家邀请好友状态

-define(p_send_mine_state_response, 22601). %通知玩家采矿状态

-define(p_send_unclaimed_goods_response, 22620). %通知玩家当前可领取的物品数据

%--------------------------------------------------------23段athletics竞技场-------------------------------------------------------------------
-define(p_athletics, p_23). %竞技场
%c -> s

-define(p_get_player_athletics_request, 23001). %获取竞技场详细请求
-define(p_buy_athletics_times_request, 23002). %购买挑战次数请求
-define(p_get_athletics_top_rank_request, 23003). %获取竞技排行榜请求
-define(p_draw_athletics_award_request, 23004). %领取奖励请求
-define(p_battle_challenge_request, 23005). %竞技挑战请求
-define(p_get_athletics_times_request, 23006).%获取竞技次数详细请求

%s -> c

-define(p_send_player_athletics_info_response, 23501). %玩家竞技信息发送给玩家
-define(p_update_player_challenge_times_response, 23502). %刷新玩家挑战次数返回
-define(p_buy_athletics_times_response, 23503). %玩家购买挑战次数消息号返回
-define(p_send_player_challenge_list_response, 23504). %发送玩家挑战列表
-define(p_draw_athletics_award_response, 23505). %玩家领取奖励返回
-define(p_send_athletics_top_rankt_response, 23506). %发送排行榜列表给玩家
-define(p_send_athletics_battle_report_list_response, 23507). %发送战报列表给玩家
-define(p_send_athletics_battle_report_response, 23508). %发送战报给玩家
-define(p_battle_challenge_response, 23509). %竞技挑战消息号返回
-define(p_get_player_athletics_response, 23510). %获取竞技场详细消息号返回


%--------------------------------------------------------24段spirit,元神-------------------------------------------------------------------

%module宏定义
-define(p_spirit, p_24). %元神
%c -> s

-define(p_get_spirit_list_request, 24001). %获取元神列表
-define(p_spirit_drag_request, 24002). %背包内拖动元神
-define(p_equip_spirit_request, 24003). %装备元神
-define(p_unequip_spirit_request, 24004). %卸下元神
-define(p_exchange_spirit_request, 24005). %兑换元神
-define(p_merge_blue_spirit_request, 24006). %合成蓝色以下元神
-define(p_merge_all_spirit_request, 24007). %合成背包闲置元神
-define(p_drag_equip_spirit_request, 24008). %装备栏内拖动元神
-define(p_auto_equip_spirit_request, 24009). %双击装备元神
-define(p_auto_unequip_spirit_request, 24010). %双击卸下元神


%s -> c

-define(p_spirit_list_response, 24501). %元神列表
-define(p_add_spirit_response, 24502). %添加元神
-define(p_update_spirit_response, 24503). %更新元神
-define(p_delete_spirit_response, 24504). %删除元神
-define(p_spirit_drag_response, 24505). %拖动元神
-define(p_equip_spirit_response, 24506). %装备元神
-define(p_unequip_spirit_response, 24507). %卸下元神
-define(p_exchange_spirit_response, 24508). %兑换元神
-define(p_merge_blue_spirit_response, 24509). %合成蓝色以下元神
-define(p_merge_all_spirit_response, 24510). %合成背包闲置元神
-define(p_drag_equip_spirit_response, 24511). %装备栏内拖动元神
-define(p_auto_equip_spirit_response, 24512). %双击装备元神
-define(p_auto_unequip_spirit_response, 24513). %双击卸下元神


%--------------------------------------------------------25段guild,帮会-------------------------------------------------------------------

%module宏定义
-define(p_guild, p_25). %帮会
%c -> s

-define(p_get_guild_list_request, 25001). %获取帮会列表(含已申请列表)
-define(p_get_my_guild_info_request, 25002). %获取本帮信息(含已成员列表)
-define(p_create_guild_request, 25003). %创建帮会
-define(p_guild_apply_request, 25004). %申请加入
-define(p_cancel_guild_apply_request, 25005). %取消申请
-define(p_accpet_guild_apply_request, 25006). %接受申请
-define(p_reject_guild_apply_request, 25007). %拒绝申请
-define(p_reject_all_guild_apply_request, 25008). %全部拒绝
-define(p_guild_set_leader_request, 25009). %让位帮主
-define(p_guild_kick_member_request, 25010). %踢出成员
-define(p_leave_guild_request, 25011). %离开帮会
-define(p_disband_guild_request, 25012). %解散帮会
-define(p_set_guild_position_request, 25013). %改变职位
-define(p_modify_guild_notice_request, 25014). %修改公告
-define(p_allot_guild_money_request, 25015). %分配资金
-define(p_guild_set_self_leader_request, 25016). %夺取帮主
-define(p_guild_modify_qq_group_request, 25017). %修改群号
-define(p_guild_apply_list_request, 25018). %本帮申请列表
-define(p_guild_sign_in_request, 25019). %签到
-define(p_get_sign_in_gift_request, 25020). %领取签到礼包
-define(p_get_guild_gift_request, 25021). %领取帮会礼包
-define(p_get_guild_sign_in_info_request, 25022). %帮会签到信息
-define(p_get_other_guild_info_request, 25023). %查看帮会信息
-define(p_guild_upgrade_boss_lv_request, 25024). %升级帮会boss
-define(p_get_guild_scene_info_request, 25025). %获取当前所在帮会场景信息
-define(p_get_other_guild_boss_lv_request, 25026). %查看其他帮会boss等级
-define(p_contribute_guild_money_request, 25027). %捐献


%s -> c

-define(p_guild_list_response, 25501). %帮会列表(含已申请列表)
-define(p_my_guild_info_response, 25502). %本帮信息(含已成员列表)
-define(p_update_guild_info_response, 25503). %更新本帮信息
-define(p_add_guild_member_response, 25504). %添加帮会成员
-define(p_update_guild_member_response, 25505). %更新帮会成员
-define(p_delete_guild_member_response, 25506). %删除帮会成员
-define(p_guild_apply_list_response, 25507). %本帮申请
-define(p_create_guild_response, 25509). %创建帮会
-define(p_guild_apply_response, 25510). %申请加入
-define(p_cancel_guild_apply_response, 25511). %取消申请
-define(p_accpet_guild_apply_response, 25512). %接受申请
-define(p_reject_guild_apply_response, 25513). %拒绝申请
-define(p_reject_all_guild_apply_response, 25514). %全部拒绝
-define(p_guild_set_leader_response, 25515). %让位帮主
-define(p_guild_kick_member_response, 25516). %踢出成员
-define(p_leave_guild_response, 25517). %离开帮会
-define(p_disband_guild_response, 25518). %解散帮会
-define(p_set_guild_position_response, 25519). %改变职位
-define(p_modify_guild_notice_response, 25520). %修改公告
-define(p_allot_guild_money_response, 25521). %分配资金
-define(p_guild_set_self_leader_response, 25522). %夺取帮主
-define(p_guild_modify_qq_group_response, 25523). %修改群号
-define(p_guild_sign_in_response, 25524). %签到
-define(p_get_sign_in_gift_response, 25525). %领取签到礼包
-define(p_get_guild_gift_response, 25526). %领取帮会礼包
-define(p_guild_sign_in_info_response, 25527). %帮会签到信息
-define(p_update_guild_gift_state_response, 25528). %更新帮会礼包状态
-define(p_update_sign_in_gift_state_response, 25529). %更新签到礼包状态
-define(p_update_last_sign_in_time_response, 25530). %更新最后签到时间
-define(p_get_other_guild_info_response, 25531). %查看帮会信息
-define(p_guild_apply_count_response, 25532). %帮会申请数量
-define(p_guild_upgrade_boss_lv_response, 25533). %升级帮会boss
-define(p_get_guild_scene_info_response, 25534). %获取当前所在帮会场景信息
-define(p_get_other_guild_boss_lv_response, 25535). %查看其他帮会boss等级
-define(p_contribute_guild_money_response, 25536). %捐献


%--------------------------------------------------------26段peon,抓捕苦工-------------------------------------------------------------------

%module宏定义
-define(p_peon, p_26). %抓捕苦工
%c -> s

-define(p_get_guild_catched_peons_request, 26001). %查看公会已抓捕苦工(即打开主面板)
-define(p_get_peon_market_info_request, 26002). %打开天地苦工市场面板
-define(p_buy_catch_peon_time_request, 26003). %购买一次抓捕次数
-define(p_catch_peon_request, 26004). %抓捕苦工
-define(p_get_peon_rank_request, 26005). %全服苦工排行
-define(p_get_foreman_rank_request, 26006). %全服工头排行
-define(p_get_guild_foreman_rank_request, 26007). %公会工头排行
-define(p_get_guild_peon_rank_request, 26008). %公会苦工排行
-define(p_get_guild_peon_num_request, 26009). %公会已抓捕苦工数目


%s -> c

-define(p_get_guild_catched_peons_response, 26501). %查看、刷新公会已抓捕苦工(主面板)
-define(p_get_market_peon_list_response, 26502). %苦工市场天地榜列表
-define(p_get_catch_peon_last_time_response, 26503). %当日剩余可抓捕次数
-define(p_get_catched_peons_list_response, 26504). %已抓捕的苦工列表
-define(p_send_battle_report_list_response, 26505). %发送战报列表
-define(p_buy_catch_peon_time_response, 26506). %购买一次抓捕次数
-define(p_catch_peon_response, 26507). %抓捕苦工
-define(p_send_battle_report_response, 26508). %发送战报
-define(p_get_peon_rank_response, 26509). %
-define(p_get_foreman_rank_response, 26510). %
-define(p_get_guild_foreman_rank_response, 26511). %公会工头排行
-define(p_get_guild_peon_rank_response, 26512). %公会苦工排行
-define(p_get_today_bought_catch_peon_time_response, 26513). %当日已购买抓捕苦工次数
-define(p_get_guild_peon_num_response, 26514). %公会已抓捕苦工数目


%--------------------------------------------------------27段duplicate,副本相关-------------------------------------------------------------------

%module宏定义
-define(p_duplicate, p_27). %副本相关
%c -> s

-define(p_get_duplicate_info_request, 27001). %请求副本数据(当前只有多人秘境)
-define(p_open_multi_dungeon_request, 27002). %打开多人秘境队伍面板通知(将客户端加入广播列表,同时发送队伍信息)
-define(p_close_multi_dungeon_request, 27003). %关闭多人秘境队伍面板通知(将客户端移除广播列表,如果在队伍中退出队伍)
-define(p_create_multi_dungeon_team_request, 27004). %创建多人秘境队伍请求
-define(p_join_multi_dungeon_team_request, 27005). %加入多人秘境队伍请求
-define(p_quit_multi_dungeon_team_request, 27006). %退出多人秘境队伍请求
-define(p_enter_multi_dungeon_request, 27007). %请求进入多人秘境(队长)
-define(p_multi_dungeon_battle_request, 27008). %请求多人秘境战斗
-define(p_multi_dungeon_revive_request, 27009). %请求多人秘境重伤状态元宝复活
-define(p_get_duplicate_state_request, 27010). %请求当前副本状态信息

%s -> c

-define(p_send_duplicate_info_response, 27501). %发送玩家副本信息(主要是做的次数信息,目前只有多人秘境)
-define(p_send_multi_dungeon_team_response, 27502). %发送多人秘境队伍信息(每次全推送)
-define(p_create_multi_dungeon_team_response, 27503). %创建多人秘境队伍回应
-define(p_join_multi_dungeon_team_response, 27504). %加入多人秘境队伍回应
-define(p_send_self_multi_dungeon_team_response, 27505). %发送玩家自身所在秘境队伍信息
-define(p_notify_self_multi_dungeon_team_dismiss_response, 27506). %通知自身所在队伍删除
-define(p_enter_multi_dungeon_response, 27507). %请求进入多人秘境回应
-define(p_multi_dungeon_revive_response, 27508). %多人秘境重伤复活回应
-define(p_get_duplicate_state_response, 27509). %请求副本状态回应
-define(p_send_duplicate_state_response, 27510). %将副本状态信息发送给副本玩家
-define(p_finish_current_duplicate_response, 27511). %完成当前副本通知(点击确定离开)


%--------------------------------------------------------28段rank,排行-------------------------------------------------------------------

%module宏定义
-define(p_rank, p_28). %排行
%c -> s

-define(p_get_rank_list_request, 28001). %获取排行


%s -> c

-define(p_rank_main_apc_battle_power_list_response, 28501). %主角战斗力排行
-define(p_rank_player_battle_power_list_response, 28502). %队伍战斗力排行
-define(p_rank_player_coin_list_response, 28503). %铜币排行
-define(p_rank_player_lv_list_response, 28504). %等级排行
-define(p_rank_pet_list_response, 28505). %宠物排行
-define(p_rank_weapon_list_response, 28506). %武器排行
-define(p_rank_armor_list_response, 28507). %防具排行
-define(p_rank_guild_contribute_list_response, 28508). %家族贡献度排行
-define(p_rank_guild_money_list_response, 28509). %家族资金排行

%--------------------------------------------------------29段angel_overlord,谪仙台相关-------------------------------------------------------------------
%module宏定义
-define(p_angel_overlord, p_29). %谪仙台相关
%c -> s
-define(p_open_sys_reg_request, 29001). %玩家打开谪仙台登记请求
-define(p_close_sys_logout_request, 29002). %玩家关闭谪仙台注销请求
-define(p_challenge_overlord_battle_request, 29003). %挑战霸主请求
-define(p_buy_angel_overlord_times_request, 29004). %购买挑战次数请求
-define(p_cost_gold_cancel_cd_request, 29005). %消除谪仙战斗CD请求

%s -> c
-define(p_update_player_angel_overlord_info_response, 29501). %更新玩家谪仙信息
-define(p_update_angel_overlord_top_rank_response, 29502). %更新积分排行榜
-define(p_init_overlord_info_list_response, 29503). %初始化霸主列表信息
-define(p_update_angel_overlord_report_response, 29504). %推送战斗简报给玩家
-define(p_angel_overlord_response, 29505). %请求操作通用消息号响应
-define(p_update_overlord_info_list_response, 29506). %更新霸主列表信息
-define(p_update_angel_overlord_play_animation_response, 29507). %推送战斗简易动画给玩家-延用战报数据


%--------------------------------------------------------30段fairy_war,仙域之战-------------------------------------------------------------------

%--------------------------------------------------------30段fairy_war,仙域之战-------------------------------------------------------------------

%module宏定义
-define(p_fairy_war, p_30). %仙域之战
%c -> s

-define(p_get_fairy_war_info_request, 30000). %获取仙战信息
-define(p_join_war_request, 30001). %参战
-define(p_quit_war_request, 30002). %停止参战
-define(p_auto_join_war_request, 30003). %自动参战
-define(p_stop_auto_join_war_request, 30004). %停止自动参战
-define(p_add_buff_request, 30005). %激活破釜沉舟


%s -> c

-define(p_send_camp_info_list_response, 30501). %发送阵营信息
-define(p_send_kill_list_response, 30502). %发送连杀榜
-define(p_send_self_fairy_way_info_response, 30503). %发送玩家自己的仙战信息
-define(p_send_battle_reports_response, 30504). %发送战报
-define(p_join_war_response, 30505). %参战返回消息


%--------------------------------------------------------31段temple,九神殿通关-------------------------------------------------------------------

%module宏定义
-define(p_temple, p_31). %九神殿通关
%c -> s

-define(p_temple_challenge_request, 31001). %攻关挑战请求


%s -> c

-define(p_temple_challenge_response, 31501). %攻关挑战响应
-define(p_update_temple_id_response, 31502). %更新玩家进度ID响应
-define(p_update_temple_times_response, 31503). %更新玩家挑战次数响应


%--------------------------------------------------------32段jin_god_war,晋神之战-------------------------------------------------------------------

%module宏定义
-define(p_jin_god_war, p_32). %晋神之战
%c -> s

-define(p_enter_jin_god_war_map_request, 32001). %进入晋神之战场景（日常面板点击参加按钮，如果之前已经进入过直接进入战场，如果没有进入过，弹出组队面板）
-define(p_join_jin_god_war_request, 32003). %参加晋神之战
-define(p_create_jin_god_war_team_request, 32004). %创建队伍
-define(p_join_jin_god_war_team_request, 32005). %加入队伍
-define(p_get_ready_request, 32006). %准备
-define(p_quit_jin_god_war_team_request, 32007). %退出队伍
-define(p_kick_out_jin_god_war_team_request, 32008). %踢出队伍 Kick out
-define(p_get_jin_god_war_apc_list_request, 32009). %打开布阵面板
-define(p_drag_jin_god_war_apc_request, 32010). %布阵 拖动apc
-define(p_start_jin_god_battle_request, 32011). %发起战斗
-define(p_get_team_info_request, 32012). %获取自己的队伍成员信息
-define(p_enter_battle_scene_request, 32013). %进入战斗区域
-define(p_restore_full_hp_request, 32014). %金币恢复满血

%s -> c

-define(p_send_jin_god_team_list_response, 32501). %发送队伍列表
-define(p_send_jin_god_team_info_response, 32502). %发送玩家自身所在队伍信息
-define(p_send_jin_god_apc_list_response, 32503). %发送apc列表
-define(p_send_jin_god_notice_response, 32504). %发送晋神之战公告栏信息
-define(p_enter_jin_god_war_map_response, 32505). %进入战场返回消息（日常面板点击参加按钮）
-define(p_join_jin_god_war_response, 32506). %参加晋神之战返回消息
-define(p_create_jin_god_war_team_response, 32507). %创建队伍返回消息
-define(p_join_jin_god_war_team_response, 32508). %加入队伍返回消息
-define(p_send_jin_god_player_info_response, 32509). %发送玩家自身信息
-define(p_send_player_bomb_response, 32510). %发送有玩家自爆

%module宏定义
-define(p_guild_defend_war, p_33). %家族守卫战
%c -> s

-define(p_start_guild_defend_war_pve_request, 33001). %发起对boss的战斗
-define(p_start_guild_defend_war_pvp_request, 33002). %发起对入侵者的战斗
-define(p_get_guild_defend_war_info_request, 33003). %家族守卫战信息
-define(p_get_guild_defend_war_boss_hp_request, 33004). %家族守卫战boss剩余血量信息
-define(p_guild_defend_war_start_info_request, 33005). %家族守卫战开启信息
-define(p_guild_defend_war_start_buy_battle_times_request, 33006). %购买可战斗次数
-define(p_guild_defend_war_get_boss_is_dead_request, 33007). %获取boss是否死亡
-define(p_create_guild_pet_request, 33008). %放养萌兽
-define(p_feed_guild_pet_request, 33009). %喂养萌兽
-define(p_sell_guild_pet_request, 33010). %投入市场
-define(p_awake_guild_pet_request, 33011). %唤醒萌兽
-define(p_own_other_players_guild_pet_request, 33012). %诱拐萌兽
-define(p_get_map_guild_pet_request, 33013). %场景萌兽信息
-define(p_get_guild_pet_market_info_request, 33014). %萌兽市场信息
-define(p_guild_pet_market_buy_request, 33015). %买入
-define(p_guild_pet_market_sell_request, 33016). %卖出
-define(p_get_self_guild_pet_request, 33017). %自己萌兽信息


%s -> c

-define(p_start_guild_defend_war_pve_response, 33501). %发起对boss的战斗
-define(p_start_guild_defend_war_pvp_response, 33502). %发起对入侵者的战斗
-define(p_guild_defend_war_start_info_response, 33503). %家族守卫战开启信息
-define(p_guild_defend_war_public_info_response, 33504). %家族守卫战公共信息
-define(p_guild_defend_war_enemy_info_response, 33505). %家族守卫战进攻方信息
-define(p_guild_defend_war_boss_hp_response, 33506). %家族守卫战boss剩余血量信息
-define(p_guild_defend_war_start_buy_battle_times_response, 33507). %购买可战斗次数
-define(p_guild_defend_war_get_boss_is_dead_response, 33508). %获取boss是否死亡
-define(p_create_guild_pet_response, 33509). %放养萌兽
-define(p_feed_guild_pet_response, 33510). %喂养萌兽
-define(p_sell_guild_pet_response, 33511). %投入市场
-define(p_awake_guild_pet_response, 33512). %唤醒萌兽
-define(p_own_other_players_guild_pet_response, 33513). %诱拐萌兽
-define(p_get_map_guild_pet_response, 33514). %场景萌兽信息
-define(p_add_map_guild_pet_response, 33515). %添加场景萌兽
-define(p_update_map_guild_pet_response, 33516). %更新场景萌兽
-define(p_delete_map_guild_pet_response, 33517). %删除场景萌兽
-define(p_get_guild_pet_market_info_response, 33518). %萌兽市场信息
-define(p_guild_pet_market_buy_response, 33519). %买入
-define(p_guild_pet_market_sell_response, 33520). %卖出
-define(p_get_self_guild_pet_response, 33521). %自己萌兽信息
-define(p_update_self_guild_pet_response, 33522). %添加或更新自己萌兽
-define(p_delete_self_guild_pet_response, 33523). %删除自己萌兽
-define(p_guild_defend_war_defender_info_response, 33524). %家族守卫战防守方信息


%--------------------------------------------------------34段holiday_activity,节假日活动相关协议-------------------------------------------------------------------

%module宏定义
-define(p_holiday_activity, p_34). %节假日活动相关协议
%c -> s

-define(p_get_activity_status_request, 34001). %玩家登陆请求活动状态信息
-define(p_open_mechanism_request, 34002). %开启机关
-define(p_open_treasure_request, 34003). %开启宝箱
-define(p_get_treasure_layout_request, 34004). %进入场景请求宝箱数据


%s -> c

-define(p_get_activity_status_response, 34501). %玩家登陆请求活动状态信息
-define(p_open_mechanism_response, 34502). %开启机关请求返回（全局消息号）
-define(p_open_mechanism_result_response, 34503). %开启机关结果
-define(p_open_treasure_response, 34504). %开启宝箱请求回应（全局消息号）
-define(p_open_treasure_result_response, 34505). %开启宝箱结果


%--------------------------------------------------------35段unreal,虚冥幻境-------------------------------------------------------------------

%module宏定义
-define(p_unreal, p_35). %虚冥幻境
%c -> s

-define(p_challenge_unreal_request, 35000). %挑战
-define(p_sweep_unreal_request, 35001). %扫荡(开始扫荡和结束扫荡都是这个协议)
-define(p_get_award_request, 35002). %领取礼包
-define(p_get_unreal_list_request, 35003). %获取各关卡的信息
-define(p_get_assists_player_list_request, 35004). %获取助阵玩家列表
-define(p_get_help_request, 35005). %邀请助战
-define(p_get_unreal_apc_list_request, 35006). %获取布阵面板
-define(p_drag_unreal_apc_request, 35007). %布阵 拖动apc
-define(p_close_borad_list_request, 35008). %关闭面板


%s -> c

-define(p_send_unreal_list_response, 35501). %发送各关卡信息列表
-define(p_send_assists_player_list_response, 35502). %发送助战玩家列表
-define(p_get_help_response, 35503). %邀请助战返回消息
-define(p_send_unreal_apc_list_response, 35504). %发送apc列表
-define(p_send_sweep_info_response, 35505). %发送apc列表
-define(p_send_is_can_get_unreal_gift_response, 35506). %发送是否可以领取虚冥幻境礼包


%--------------------------------------------------------36段multi_conquest,多人征战相关协议-------------------------------------------------------------------

%module宏定义
-define(p_multi_conquest, p_36). %多人征战相关协议
%c -> s

-define(p_open_multi_conquest_request, 36001). %打开面板（获得其他玩家组队数据）
-define(p_close_multi_conquest_request, 36002). %关闭面板(退出队伍， 退出被广播列表)
-define(p_create_multi_conquest_team_request, 36003). %创建队伍
-define(p_join_multi_conquest_team_request, 36004). %加入队伍
-define(p_quit_multi_conquest_team_request, 36005). %退出队伍
-define(p_begin_multi_conquest_request, 36006). %开始多人征战(进入场景)
-define(p_multi_conquest_move_step_request, 36007). %移动同步、验证、致死等的处理
-define(p_multi_conquest_get_invincible_buff_request, 36008). %带盾请求（获得“无敌”状态）
-define(p_multi_conquest_buy_invincible_buff_request, 36009). %购买无敌状态
-define(p_multi_conquest_open_treasure_request, 36010). %打开宝箱
-define(p_multi_conquest_get_award_request, 36011). %拾取奖励请求
-define(p_multi_conquest_remove_member_request, 36012). %请离队员
-define(p_multi_conquest_call_member_request, 36013). %召集队友


%s -> c

-define(p_open_multi_conquest_response, 36501). %组队信息
-define(p_create_multi_conquest_team_response, 36502). %创建队伍请求回应
-define(p_join_multi_conquest_team_response, 36503). %加入队伍请求回应
-define(p_my_multi_conquest_team_info_response, 36504). %玩家自己所在队伍详细信息
-define(p_my_multi_conquest_team_removed_response, 36505). %自身所在队伍删除
-define(p_begin_multi_conquest_response, 36506). %进入多人秘境回应
-define(p_send_multi_conquest_info_response, 36507). %发送征战场景内的详情
-define(p_multi_conquest_get_invincible_buff_response, 36508). %获得无敌BUFF回应
-define(p_multi_conquest_broadcast_treasure_response, 36509). %击杀怪物出现宝箱广播
-define(p_multi_conquest_get_award_response, 36510). %拾取奖励返回
-define(p_multi_conquest_open_treasure_msg_response, 36511). %打开宝箱返回
-define(p_multi_conquest_open_treasure_response, 36512). %打开宝箱奖励返回
-define(p_mutli_conquest_invincible_props_response, 36513). %多人征战无敌道具出现通知
-define(p_multi_conquest_notify_transmit_response, 36514). %开启进入下一关卡传送门通知
-define(p_multi_conquest_remove_member_response, 36515). %请离队员回应
-define(p_multi_conquest_remove_by_leader_response, 36516). %通知玩家被队长移除
-define(p_multi_conquest_call_member_response, 36517). %召集队友返回
-define(p_multi_conquest_notify_finish_response, 36518). %多人征战通关提示







