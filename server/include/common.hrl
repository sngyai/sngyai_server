%%%------------------------------------------------
%%% Author  :  fangjie008
%%% Created : 2012-06-14
%%% Description: 公共定义,与具体逻辑无关 
%%%------------------------------------------------


%% 系统中公共服务-全局唯一-(例如公会,各种活动gen_server)启动参数,这些参数非常敏感,只有深入理解和经过测试才可以设置,特别是swawn_opt,特殊进程可以单独设置{log_to_file, "tracefile_a"}
%% 注意priority 不要轻易使用:Other priorities than normal are normally not needed. When other priorities are used, they need to be used with care, especially the high priority must be used with care. A process on high priority should only perform work for short periods of time. Busy looping for long periods of time in a high priority process will most likely cause problems, since there are important servers in OTP running on priority normal. 
-define(Public_Service_Options, [{debug, []}, {timeout, 10000},
  {spawn_opt, [{fullsweep_after, 512}, {min_heap_size, 102400}, {min_bin_vheap_size, 1024000}]}]).

%% 系统普通服务进程,不是全局唯一,例如副本,怪物
-define(General_Service_Options, [{debug, []}, {timeout, 10000},
  {spawn_opt, [{fullsweep_after, 512}, {min_heap_size, 102400}, {min_bin_vheap_size, 1024000}]}]).

%% socket连接相关-----------------------------------------------------------------------------------------------------------------
%%flash843安全沙箱
-define(FL_POLICY_REQ, <<"<poli">>). % 字符个数对应包头长度
-define(FL_POLICY_FILE, <<"<cross-domain-policy><allow-access-from domain='*' to-ports='*' /></cross-domain-policy>">>).

%%tcp设置
-define(TCP_OPTIONS, [binary, {packet, 0}, {active, false}, {reuseaddr, true}, {nodelay, false}, {delay_send, true}, {send_timeout, 5000}, {keepalive, false}, {exit_on_close, false}, {backlog, 30}]).

-define(Spawn_Link_Opt, [link, {fullsweep_after, 1000}, {min_heap_size, 700}]).

%%每个socket打开发送消息客户端进程数量
-define(SEND_MSG_PROCESS_NUM, 3).


%% 服务端主动断开连接原因定义
-define(Kick_Reason_Time_Unusual, 1). %时间异常,客户端可能使用了变速齿轮
-define(Kick_Reason_Duplicated_Login, 2). %异地登陆
-define(KICK_REASON_GM_KICK, 3).    %GM手动将其踢下线
-define(KICK_REASON_HACKER, 4).    %小制作游戏，拒绝外挂,谢谢合作
-define(Kick_Reason_Tencent_Api_Fail, 5).    %远程调用失败,请刷新重新进入

-define(Kick_Client_Time_Unusual_Limits, 30). %服务端时间和客户端时间差别多少秒踢除客户端连接,单位秒

%%数据库模块选择 (db_mysql 或 db_cache)------------------------------------------------------------------------------------------

%% mysql conn pool名称-默认连接池,游戏逻辑
-define(MYSQL_DB_POOL_GAME, mysql_conn_pool_game).

%% 数据库调用模块
%% -define(DB_GAME, (db_mysql:new(?MYSQL_DB_POOL_GAME))).
-define(DB_GAME, db_mysql).

%%Mysql语句执行超时时间,单位毫秒
-define(DB_EXECUTE_TIMEOUT, 20000).


%%%_------------------------ETS表相关-------------------------------------------------------------------
-define(ETS_STAT_DB, ets_stat_db).  %% 数据库访问统计(表名，操作，次数)
-define(ETS_ONLINE, ets_online).    %% 玩家在线ETS
-define(ETS_MAP_WALKABLE, ets_map_walkable).    %% 可行走坐标
-define(ETS_MONITOR_PID, ets_monitor_pid).      %%进程监控
-define(ETS_ATHLETICS_RANK, ets_athletics_rank).      %%竞技场排行榜ETS表
-define(ETS_GUILD, ets_guild).
-define(ETS_GUILD_MEMBER, ets_guild_member).
-define(ETS_GUILD_APPLY, ets_guild_apply).
-define(ETS_GUILD_BATTLE_APPLY, ets_guild_battle_apply).
-define(ETS_PEON, ets_peon).                            %% 苦工表（都是苦工）
-define(ETS_PLAYER_PEON, ets_player_peon).              %% 正在玩“抓苦工”玩家的待抓捕苦工表（都不是苦工）
-define(ETS_PEON_PEON_RANK, ets_peon_peon_rank).        %% 全服苦工排行
-define(ETS_PEON_FOREMAN_RANK, ets_peon_foreman_rank).  %% 全服工头排行
-define(ETS_PEON_GUILD_FOREMAN_RANK, ets_peon_guild_foreman_rank).  %公会工头排行
-define(ETS_GUILD_BATTLE_PLAYER, ets_guild_battle_player). %% 家族战玩家信息
-define(ETS_PEON_GUILD_PEON_RANK, ets_peon_guild_peon_rank).        %公会苦工排行
-define(ETS_PLAYER_BETTING_TIMES, ets_player_batting_times).  %%玩家投注次数
-define(ETS_RANK, ets_rank).  %%排行
-define(ETS_Asyn_Data, ets_read_only_asyn_data).  %%离线缓存
-define(ETS_DAILY_BULLETIN, ets_daily_bulletin).    %日常公告
-define(ETS_FAIRY_WAR_PLAYER, ets_fairy_war_player). %% 仙域之战中玩家信息
-define(ETS_CAMP_SUCCESS_TIMES, ets_camp_war_player). %% 阵营胜利次数
-define(ETS_SYSTEM_DATA, ets_system_data). %% 系统动态数据 {key, Value} %% 比如 当前最高玩家等级{max_lv, 48}
-define(ETS_JIN_GOD_WAR_PLAYER, ets_jin_god_war_player). %% 晋神之战玩家信息表
-define(ETS_JIN_GOD_WAR_TEAM, ets_jin_god_war_team). %% 晋神之战队伍信息表
-define(ETS_MALL_BOUGHT_INFO, ets_mall_bought_info). %% 商城限购信息
-define(ETS_GUILD_SCENE, ets_guild_scene). %% 帮会场景
-define(ETS_GUILD_DEFEND_LAST_WAR_INFO, ets_guild_defend_last_war_info). %% 家园守卫战上次战斗信息
-define(ETS_GUILD_DEFEND_WAR_INFO, ets_guild_defend_war_info). %% 家园守卫战信息
-define(ETS_GUILD_DEFEND_WAR_ENEMY, ets_guild_defend_war_enemy). %% 家园守卫战敌人信息
-define(ETS_GUILD_DEFEND_WAR_DEFENDER, ets_guild_defend_war_defender). %% 家园守卫战防御者信息
-define(ETS_GUILD_PET, ets_guild_pet). %% 萌宠
-define(ETS_GUILD_PET_MARKET, ets_guild_pet_market). %% 萌宠市场
-define(ETS_GUILD_PET_MARKET_EVENT, ets_guild_pet_market_event). %% 萌宠市场事件
-define(ETS_PLAYER_TEMP_INFO, ets_player_temp_info). %% 玩家临时数据,可以保存在dets中的
-define(ETS_UNREAL_HELP_PLAYER, ets_unreal_help_player).  %% 虚冥幻境助战玩家列表
-define(ETS_MULTI_CONQUEST_TEAM, ets_multi_conquest_team).  %%多人征战队伍


%%%_------------------------数据缓存标记--------------------------------------------------------------------------------------------
-define(DATA_FLAG_NONE, 0).%没有变化 正常状态
-define(DATA_FLAG_INSERT, 1).%新增 插入状态
-define(DATA_FLAG_UPDATE, 2).%数据变化 更新状态


%% log4erl相关---------------------------------------------------------------------------------------------------------------
% 注意这个地方参数数量要跟format匹配,错误的话也会编译通过但是运行时会出错
%log4erlang 需要logger,日志记录例子: ?Error(team_logger, [Reason]),
% debug -> info -> warn -> error -> fatal
-define(Debug(Logger_name, Log_message), log4erl:debug(Logger_name, io_lib:format("[~w:~w] " ++ Log_message, [?MODULE, ?LINE]))).
-define(Info(Logger_name, Log_message), log4erl:info(Logger_name, io_lib:format("[~w:~w] " ++ Log_message, [?MODULE, ?LINE]))).
-define(Warn(Logger_name, Log_message), log4erl:warn(Logger_name, io_lib:format("[~w:~w] " ++ Log_message, [?MODULE, ?LINE]))).
-define(Error(Logger_name, Log_message), log4erl:error(Logger_name, io_lib:format("[~w:~w] " ++ Log_message, [?MODULE, ?LINE]))).
-define(Fatal(Logger_name, Log_message), log4erl:fatal(Logger_name, io_lib:format("[~w:~w] " ++ Log_message, [?MODULE, ?LINE]))).


%%日志记录例子: ?Error(team_logger, "reason:~p", [Reason]),
-define(Debug(Logger_name, Log_message, A), log4erl:debug(Logger_name, io_lib:format("[~w:~w] " ++ Log_message, [?MODULE | [?LINE | A]]))).
-define(Info(Logger_name, Log_message, A), log4erl:info(Logger_name, io_lib:format("[~w:~w] " ++ Log_message, [?MODULE | [?LINE | A]]))).
-define(Warn(Logger_name, Log_message, A), log4erl:warn(Logger_name, io_lib:format("[~w:~w] " ++ Log_message, [?MODULE | [?LINE | A]]))).
-define(Error(Logger_name, Log_message, A), log4erl:error(Logger_name, io_lib:format("[~w:~w] " ++ Log_message, [?MODULE | [?LINE | A]]))).
-define(Fatal(Logger_name, Log_message, A), log4erl:fatal(Logger_name, io_lib:format("[~w:~w] " ++ Log_message, [?MODULE | [?LINE | A]]))).


%% 调试输出相关-------------------------------------------------------------------------------------------------------------------
%condition macro
-ifdef(product).
-define(T(Des), ?Debug(debug_logger, "~p", [Des])).
-define(T(Des, Values), ?Debug(debug_logger, "~s", [lists:flatten(io_lib:format(Des, Values))])).

-else.


-define(T(Des), begin
                  io:format("~n===============~n~p,module:~p,line:~p~n~p ~n==================~n~n~n", [calendar:local_time(), ?MODULE, ?LINE, Des])
%%                   ?Debug(debug_logger, "~p", [Des])
                end).
-define(T(Des, Values), begin
                          io:format("~n===============~n~p,module:~p,line:~p~n~s ~n===============~n~n~n", [calendar:local_time(), ?MODULE, ?LINE, lists:flatten(io_lib:format(Des, Values))])
%%                           ?Debug(debug_logger, "~s", [lists:flatten(io_lib:format(Des, Values))])
                        end).
-endif.


-ifdef(robot_rec).
-define(ROBOTSCRIPT(Action, Fun_Or_Args), catch robot_script:rec_script(Action, Fun_Or_Args)).

-else.
-define(ROBOTSCRIPT(Action, Fun_Or_Args), lib_util:void_fun(Action, Fun_Or_Args)).
-endif.



-define(TR(Des, Record), record_debug:print(Des, Record)).%打印记录信息 例如：TR("---------player_status:~p~n",Player_Status),


%% 多语言相关 -----------------------------------------------------------------------------------------------------------------
%% 程序中处理字符串Lang_Id:对应config_language中的参数,Para_List对应字符串中含有的占位符{X}从1开始
-define(Lang(Lang_Id, Para_List), lib_language:get_real_laguage_string(Lang_Id, Para_List)).

-define(language_chinese, 1). %语言定义 中文,这个数字有特别的意义,不要改变


%% json -----------------------------------------------------------------------------------------------------------------

%JSON
-define(ToJson(Term), ejson:encode(Term)).

%% 其他 -----------------------------------------------------------------------------------------------------------------


-ifdef(lv_limit).
-define(Player_Lv_Limit, 80).
-else.
-define(Player_Lv_Limit, 80).
-endif.

-define(Player_Sex_M, 1).               %%男
-define(Player_Sex_F, 2).               %%女

-define(Player_Career_1, 1).               %%梵灵
-define(Player_Career_2, 2).               %%斗神
-define(Player_Career_3, 3).               %%御仙

%价格类型
-define(Shop_Price_Type_Gold, 1).    %元宝
-define(Shop_Price_Type_Coin, 2).    %铜钱
-define(Shop_Price_Type_Guild_Contribute, 3).    %帮供
-define(Shop_Price_Type_Xianfa_Special_Practice, 4).    %紫晶琉璃果


-define(Login_Veryfy_Time_Out, 3600). %%登陆信息超时时间,单位秒




-define(DICT_PLAYERID, dict_player_id).
-define(DICT_PLAYER_SID, dict_player_sid).
-define(DICT_PLAYER_SOCKET, dict_player_socket).


-define(Money_Type_Coin, 1). %%玩家钱币类型:铜币
-define(Money_Type_Gold, 2). %%玩家钱币类型:元宝


%% 调用server(gen_fsm, gen_server)超时
-define(GEN_TIMEOUT, 10000).


-define(NONE, []). %不存在的宏定义

-define(Open_Function_Type_Talisman, 12). %% 功能开启 -- 法宝
-define(Open_Function_Type_Exercise, 10). %%功能开启 -- 历练
-define(Open_Function_Type_Athletics, 11). %% 功能开启 -- 竞技场
-define(Open_Function_Temple, 19). %% 功能开启  -- 九神殿


-define(Ets_Services_Time, ets_services_time). %% 定时服务执行时间表

%%-----------------------活动奖励状态提醒----------------------------------------
-define(Award_Remind_Athletics, 1). %%竞技场领取
-define(Award_Remind_Salary, 2). %%每日俸禄领取


%%-----------------------奖励状态------------------------------------------------
-define(Award_State_Able, 1). %%可领取
-define(Award_State_Already, 2). %%已领取


%%----------------------编译才修改的一些慢动态设置(属于配置,但是不太会改动)------------------------------------------------
-define(Turn_On_Visitor_Mode, 1).  %是否开启游客模式,0:否, 1:是


%%----------------------TGW包头------------------------------------------------
-define(TGW_HEADER, <<"tgw_l">>). % 字符个数对应包头长度





