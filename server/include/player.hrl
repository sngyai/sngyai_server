%%%----------------------------------------------------------------------
%%% @copyright 2011
%%% @author tj
%%% @des 玩家相关信息
%%%----------------------------------------------------------------------

-define(Relive_Scan_Tick, 1000). %% 复活tick 单位毫秒

-define(Player_State_Died, 0).      %死亡状态
-define(Player_State_Normal, 1).    %正常状态

-define(Player_Relive_Type_Auto, 1).%默认自动复活
-define(Player_Relive_Type_Inplace_Cost_Gold, 2).%花费金币原地复活

-define(Player_Relive_Has_Gold, 2).%玩家复活需要元宝数


-define(Worship_Level, 1). %祭拜财神需要的等级,目前没有等级限制





-define(Welfare_Level_10000, 10000). %福利号10000
-define(Welfare_Level_24000, 24000). %福利号24000

-define(Welfare_Level_10000_Gain, 5000). %福利号10000奖励数量
-define(Welfare_Level_24000_Gain, 12000). %福利号24000奖励数量

-define(Welfare_Activated_State_Not_Activated, 0). %福利号非激活状态
-define(Welfare_Activated_State_Activated, 1). %福利号激活状态



-define(Salary_Level_Limit, 30). %领取俸禄等级限制


%% 延迟执行数据结构
-record(delay_function,
{
  type,    %类型,用来筛选延迟的类别,比如战斗后,退出场景后,等等
  function  %fun/0 function
}).

-define(delay_function_type_battle, 1). %战斗结束执行类型,战斗结束后执行


%% 收藏有礼相关
-define(favorite_gift_xiuwei, 500). %修为数量
-define(favorite_gift_coin, 50000). %铜币数量
-define(favorite_gift_bag, 50100014).  %礼包物品id



-define(player_restrict_state_banned_nothing, 0).  %玩家受限状态--不受限
-define(player_restrict_state_banned_chat, 1).  %玩家受限状态--禁言
-define(player_restrict_state_banned_game, 2).  %玩家受限状态--禁止游戏，客户端禁止
-define(player_restrict_state_banned_login, 3).  %玩家受限状态--禁止角色登入游戏



-define(daily_invite_state_not_invite, 0).  %邀请好友状态0:未邀请
-define(daily_invite_state_invited, 1).  %邀请好友状态1:已邀请,未领取奖励
-define(daily_invite_state_drawed, 2).  %邀请好友状态2:已领取奖励


%% 注意这里只准添加字段,不准减少字段,如果非要减少字段,要更新前删除对应的dets文件
%% 这个record相当于是对于对应数据库的player_status record的一个辅助表,用来存放一些不那么"要紧"的数据
-record(player_temp_info,
{
  id,                     %id,{玩家id,key枚举}, key 对应player_temp_info_key_xxx宏定义
  key,                    %key 对应player_temp_info_key_xxx宏定义
  value                   %value1
}).

-define(player_temp_info_key_activity_child, 1). %六一活动
-define(player_temp_info_key_activity_dragon_boat, 2).  %端午活动









