%%%==============================================================================
%%% Author      :fangjie008@163.com
%%% Created     :2012-11
%%% Description :服务器日志记录
%%%==============================================================================
-module(lib_server_log).
-include("common.hrl").


%% 记录日志
-define(slog(Log_Type, Para_List), mod_server_log:log(Log_Type, Para_List)).

-export([
  handle/2
]).

-export([t1/0, t2/1]).


%% 记录日志,之所以在这里添加一层是为了方便缺少日志的跟踪
%% 另外可以把编码转化为对应的原子描述
%% 第一个参数为配置的原子,每种日志类型对应一个
%% Paras:参数列表,每种日志类型参数数量和类型不同
%% 返回值:不使用

%% 201	创建角色成功
%% role_id	career	sex
handle(create_player, Paras) ->
  ?slog(201, Paras);
%% 203	角色上线
%% role_id	ip
handle(player_online, Paras) ->
  ?slog(203, Paras);
%% 204	角色下线
%% role_id
handle(player_offline, Paras) ->
  ?slog(204, Paras);
%% 205	角色升级
%% role_id	level	
handle(level_up, Paras) ->
  ?slog(205, Paras);
%% 206	角色战斗失败
%% datetime	role_id	(1:PVP|2:PVE)	战斗性质	(1:主动|2:被动)	(role_id|battle_id)	   --1|1|1--			录像地址
handle(battle_failed, Paras) ->
  ?slog(206, Paras);
%% 207	切换地图
%% role_id	from_map_id	to_map_id
handle(change_map, Paras) ->
  ?slog(207, Paras);
%% 209	接受任务
%% role_id	task_id	
handle(accept_task, Paras) ->
  ?slog(209, Paras);
%% 210	完成任务目标
%% role_id	task_id
handle(finish_task, Paras) ->
  ?slog(210, Paras);
%% 211	提交任务
%% role_id	task_id	
handle(submit_task, Paras) ->
  ?slog(211, Paras);
%% 300	获得铜币 2012-12-13 15:27 日志追溯完成
%% role_id	count	eventcode
handle(acquire_coin, Paras) ->
  ?slog(300, Paras);
%% 301	失去铜币 2012-12-13 15:35 日志追溯完成
%% role_id	count	eventcode
handle(lose_coin, Paras) ->
  ?slog(301, Paras);
%% 302	获取金币 2012-12-13 15:40 日志追溯完成
%% role_id	count	eventcode
handle(acquire_gold, Paras) ->
  ?slog(302, Paras);
%% 303	失去金币 2012-12-13 15:52 日志追溯完成
%% role_id	count	eventcode
handle(lose_gold, Paras) ->
  ?slog(303, Paras);
%% 304	获得物品
%% role_id	count	template_id	eventcode
handle(acquire_goods, Paras) ->
  ?slog(304, Paras);
%% 305	失去物品
%% role_id	count	template_id	eventcode
handle(lose_goods, Paras) ->
  ?slog(305, Paras);
%% 306	获得修为 2012-12-13 16:16 日志追溯完成
%% role_id	count	eventcode
handle(acquire_xiuwei, Paras) ->
  ?slog(306, Paras);
%% 307	失去修为 2012-12-13 16:18 日志追溯完成
%% role_id	count	eventcode
handle(lose_xiuwei, Paras) ->
  ?slog(307, Paras);
%% 308	获得经验 2012-12-13 16:20 日志追溯完成
%% role_id	count	eventcode
handle(acquire_exp, Paras) ->
  ?slog(308, Paras);
%% 309	获得体力 2012-12-13 16:25 日志追溯完成
%% role_id	count	eventcode
handle(acquire_strength, Paras) ->
  ?slog(309, Paras);
%% 310	失去体力 2012-12-13 16:28 日志追溯完成
%% role_id	count	eventcode
handle(lose_strength, Paras) ->
  ?slog(310, Paras);
%% 311	获得人参果 2012-12-13 16:29 日志追溯完成
%% role_id	count	eventcode
handle(acquire_renshenguo, Paras) ->
  ?slog(311, Paras);
%% 312	失去人参果 2012-12-13 16:30 日志追溯完成
%% role_id	count	eventcode
handle(lose_renshenguo, Paras) ->
  ?slog(312, Paras);
%% 313	获得紫晶琉璃果 2012-12-13 16:31 日志追溯完成
%% role_id	count	eventcode
handle(acquire_zijingguo, Paras) ->
  ?slog(313, Paras);
%% 314	失去紫晶琉璃果 2012-12-13 16:32 日志追溯完成
%% role_id	count	eventcode
handle(lose_zijingguo, Paras) ->
  ?slog(314, Paras);
%% 315	获得家族贡献
%% role_id	count	eventcode
handle(acquire_guild_contri, Paras) ->
  ?slog(315, Paras);
%% 316	失去家族贡献
%% role_id	count	eventcode
handle(lose_guild_contri, Paras) ->
  ?slog(316, Paras);
%% 317	家族资金增加
%% 家族名称（id）	count	eventcode
handle(guild_fund_increase, Paras) ->
  ?slog(317, Paras);
%% 318	家族资金减少
%% 家族名称（id）	count	eventcode
handle(guild_fund_reduce, Paras) ->
  ?slog(318, Paras);
%% 319	获得参悟点 2012-12-13 16:33 日志追溯完成
%% role_id	count	eventcode
handle(acquire_awaken_point, Paras) ->
  ?slog(319, Paras);
%% 320	失去参悟点 2012-12-13 16:33 日志追溯完成
%% role_id	count	eventcode
handle(lose_awaken_point, Paras) ->
  ?slog(320, Paras);
%% 322	获得元神
handle(get_spirit, Paras) ->
  ?slog(322, Paras);
%% 323	失去元神
handle(lose_spirit, Paras) ->
  ?slog(323, Paras);
%% 324	获得元神碎片
handle(get_spirit_chip, Paras) ->
  ?slog(324, Paras);
%% 325	失去元神碎片
handle(lose_spirit_chip, Paras) ->
  ?slog(325, Paras);
%% 326	获得活跃点
handle(acquire_activepoint, Paras) ->
  ?slog(326, Paras);
%% 327	失去活跃点
handle(lose_activepoint, Paras) ->
  ?slog(327, Paras);
%% 330	装备强化
%% role_id	template_id	强化等级(强化后)
handle(strengthen_equipment, Paras) ->
  ?slog(330, Paras);
%% 331	装备合成
%% role_id	template_id(合成后)
handle(merge_equipment, Paras) ->
  ?slog(331, Paras);
%% 332	装备洗炼
%% role_id	template_id	(1:单个|10:批量)	(1:普通|2:定向)	(0:不锁定|1:锁定)	(0:不锁定|1:锁定)	(0:不锁定|1:锁定)
handle(sophistication_equipment, Paras) ->
  ?slog(332, Paras);
%% 333	装备提升品质
%% role_id	template_id	品质颜色(提升后)	品质等级(提升后)
handle(promote_equipment_quality, Paras) ->
  ?slog(333, Paras);
%% 334	装备洗炼-替换属性
%% role_id	template_id
handle(replace_property, Paras) ->
  ?slog(334, Paras);
%% 349	升级阵位
%% role_id	role_lv	阵位编号	阵位等级
handle(up_zhenwei, Paras) ->
  ?slog(349, Paras);%% 201	创建角色成功
%% 350	升级阵法
%% role_id	role_lv	阵法等级
handle(up_zhenfa, Paras) ->
  ?slog(350, Paras);
%% 351	强化法宝-法宝升级
%% role_id	role_lv	法宝编号	法宝等级（强化后）
handle(strengthen_magic_weapon, Paras) ->
  ?slog(351, Paras);
%% 352	激活法宝
%% role_id	role_lv	法宝编号
handle(activate_magic_weapon, Paras) ->
  ?slog(352, Paras);
%% 353	抓捕宠物
%% role_id	role_lv	pet_id	(1:成功|2:失败)
handle(capture_pet, Paras) ->
  ?slog(353, Paras);
%% 354	熔合宠物
%% role_id	role_lv	pet_id
handle(merge_pet, Paras) ->
  ?slog(354, Paras);
%% 355	放生宠物
%% role_id	pet_id
handle(free_pet, Paras) ->
  ?slog(355, Paras);
%% 356	购买宠物
handle(buy_pet, Paras) ->
  ?slog(356, Paras);
%% 360	完成摘仙果
%% role_id	role_lv	(1:轻松|2:高手|3:专家)
handle(finish_xianguo, Paras) ->
  ?slog(360, Paras);
%% 365	购买碎片
%% role_id
handle(buy_fragment, Paras) ->
  ?slog(365, Paras);
%% 370	创建家族
%% role_id	家族名称（id）
handle(create_guild, Paras) ->
  ?slog(370, Paras);
%% 371	解散家族
%% role_id	家族名称（id）
handle(dismiss_guild, Paras) ->
  ?slog(371, Paras);
%% 372	加入家族
%% 家族名称（id）	role_id（加入者）
handle(join_guild, Paras) ->
  ?slog(372, Paras);
%% 373	退出家族
%% 家族名称（id）	role_id（退出者）
handle(quit_guild, Paras) ->
  ?slog(373, Paras);
%% 374	逐出家族
%% 家族名称（id）	role_id（逐出者）	role_id（被逐出者）
handle(expel_guild_player, Paras) ->
  ?slog(374, Paras);
%% 380	获得活跃度 
%% role_id	清零前的活跃度
handle(acquire_liveness, Paras) ->
  ?slog(380, Paras);
%% 390	仙域之战参与
%% role_id	role_lv
handle(join_xianyu_battle, Paras) ->
  ?slog(390, Paras);
%% 391	仙域之战使用破釜沉舟BUFF
%% role_id	role_lv
handle(use_xianyu_buffer, Paras) ->
  ?slog(391, Paras);
%% 392	完成神行千里
%% role_id	role_lv	伙伴id	(1:普通|2:极速)
handle(finish_shenxing, Paras) ->
  ?slog(392, Paras);

%% 世界boss
handle(world_boss, Paras) ->
  ?slog(393, Paras);

handle(world_boss_award, Paras) ->
  ?slog(394, Paras);

handle(guild_defend_war, Paras) ->
  ?slog(394, Paras);

handle(acquire_ambrosia_step, Paras) ->
  ?slog(361, Paras);

%% 400 激活坐骑
handle(active_mount, Paras) ->
  ?slog(400, Paras);

%% 405 兑换丹药
handle(buy_drug, Paras) ->
  ?slog(405, Paras);

%% 500 兑换丹药
handle(get_guild_pet, Paras) ->
  ?slog(500, Paras);

%% 501 兑换丹药
handle(lost_guild_pet, Paras) ->
  ?slog(501, Paras);

%% 600 玩家领取腾讯金币
handle(draw_tencent_gold, Paras) ->
  ?slog(600, Paras);

%% 未匹配
handle(Match, Paras) ->
  ?Error(server_log_logger, "unmatch match:~p, Paras:~p", [Match, Paras]).


%% --------test----------------------------------------------
t1() ->
  ?Error(server_log_logger, "~ts", [[123, 34, 114, 101, 116, 34, 58, 49, 44, 34, 109, 115, 103, 34, 58, 34, 232, 175, 183, 230, 177, 130, 229, 143, 130, 230, 149, 176, 233, 148, 153, 232, 175, 175, 40, 122, 111, 110, 101, 105, 100, 41, 34, 125]]),
  io:format("~ts", [[123, 34, 114, 101, 116, 34, 58, 49, 44, 34, 109, 115, 103, 34, 58, 34, 232, 175, 183, 230, 177, 130, 229, 143, 130, 230, 149, 176, 233, 148, 153, 232, 175, 175, 40, 122, 111, 110, 101, 105, 100, 41, 34, 125]]).

t2(Des) ->
  ?Error(server_log_logger, "~ts", [Des]),
  io:format("~ts", [Des]).
    


