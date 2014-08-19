%%%----------------------------------------------------------------------
%%% @copyright 2011
%%% @author q
%%% @des 文件保存数据
%%%----------------------------------------------------------------------

-define(dets_key_storage_version, dets_key_storage_version). %保存版本号的dets


-define(dets_key_storage_player, dets_key_storage_player). %保存玩家数据
%% 玩家数据保存结构,其他保存的用于修复的数据结构可参考此结构
-record(storage_file_player_status, {
  id,        %玩家id
  ver,       %保存数据版本号
  time,      %保存时间戳
  value      %玩家数值--复杂结构
}).

-define(dets_key_storage_bulletin, dets_key_storage_bulletin).  %保存系统公告

-record(storage_file_bulletin,
{
  id,             %服务器version 纯int型
  version = [],   %用于显示给玩家的version，可能是形如"R14B"这样的字符串， 用列表存储
  add_time,       %添加时间（时间戳）
  content = [],    %内容——HTML文本
  start_time = 0 %开始生效时间 UNIX时间戳
}).

-define(dets_key_storage_guild_battle_result, dets_key_storage_guild_battle_result). %% 保存家族战结果


%% mod_storage_file state数据结构
-record(storage_file_state, {
  version = 1      %当前版本号
}).

-define(storage_ver_key, storage_ver_key). %版本保存key值

-define(dets_key_storage_friend_share_exp, dets_key_storage_friend_share_exp).   %好友分享经验

-define(dets_key_storage_peon, dets_key_storage_peon).  %抓苦工


-define(dets_key_storage_exam, dets_key_storage_exam).  %答题ets数据

-define(dets_mall_bought_info, dets_mall_bought_info).  %商城限购信息

-define(dets_guild_defend_last_war_info, dets_guild_defend_last_war_info).  %家园战信息




-define(dets_key_storage_player_temp_info, dets_key_storage_player_temp_info).  %ets数据-玩家临时信息

-define(dets_gpm_event, dets_gpm_event).











