%%%-----------------------------------------------------------------------------
%% 文件： chat.hrl
%% 创建时间： 2012-7-24 17:34:35
%% 作者： 杨玉东
%% 描述：  聊天头文件
%%%-----------------------------------------------------------------------------
-define(CHAT_SENDERS, chat_senders).    %用于 保存发送信息进程的IDs 的进程字典
-define(DICT_SYSTEM_CHAT_CONTENT, dict_system_chat_content).    %系统消息进程字典
-define(DICT_MAIL_MSG_CONTENT, dict_mail_msg_content).      %离线消息进程字典

-define(WHISPER_CHAT_CONTENT_MAX_LENGTH, 400).         %% 私人聊天，最大字符数
-define(CHANNEL_CHAT_CONTENT_MAX_LENGTH, 240).      %% 频道聊天,最大字符数,服务器端限制的会放的大一点,防止恶意攻击,大部分屏蔽是客户端屏蔽

-define(CHANNEL_CHAT_INTERVAL_WORLD, 5).         %% 频道聊天(世界),发言间隔时间


-define(SYSTEM_CHAT_STATE_NORMAL, 0).   %系统消息状态——正常
-define(SYSTEM_CHAT_STATE_LOCKED, 1).   %系统消息状态——锁定


-define(SENDER_SYSTEM, -1).     %系统发送消息

