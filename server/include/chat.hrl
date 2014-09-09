
%%%-----------------------------------------------------------------------------
%% 文件： chat.hrl
%% 创建时间： 2012-7-24 17:34:35
%% 作者： 杨玉东
%% 描述：  聊天头文件
%%%-----------------------------------------------------------------------------
-define(CHAT_SENDERS, chat_senders).    %用于 保存发送信息进程的IDs 的进程字典
-define(DICT_SYSTEM_CHAT_CONTENT, dict_system_chat_content).    %系统消息进程字典
-define(DICT_MAIL_MSG_CONTENT, dict_mail_msg_content).      %离线消息进程字典

%%************************************聊天频道***********************************
-define(CHAT_CHANNEL_WORLD, 101).           %% 频道：世界
-define(CHAT_CHANNEL_GUILD, 102).           %% 频道：家族
-define(CHAT_CHANNEL_ACTIVITY, 103).        %% 频道：活动

%%************************************系统消息***********************************
-define(CHAT_SYSTEM_NOTICE, 201).     %% 系统消息
-define(CHAT_SYSTEM_BROADCAST, 202).  %% 全服广播——屏幕区域A

%%************************************邮件（离线）消息*************************************
-define(MSG_MAIL_ATHLETICS, 1).     %离线消息——竞技场
-define(MSG_MAIL_PEON, 2).          %离线消息——抓苦工
-define(MSG_MAIL_EXAM, 3).          %离线消息——答题
-define(MSG_MAIL_ANGEL_OVERLOAD, 4). %离线消息——谪仙
-define(MSG_MAIL_GUILD_DEFEND, 5).    %离线消息——家园保卫战

%%************************************向屏幕指定区域发送消息**************************
%%详情见策划文档（007信息提示——焦政乐.docx）中的描述
-define(SCREEN_AREA_A, 1).
-define(SCREEN_AREA_B, 2).
-define(SCREEN_AREA_C, 4).
-define(SCREEN_AREA_D, 8).
-define(SCREEN_AREA_E, 16).
-define(SCREEN_AREA_F, 32).

-define(SCREEN_AREA_ALL, [1, 2, 4, 8, 16, 32]).


-define(WHISPER_CHAT_CONTENT_MAX_LENGTH, 400).         %% 私人聊天，最大字符数
-define(CHANNEL_CHAT_CONTENT_MAX_LENGTH, 240).      %% 频道聊天,最大字符数,服务器端限制的会放的大一点,防止恶意攻击,大部分屏蔽是客户端屏蔽

-define(CHANNEL_CHAT_INTERVAL_WORLD, 5).         %% 频道聊天(世界),发言间隔时间
-define(CHANNEL_CHAT_INTERVAL_GUILD, 1).        %% 频道聊天(家族),发言间隔时间
-define(CHANNEL_CHAT_INTERVAL_ACTIVITY, 5).        %% 活动频道聊天，发言间隔时间


%% -------------- 聊天频道展示 -----------------
-define(CHAT_SHOW_TYPE_MENU, 1).    %聊天展示方式——菜单（主要用于展示玩家）
-define(CHAT_SHOW_TYPE_TOOLTIP, 2). %聊天展示方式——tooltip（主要用于展示物品）
-define(CHAT_SHOW_TYPE_ROUTE, 3).    %聊天展示方式——寻径（主要用于地图名称显示）
-define(CHAT_SHOW_TYPE_ROUTE_GUILD_DEFEND, 4).  %聊天展示方式——家族保卫战中的寻径
-define(CHAT_SHOW_TYPE_ROUTE_MULTI_CONQUEST, 5).  %聊天展示方式——多人征战中的寻径



-define(SYSTEM_CHAT_STATE_NORMAL, 0).   %系统消息状态——正常
-define(SYSTEM_CHAT_STATE_LOCKED, 1).   %系统消息状态——锁定

%%**************************************服务器推送系统消息、广播、提示等消息中展示**************************************
-define(SYSTEM_CHAT_SHOW_ITEM, 1).      %物品
-define(SYSTEM_CHAT_SHOW_MAP, 2).       %场景
-define(SYSTEM_CHAT_SHOW_MONSTER, 3).   %怪物
-define(SYSTEM_CHAT_SHOW_SPIRIT, 4).    %元神
-define(SYSTEM_CHAT_SHOW_PET, 5).       %宠物
-define(SYSTEM_CHAT_SHOW_DUNGEON, 6).   %秘境
-define(SYSTEM_CHAT_SHOW_SHENXING, 7).  %神行境界
-define(SYSTEM_CHAT_SHOW_APC, 8).       %APC
-define(SYSTEM_CHAT_SHOW_TALISMAN, 9).  %法宝
-define(SYSTEM_CHAT_SHOW_GUILD_PET, 10).        %家园萌兽

%%**************************************服务器推送系统消息、广播、提示等消息中展示**************************************

-define(SENDER_SYSTEM, -1).     %系统发送消息

%% ----------------聊天字体颜色-----------------------------

-define(TEXT_COLOR_ITEM_WHITE, "#FFFFFF").   %物品——白色
-define(TEXT_COLOR_ITEM_BLUE, "#00AEFF").    %物品——蓝色
-define(TEXT_COLOR_ITEM_PURPLE, "#CE15A0").  %物品——紫色
-define(TEXT_COLOR_ITEM_ORANGE, "#FFB320").   %物品——橙色

-define(TEXT_COLOR_SPIRIT_GREEN, "#97DB06").    %元神——绿色
-define(TEXT_COLOR_SPIRIT_ORANGE, "#FFB320").   %元神——橙色
-define(TEXT_COLOR_SPIRIT_RED, "#E60012").      %元神——红色

-define(TEXT_COLOR_ORANGE, "#FFB320").     %文字颜色——橙色

-define(TEXT_COLOR_SHENXING_GROUND, "#FFFFFF").    %神行千里境界——地之境
-define(TEXT_COLOR_SHENXING_HUMAN, "#00AEFF").     %神行千里境界——人之境
-define(TEXT_COLOR_SHENXING_SKY, "#CE15A0").       %神行千里境界——天之境
-define(TEXT_COLOR_SHENXING_GOD, "#FFB320").       %神行千里境界——圣之境

-define(TEXT_COLOR_MAP, "#FFD900").    %颜色——地名
-define(TEXT_COLOR_DUNGEON, "#FFD900").       %颜色——秘境名
-define(TEXT_COLOR_AWARD, "#68BE8D").   %颜色——奖励
-define(TEXT_COLOR_RANK, "#F3BF88").     %颜色——排行
-define(TEXT_COLOR_GENDER_MALE, "#0095D9").      %颜色——性别男
-define(TEXT_COLOR_GENDER_FEMALE, "#BA2636").    %颜色——性别女
-define(TEXT_COLOR_NAME, "#F3BF88").       %颜色——玩家名
-define(TEXT_COLOR_MONSTER, "#E60012").     %颜色——怪物
-define(TEXT_COLOR_APC, "#FFD900").     %颜色——APC


-define(SYS_CHAT_DB_FIELD, "id, type, content, state, start_time, end_time, cooldown").     %数据库系统消息表字段

-define(MONSTER_ATTACK_MAP, 7).         %怪物进村活动场景——落古村
