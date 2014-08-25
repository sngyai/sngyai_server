%%全局错误号16位无符号整形,
%%消息号从1300开始,不要0~999不要占用,(0和1通常有特殊意义)
%% 错误信息宏命名使用首字母大写的方式

%%-----------账号相关---!本来该10段--------------------------
-define(OP_SUCCESS, 10000).%%全局操作成功消息号 | 恭喜您操作成功^!^
-define(Unknown_Error, 10001).  %% 未知错误 | 操作失败了55555,再试一次吧(⊙o⊙)
-define(Bad_Arg, 10002).  %% 错误的参数 | (⊙o⊙)客户端的妞给我发错货了!这事都被你碰上了,真没办法(⊙o⊙)

-define(Player_Nickname_Too_Short, 10003).%%玩家昵称太短
-define(Player_Nickname_Too_Long, 10004).%%玩家昵称太长
-define(Player_Nickname_Not_Valid, 10005).%%玩家昵称不可用
-define(Player_Nickname_Is_Exist, 10006).%%玩家昵称已存在
-define(Player_Create_Role_Fail, 10007).%%玩家角色创建失败
-define(Player_Role_Not_Is_Exist, 10008).%%玩家角色不存在
-define(Player_Dupllcated_Login, 10009).%%玩家异地登陆

-define(Login_Verify_Timeout, 10010). %%登陆信息超时
-define(Login_Verify_Fail, 10011). %%登陆验证失败

-define(Acc_Server_Wrong, 10012). %%平台编号或服务器索引错误

-define(Account_Had_Create_Role, 10013). %%平台账号已经创建角色
-define(Account_Create_Role_Acpid_Wrong, 10014). %%创建角色apcid参数错误
-define(Account_Role_Not_Exists, 10015). %%账号不存在

-define(Coin_Less_Than_Zero, 10016). %%铜币数量小于0
-define(Coin_Not_Enough, 10017). %%铜币不足
-define(Coin_Overload, 10018). %%铜币数量过多

-define(Gold_Less_Than_Zero, 10019). %%金币数量小于0
-define(Gold_Not_Enough, 10020). %%金币不足
-define(Gold_Overload, 10021). %%金币币数量小于0
-define(Strength_Not_Enough, 10022). %%体力值不足|体力不够了啦~

-define(Strength_No_Buy_Times, 10023). %%剩余购买次数不足
-define(Strength_Reach_Limit, 10024). %%体力已到达上限

-define(Too_Long_String, 10025).  %字符串超长
-define(Unavailable_String, 10026).  %非法字符串

-define(Worship_Times_Exhaust, 10027).  %祭拜次数不足
-define(Awaken_point_Not_Enough, 10028).  %参悟点不足

-define(Service_Closed, 10029).  %服务暂时不可用 | 服务器拥挤,稍后重试

-define(Player_Off_Line, 10030).  %玩家不在线

-define(Award_Had_Drawn_Yellowd_Main_Gift, 10031).  %你已经领取过会员专享礼包了哦！
-define(Server_Config_Err, 10032).  %服务器配置错误
-define(Tencent_Request_Fail, 10033).  %腾讯接口请求失败 | 远程调用失败
-define(Not_YellowD, 10034).  %当前非黄钻 | 您还不是黄钻用户，无法领取哦，如果确认已升级请刷新游戏！
-define(Not_Such_Award, 10035).  %奖励不存在
-define(Award_Had_Drawn_Yellowd_Gift_Such, 10036).  %你已经领取过奖励了哦！


-define(Award_Had_Drawn_First_Recharge_Gift, 10037).  %你已经领取过首充大礼包了哦！
-define(Never_Recharge, 10038).  %您还没有充值,无法领取奖励哦~
-define(Tencent_Buy_Request_Fail, 10039).  %请求失败,请稍后再试
-define(Tencent_Buy_Waiting_Timeout, 10040).  %请求超时,请稍后再试
-define(Tencent_Buy_Wrong_Interface_Cost_Gold, 10041).  %非腾讯服务器,接口调用错误 | 服务器配置错误
-define(Not_Open_Or_Continue_Yellow_Vip_In_Game, 10042).  %没有在我们游戏开通或者续费黄钻 | 只有在游戏内开通或者续费黄钻后才能领取哦
-define(Gain_Special_Employ_Yellowd, 10043).  %恭喜您成功获得黄钻专享伙伴

-define(LOGIN_FAIL_REASON_HACKER, 10060).  %外挂阻挡 | 小制作游戏，拒绝外挂,谢谢合作


-define(Open_Server_Activity_Had_Drawn, 10080).  %已领取此奖励 | 您已经领取过此奖励
-define(Open_Server_Activity_Cannot_Drawn, 10081).  %非可领取状态 | 您还不满足领取条件
-define(Open_Server_Activity_Activity_Overdue, 10082).  %活动已过期 | 活动已过期
-define(Open_Server_Activity_Had_Drawn_Today, 10083).  %今日已经领取 | 您今天已经领取过此奖励

-define(No_Tencent_Activity_Gold_Remain, 10100).  %您当前没有待领取的活动金币
-define(Tencent_Activity_Gold_Draw_Fail, 10101).  %领取活动金币失败,可能已超过今日限额,请明日再试或者联系管理员

-define(Login_Award_No_Can_Draw, 10120).  %当前没有可领取的奖励 | 您已经领取过此奖励,或者还未满足条件
-define(Level_Award_No_Can_Draw, 10121).  %当前没有可领取的奖励 | 您已经领取过此奖励,或者还未满足条件

-define(Offline_Gift_No_Can_Draw, 10140).  %当前没有可领取的奖励 | 您还不满足领取条件

-define(Delay_Strength_No_Can_Draw, 10160).  %当前没有可领取的体力 | 现在还不可以领取,请等待领取时间

-define(Delay_Goods_No_Goods, 10180).  %当前没有可领取的物品 | 没有可领取的物品

-define(Recharge_consume_finish, 10200).  %已经领取完了 | 您当前没有可领取的奖励
-define(Recharge_consume_no_can_draw, 10201).  %可领取的奖励已经领取完了 | 您当前没有可领取的奖励

%%-----------地图map相关--11段--------------------------
-define(Already_In_Target_Map, 11001). %%已经在目标场景中
-define(Level_Limit_Enter_Map, 11002). %%等级不满足进入目标场景
-define(Target_Map_Not_Exists, 11003). %%目标地图不存在
-define(Current_Map_Not_Exists, 11004). %%当前场景不存在
-define(No_Exists_To_Target_Map, 11005). %%不存在通向目标场景的传送门

-define(Monster_Template_Not_Exists, 11006). %%怪物数据不存在
-define(Map_Template_Not_Exists, 11007). %%地图数据不存在
-define(Map_Change_Wrongful, 11008). %%不允许从当前场景进入

-define(Monster_Dead, 11009). %%怪物已经死亡
-define(Monster_Is_In_Battle, 11010). %%怪物正在战斗中

%%-----------player 12-----------------------------
-define(Array_CanNot_Upgrade_ByLv, 12001).       %阵法等级不能大于大于人物等级
-define(Array_Location_CanNot_Upgrade_ByLv, 12002).       %阵法等级不能大于大于人物等级
-define(Xiuwei_Not_Enough, 12003).       %修为不足
-define(Relive_Player_Not_Died_State, 12004).       %玩家不是死亡状态 不需要复活
-define(Xianfa_CanNot_Modify_ByLv, 12005).       %仙法尚未开启
-define(Xianfa_CanNot_Common_Practice_ByLv, 12006).       %仙法等级不能大于大于人物等级
-define(Xianfa_Common_Practice_Not_Enough, 12007).       %人参果数量不足，无法修炼
-define(Xianfa_CanNot_Special_Practice_ByLv, 12008).       %仙法悟性已达到最大
-define(Xianfa_Special_Practice_Not_Enough, 12009).       %紫晶琉璃果不足，无法修炼
-define(Spirit_Tree_Full, 12010).       %请先收获元神！
-define(Spirit_Tree_Empty, 12011).       %没有可收获的元神
-define(Spirit_Chip_CanNot_Buy, 12012).       %元神碎片没有可购买次数
-define(Guild_Contribute_Not_Enough, 12013). %%家族贡献不足
-define(Player_Lv_Not_Enough, 12014). %%玩家等级不足 | 等级不足,请您抓紧升级哦~
-define(Apc_Run_CanNot_Buy_Times_ByDaily, 12015). %%今天的购买次数已用完
-define(Apc_Run_CanNot_Buy_Times_ByMax, 12016). %%神行次数已满99次，不能再增加了
-define(No_Award, 12017).  %%礼包不存在
-define(Award_Key_Wrong, 12018).  %% 礼包类型错误
-define(Already_Had_Same_Mount, 12019).  %% 你已经拥有这个坐骑了
-define(Have_No_Mount_Yet, 12020).  %% 该坐骑尚未激活


%%-----------item 13-----------------------------
-define(Item_Not_Exist, 13001).  %% 物品不存在
-define(Item_Num_Not_Enough, 13002).  %% 物品数量不足
-define(Item_Cannot_Throw, 13003). %% 物品不可丢弃
-define(Bad_Cell, 13004).       %物品位置不正确
-define(Not_Enough_Space, 13005).       %背包空间不足
-define(Item_CanNot_Equip, 13006).       %物品不可装备
-define(Item_CanNot_Equip_Here, 13007).       %物品不可装备在此
-define(Item_CanNot_Equip_ByCareer, 13008).       %该角色职业不能使用该物品|职业不符，不能穿戴哦
-define(Item_CanNot_Equip_ByLv, 13009).       %物品使用等级大于人物等级
-define(Item_IsNot_Equipment, 13010).       %物品不是装备
-define(Item_CanNot_Stren_ByLv, 13011).       %装备强化等级不能大于人物等级
-define(Item_CanNot_Compose, 13012).       %此装备不可合成
-define(Item_CanNot_UpgradeQuality, 13013).       %此装备不可提高品质
-define(Item_CanNot_RandomAttribute, 13014).       %此装备不可洗炼
-define(Can_Not_Change_Random_Attribute, 13015). %%洗炼信息超时
-define(Item_CanNot_Use_ByType, 13016).  %%物品不可被直接使用
-define(Item_CanNot_Use_ByLv, 13017).  %%物品使用等级大于人物等级
-define(Item_CanNot_Use_ByCareer, 13018).  %%你的职业不可使用该物品|您的职业不符，无法使用该物品
-define(Item_CanNot_Sell, 13019).  %%物品不可出售
-define(Already_Unlock_Storage, 13020).  %%仓库已解锁
-define(Not_Unlock_Storage, 13021).  %%仓库未解锁
-define(Not_Different_Type_Gem, 13022).  %%已镶嵌同类型宝石
-define(Not_Enough_Hole, 13023).  %%没有可镶嵌的孔|可镶嵌的孔已满

%%-----------apc 14-----------------------------
-define(APC_Not_Exist, 14001).   %伙伴不存在
-define(Max_APC_Num, 14002).   %队伍人数已满，无法加入！（可以使用“离队”功能，腾出空位）
-define(APC_Cannot_Employ_ByRalation, 14003).   %萍水相逢的伙伴不可邀请加入
-define(APC_Bad_Cell, 14004).   %格子信息不正确
-define(Main_APC_Bad_Team, 14005).   %主角不能离队
-define(Main_APC_Bad_Cell, 14006).   %主角不能下阵
-define(APC_Cannot_Send_Gift_ByTimes, 14007).   %今天的赠送次数已经用完了
-define(APC_Cannot_Send_Gift_ByRelation, 14008).   %生死不离的伙伴不需要赠送礼物了
-define(APC_Dialog_Not_Exist, 14009).   %对话不存在
-define(APC_Cannot_Talk_ByTimes, 14010).   %今天的聊天次数已经用完了
-define(APC_Cannot_Talk_ByRelation, 14011).   %这个伙伴已经与你生死不离了
-define(APC_Cannot_Run_ByTimes, 14012).   %神行次数已用完
-define(APC_Cannot_Run_ByColor, 14013).   %神行千里已经达成
-define(APC_Cannot_Treat_ByTimes, 14014).   %今天已没有可宴请次数
-define(APC_Cannot_Treat_ByCount, 14015).   %宴请人数错误|请添加宴请伙伴
-define(Max_Battle_APC_Num, 14016).   %参战人数已满
-define(APC_Cannot_Run_ByLv, 14017).   %提升等级才能继续神行
-define(APC_Already_Exist, 14018).   %伙伴已雇佣
-define(Max_APC_Drug, 14019).   %达到上限值就不能服用对应的仙丹了
-define(APC_Cannot_Extend_Self, 14020).   %自己不能传承给自己哦
-define(APC_Cannot_Extend_ByExp, 14021).   %只能由境界较高的伙伴传承给境界较低的伙伴
-define(APC_Cannot_Extend_More, 14022).   %有伙伴已经不能传承或被传承了，请仔细核对


%% ----------------------task 15-----------------------------
-define(Story_Not_Exist, 15001).  %% 剧情不存在
-define(Lv_Limit_Can_Not_Trigger_Story, 15002). %%等级不足，无法触发剧情
-define(Wrong_Story_Id_Can_Not_Trigger_Story, 15003). %% 剧情id不合法，无法触发剧情



-define(Task_UnComplete, 15004). %% 任务没有完成
-define(Task_Not_Exist, 15005).         %%任务不存在
-define(Is_Accepted, 15006).             %%已经接受此任务
-define(Level_Limit, 15007).             %%等级不足
-define(Faction_Not_Match, 15008).       %%阵营不符合
-define(Career_Not_Match, 15009).        %%职业不符合
-define(Priv_Task_Not_Finish_Can_Not_Trigger_Story, 15010). %% 前提任务没有完成，无法触发剧情
-define(Beyond_Repeat, 15011).           %%超出重复次数
-define(No_Can_Accepet_Task, 15012).     %%当前玩家不存在可接任务
-define(Not_In_Accepeted_List, 15013). %% 任务不在已接任务列表中
-define(Main_Task_Cannot_Abandon, 15014).     %%主线任务不能放弃
-define(Cannot_Delegate, 15015).  %% 任务不能委托
-define(Delegate_Times_Invalid, 15016).  %%委托任务次数不合法
-define(Is_Delegated, 15017).         %%任务已委托
-define(Task_Not_Delegate, 15018).    %%任务未委托
-define(Can_Not_Finish_Delegate_Task, 15019).    %%委托任务倒计时未结束，不能完成任务
-define(Out_Of_Do_Times_By_Circuit_Task, 15020).    %%超过当日跑环次数
-define(No_Player_Circuit_Task, 15021).    %%玩家跑环任务不存在
-define(Can_Not_Accept_Circuit_Task, 15022).    %%没有可接的跑环任务
-define(Not_Circuit_Task_Goods, 15023).    %%提交的物品不是所需的物品
-define(No_Exercise_Times, 15024).  %% 没有历练次数
-define(Has_Orange_Quallity, 15025). %%  已经是橙色品质的了，无需提升！


%% ---------------------- chat 16 ----------------------------
-define(CHANNEL_CHAT_CONTENT_OVERLOAD, 16001).  %%频道聊天内容超过最大限制
-define(CHANNEL_CHAT_CONTENT_CANNOT_BE_EMPTY, 16002).   %频道聊天内容不能为空
-define(CHANNEL_CHAT_CANNOT_MEET_INTERVAL, 16003).  %频道发言间隔不足|打字太快会累着哦，喝点水休息一下吧~

-define(PLAYER_NO_FACTION, 16004).  %玩家没有阵营
-define(PLAYER_NO_GUILD, 16005).    %玩家没有家族
-define(PLAYER_NOT_IN_TEAM, 16006). %玩家爱没有队伍

-define(UNKNOWN_CHANNEL_ID, 16007). %未知频道
-define(CANNOT_WHISPER_TO_YOURSELF, 16008). %不能向自己发送消息

-define(WHISPER_CHAT_CONTENT_OVERLOAD, 16009).  %私聊内容过长
-define(WHISPER_CHAT_CONTENT_CANNOT_BE_EMPTY, 16010).   %私聊内容不能为空
-define(TARGET_PLAYER_IS_OFFLINE, 16011).   %目标玩家不在线
-define(CANNOT_SEND_MSG_TO_BLACKLIST, 16012).   %不能向黑名单发送消息
-define(HAVENOT_JOIN_ANY_GUILD, 16013).     %你还没有加入任何家族哦
-define(PLAYER_CHANNEL_CHAT_BANNED, 16014). %你被禁言了

%% ---------------------- battle 17 ----------------------------
-define(Battle_Exception_Msg, 17001).  %%战斗异常错误号 | 您下手慢了^&^
-define(Battle_Req_Param_Exception_Msg, 17002).  %%战斗请求参数异常
-define(Battle_In_Cd_Time_Msg, 17003).   %%战斗冷却中
-define(Battle_No_Achieve_Lv_Msg, 17004).   %%未达到可战斗等级
-define(Battle_Not_Enough_Strength_Msg, 17005).   %%战斗体力值不够|体力不足，无法战斗哦~
-define(Battle_Not_Allow_Msg, 17006).   %%不被允许的战斗
-define(Battle_No_Apc_Msg, 17007).   %%没有伙伴战斗数据
-define(Battle_Monster_Do_Not_Fighting_Msg, 17008).   %%怪当前不能战斗
-define(Battle_Player_Died_Not_Fighting_Msg, 17009).   %%玩家死亡不能战斗 |
-define(Battle_Player_Not_Fighting_Self_Msg, 17010).   %%不能与自己发生战斗
-define(Battle_Player_In_Fighting_Msg, 17011).   %%玩家还在战斗中 不能发起战斗
-define(Battle_Player_Not_In_Same_Map_Msg, 17012).   %%战斗双方不在同一地图
-define(Battle_Monster_Not_Exists, 17013).   %%怪物已消失 | 怪物已逃之夭夭
-define(Global_Battle_File_Save_Error, 17020).   %%全局战斗文件保存异常

%% -------------------------------activity------------------------------
-define(Guild_Battle_Not_In_Applying_Time, 18001). % 报名时间不符：家族战报名已经截止！
-define(Guild_Battle_Guild_Not_Conform, 18002). % 家族条件不符：2级以上、排名100以内家族才能报名！
-define(Guild_Battle_Full, 18003). % 报名家族数已满，无法报名！
-define(Guild_Battle_Has_Apply, 18004). % 你的家族已经报名！
-define(Guild_Battle_No_Guild_Info, 18005). % 没有家族信息
-define(Guild_Battle_Not_In_Battle_Time, 18006). %% 未处于比赛时间段内，不能进入
-define(Guild_Battle_In_Insert_Flag, 18007).  %% 当前处于插旗状态
-define(Guild_Battle_No_Player_Data, 18008). %% 没有玩家家族战信息
-define(Guild_Battle_No_Times, 18009). %% 没有战斗次数了
-define(Same_Guild_Can_Not_Battle, 18010).  %% 同家族的不能发起战斗
-define(Not_In_Battle_Time, 18011). %% 比赛未开始
-define(Coin_Not_Enough_1000000, 18012). %% 身上铜币不足100万，还是留着过日子吧！
-define(Join_Guild_Less_Than_One_Hour, 18013). %% 加入家族不足一个小时，无法参加战斗！
-define(Insert_Flag_Success_In_Primary, 18014). %% 插旗成功！获得100贡献，100积分！其他家族—20积分！
-define(Cannot_Insert_Flag, 18015). %% 该区域不可插旗
-define(Insert_Flag_Success_In_Final, 18016). %% 插旗成功！获得100贡献，100积分！超过10000积分的其他家族-20积分！
-define(Guild_Battle_Not_In_Cd, 18017). %% 不在cd中
-define(Guild_Battle_Have_Battle_Times, 18018). %% 还有战斗次数，无需购买！
-define(Guild_Battle_Player_Die, 18019). %% 玩家死亡，不能插旗！

-define(Not_Exam_Time, 18050). %% 当前不是答题活动时间|当前不是答题活动时间，下次再答吧！
-define(Not_Exam_Player_Answer_State, 18051). %% 当前不是答题状态
-define(No_Exam_Info_Of_Player, 18052). %% 没有玩家答题信息 | 您还没有回答过一轮题目
-define(Exam_Player_Not_Finish, 18053). %% 玩家当前不是完成一轮状态 | 请先回答一轮题目
-define(Exam_Score_Award_Had_Drawn, 18054). %% 您今天已经领取过积分奖励
-define(Exam_Score_Award_Double_Limit, 18055). %% 已经达到最大倍数
-define(Exam_No_Chance, 18056). %% 没有答题机会 | 本次答题机会已用完
-define(Exam_Double_Suc, 18057).  %% 恭喜您翻倍成功！
-define(Exam_Double_Fail, 18058). %% 很遗憾翻倍失败，返还您一半金币

-define(Activity_Retrieve_No_Times, 18060). %% 当前没有可找回次数 | 此活动可找回次数已用完


%% ---------------------- talisman 19 ----------------------------
-define(Talisman_Not_Enough_Lv_Msg, 19001).         %%玩家没有达到激活等级|等级不够，没有办法激活法宝哦~
-define(Talisman_Not_Enough_Coin_Msg, 19002).       %%玩家钱币不足|铜币不足
-define(Talisman_Already_Activate_Msg, 19003).      %%法宝已经激活过
-define(Talisman_Not_Activate_Msg, 19004).          %%法宝未曾激活
-define(Talisman_Already_Max_Lv_Msg, 19005).        %%法宝已经达到最大等级
-define(Talisman_Not_Enough_Xiuwei_Msg, 19006).     %%玩家修为不够|修为不足
-define(Talisman_Already_Set_In_Battle_Msg, 19007). %%法宝已经设置出战

%% ---------------------- relation 20 --------------------------------
-define(PLAYER_NOT_EXIST_OR_OFFLINE, 20001).        %%玩家不存在或不在线
-define(ADD_FRIEND_REQUEST_TIMEOUT, 20002).         %%玩家好友请求已超时|时间太久，好友请求失效了啦
-define(ALREADY_SEND_MAKE_FRIEND_REQUEST, 20003).   %%好友请求已发送，请耐心等待
-define(PLAYER_RELATION_ALREADY_EXIST, 20004).      %和目标玩家已是好友，不要重复添加
-define(CANNOT_MAKE_FRIEND_WITH_YOURSELF, 20005).   %不能添加自己为好友
-define(PLAYER_FRIEND_COUNT_REACH_LIMIT, 20006).    %当前玩家好友数量达到上限|你的好友数量已经达到上限了
-define(TARGET_FRIEND_COUNT_REACH_LIMIT, 20007).    %目标玩家好友数量达到上限|对方的好友数量已经达到上限了
-define(PARTNER_ALREADY_IN_YOUR_BLACKLIST, 20008).  %目标玩家已在黑名单上
-define(CANNOT_ADD_YOURSELF_TO_BLACKLIST, 20009).   %不能将自己加入黑名单
-define(PLAYER_SPECIAL_FRIEND_COUNT_REACH_LIMIT, 20010).    %当前玩家特别好友超出上限
-define(PLAYER_BLACKLIST_COUNT_REACH_LIMIT, 20011). %当前玩家黑名单超出上限
-define(RELATION_NOT_EXIST, 20012).                 %关系不存在
-define(TODAY_DELETE_FRIEND_COUNT_REACH_LIMIT, 20013).  %当日可删除好友数量达到上限
-define(DATA_NOT_EXIST, 20014).     %数据已超时


%% ---------------------- pet 21 ----------------------------


-define(Pet_Not_Exist, 21001).  %% 宠物不存在
-define(Pet_CanNot_Throw_ByBattle, 21002).  %% 跟随的宠物不能放生
-define(Bad_Pet_Name, 21003).  %% 宠物名称不合法
-define(Bad_Pet_Name_Len, 21004).  %% 宠物名称长度不合法
-define(Pet_CanNot_Merge_ByBattle, 21005).  %% 跟随的宠物不能融合
-define(Pet_CanNot_Merge_ByNotSame, 21006).  %% 不同种类或不同品质的宠物都不允许融合
-define(Pet_Full, 21007).  %% 你携带的宠物已满！
-define(Pet_CanNot_LvUp_ByPlayer, 21008).  %% 宠物等级不能高于主人等级！


%% ---------------------- feature 22 玩家特色玩法 ----------------------------
-define(No_Player_Dungeon_Info, 22001).  %% 未找到玩家秘境信息
-define(Player_Dungeon_No_Reset_Times, 22002).  %% 没有重置次数
-define(Player_Dungeon_No_Need_Reset, 22003).  %% 秘境不需要重置
-define(Player_Dungeon_Finished_All_Mission, 22004).  %% 秘境已经完全通关
-define(Player_Dungeon_Mission_Info_Not_Exist, 22005).  %% 关卡数据不存在

-define(CANNOT_REACH_TARGET_POSITION, 22006).   %% 超出合法移动距离
-define(OUT_OF_RANGE, 22007).   %%超出合法移动范围（目标格子不在九宫格内）
-define(CANNOT_MOVE_TO_TARGET_POSITION, 22008). %%无法移动到目标格子
-define(TODAY_BOUGHT_STEPS_OVERFLOW, 22009).    %%超出当日可购买步数

-define(Card_Num_Not_Exists, 22010).    %%您输入的序列号无效，请仔细核对是否输入正确
-define(Card_Num_Used, 22011).    %%您输入的序列号已经被兑换过了 | 这个序列码已经使用过了，请仔细核对
-define(Player_Used_This_Type_Card, 22012).    %%您已经领取过此礼包了哦
-define(Card_Type_Exists, 22013).    %%卡类型错误|您输入的序列号无效，请仔细核对是否输入正确

-define(All_Award_Reward, 22014).    %%已领取所有奖励
-define(Online_Time_Not_Enough, 22015).    %%在线时间不足

-define(Today_Salary_Claimed, 22016).    %%今日俸禄已领取

-define(Already_Get_All_Liveness_Award, 22017).         % 已经领取所有活跃度奖励
-define(Liveness_Is_Not_Enough, 22018).                      % 当前活跃度不足以领取奖励

-define(Buffer_Not_Exists, 22019).                      % buffer不存在|没有这个状态啦！
-define(Cannot_Append_Buffer_For_Repel, 22020).         % 不能添加当前buffer因为互斥|已经有一个更加强大的BUFF了
-define(Buffer_Info_Not_Exists, 22021).         % buffer不存在
-define(Not_World_Boss_Time, 22022).         % 当前不是世界boss活动时间
-define(Buffer_Reach_Max, 22023).         % 已到最大等级

-define(Zazen_Not_Open, 22024).         % 打坐未开启
-define(Zazen_No_Time, 22025).         % 今天的打坐时间已用完
-define(Player_In_Zazen, 22026).         % 玩家打坐中
-define(Current_Map_Cannot_Zazen, 22027).         % 当前地图不能打坐|当前地图不能打坐，去主城里打坐吧！

-define(Player_had_favorite_gift, 22028).         % 您已经领取过礼包

-define(Player_Not_Enough_Lv_For_Draw, 22040).         % 您还不满足领取等级
-define(There_Is_No_Many_Card, 22041).         % 卡号领取完了 | 已经没有更多卡号可领取了


-define(Player_Sweeping_Dungeon, 22060).         % 正在扫荡中...
-define(Player_Not_Sweeping_Dungeon, 22061).         % 当前不在扫荡中
-define(Player_Not_Clear_Cnnot_Sweeping_Dungeon, 22062).         % 此秘境未通关还不能扫荡
-define(Player_Not_Find_Sweeping_Dungeon_Mission, 22063).         % 未找到扫荡关卡数据 | 此秘境未通过还不能扫荡
-define(Player_No_Bag_Cannot_Sweeping_Dungeon, 22064).         % 背包没有空间不能扫荡

-define(Not_Daily_Invite_Cannot_Draw, 22080).         % 您今日还未邀请好友,不能领取,赶快行动哦
-define(Had_Draw_Daily_Invite_Award, 22081).         % 您今日已经领取过奖励了哦,明日再来吧,亲
-define(Had_Invited_Please_Draw_Award, 22082).         % 感谢您再次邀请,赶快领取奖励吧,亲❤
-define(Had_Draw_Tks_For_More_Invite, 22083).         % 感谢您再次邀请,:-D


-define(MINE_LV_TO_LOW, 22101).                     %% 等级不足，请开采低级矿点
-define(MINE_LIVEPOINE_NOT_ENOUGH, 22102).          %% 活跃点不足
-define(MINE_ID_DOES_NOT_EXIST, 22103).             %% 矿点不存在
-define(MINE_TYPE_DOES_NOT_EXIST, 22104).           %% 矿点TYPE不存在 | 矿点不存在
-define(MINE_BAG_NO_SPACE, 22105).                  %% 背包空间不足
-define(MINE_PLAYER_IN_MINE, 22106).                %% 正在采矿中
-define(MINE_NOT_IN_RIGHT_MAP, 22107).              %% 玩家与矿点不在同一地图内 | 请至矿点采集
-define(MINE_PLAYER_FAR_FROM_MINE, 22108).           %% 玩家不在矿点附近 | 请至矿点采集
-define(MINE_PLAYER_IN_BATTLE, 22109).               %% 玩家在战斗中不能采矿 | 正在战斗中
-define(MINE_NOT_OPEN, 22110).                      %% 采集功能未开放 | 功能未开放

-define(Unclaimed_goods_no_goods, 22120).           %% 当前没有可领取物品 | 您已经领取了所有可领取物品
-define(Unclaimed_goods_delete_fail, 22121).           %% 删除失败 | 领取失败,请稍后再试

%% ---------------------- athletics 23 竞技场相关 ----------------------------
-define(Not_Athletics_Times, 23001).  %% 没有挑战次数
-define(Out_Of_Range_Challenge, 23002).  %% 超出挑战范围
-define(Not_Authority_Can_Buy_Times, 23003).  %% 没有权限购买挑战次数
-define(Not_Can_Buy_Times, 23004).  %% 剩余购买次数不足
-define(Not_Can_Draw_Athletics_Award, 23005).  %% 奖励已领取过了|今天的奖励已经领取过了，明天再来吧~
-define(Not_Has_Athletics_Info, 23006).  %% 没有玩家竞技信息
-define(Unopened_Athletics_Function, 23007).  %% 竞技场未开放 功能未开启


%% ---------------------- spirit 24 ----------------------------


-define(Spirit_Not_Exist, 24001).       %元神不存在
-define(Spirit_Bag_Not_Enough_Space, 24002).       %元神背包空间不足
-define(Spirit_Chip_Not_Enough, 24003).       %元神碎片不足
-define(Spirit_53_CanNot_Merge, 24004).       %醍醐灌顶不可以互相吞噬
-define(Spirit_CanNot_Merge_ByLv, 24005).       %已经达到最高等级
-define(Spirit_53_CanNot_Equip, 24006).       %醍醐灌顶不可以装备
-define(Spirit_CanNot_Equip_BySameType, 24007).       %已装备同类型元神
-define(Spirit_CanNot_Equip_ByFull, 24008).       %已到达装备上限


%------------------------- guild 25 ----------------------------


-define(Exist_Guild_Name, 25001).%帮会名已存在|家族名称已经存在，请重新输入
-define(Jioned_Guild_Already, 25002).%已经加入家族
-define(Guild_Not_Exist, 25003).%家族已解散或不存在
-define(Cannot_Set_Self, 25004). %不能提升自己
-define(Max_Member, 25005). %已达到人数上限
-define(Already_Apply, 25006). %已经申请过该家族
-define(Have_No_Guild, 25007). %尚未加入家族
-define(Have_No_Power, 25008). %您没有权限
-define(Not_Enough_Guild_Level, 25009).  %家族等级不够|家族等级不够
-define(Not_Enough_Guild_Money, 25010).  %家族资金不足|家族资金不足
-define(Guild_Leader_Already, 25011).  %你已经是族长
-define(Guild_Leader_7_Day, 25012).  %族长离线未超过7天
-define(Guild_Same_Position, 25013).  %`修改职务成功
-define(Guild_Player_Lv_Limit, 25014).  %创建或加入家族等级不足|等级不足
-define(Guild_Apply_Not_Exist, 25015).  %家族申请不存在
-define(Not_Guild_Member, 25016). %不是本家族成员
-define(Leader_Cannot_Leave_Guild, 25017). %族长不允许退出家族
-define(Max_Ass_Leader, 25018). %长老人数已满
-define(Bad_Guild_Position, 25019). %错误的职位
-define(Jion_Guild_5_Day, 25020). %进入家族未满5天
-define(Already_3_Apply, 25021). %已申请过3个家族
-define(Already_Sign_In, 25022). %今日已签到
-define(Cannot_Get_Gift, 25023). %当前礼包不可领取
-define(Cannot_Set_Self_ByLeader, 25024). %族长离线未满7天
-define(Cannot_Set_Self_ByAssLeader, 25025). %还有长老离线未满7天
-define(Guild_Name_Empty, 25026). %家族名不能为空
-define(Cannot_Leave_Guild_ByBattle, 25027). %家族战已报名及进行中不能离开家族
-define(Cannot_Upgrade_Boss_ByWarTime, 25028). %家园攻防战期间不能升级家园守卫
-define(Cannot_Disband_Guild_ByWarTime, 25029). %现在是家园攻防战期间，不能加入、离开家族
-define(Not_In_Normal_Map_Cannot_Enter_Guild_HQ, 25030).  %你不在虚冥城，不能进入家园！
-define(Cannot_Upgrade_Boss_ByLv, 25031). %家园BOSS已到最大等级
-define(Cannot_Enter_Other_Guild_HQ, 25032).  %现在不能进入其他家族的家园！
-define(Cannot_Contribute_Guild_ByTime, 25033).  %加入家族不满24小时，还不能捐献哦
-define(Cannot_Contribute_Guild_ByTimes, 25034).  %今日已捐献


%------------------------- peon 26 ----------------------------
-define(CATCH_PEON_TIME_REACH_MAX, 26001).          %已有抓捕次数，不可再买
-define(BUY_CATCH_PEON_TIME_REACH_LIMIT, 26002).    %当日购买抓捕次数达到上限
-define(TARGET_IS_ALREADY_PEON, 26003).             %该玩家已被抓捕|这个玩家已经被抓捕了，换一个试试吧~
-define(CATCH_PEON_LAST_TIME_NOT_ENOUGH, 26004).    %剩余抓捕次数不足|你没有抓捕次数了
-define(YOU_CANNOT_CATCH_THIS_PEON, 26005).         %不在玩家可抓捕范围内


%------------------------- duplicate 27 ----------------------------

-define(Player_Already_In_Multi_Dungeon_Team_Cannot_Create, 27001).  %已经在队伍中，不能创建队伍
-define(Not_In_Normal_Map_Cannot_Join_Multi_Dungeon_Team, 27002).  %你不在虚冥城，不能加入多人秘境队伍！
-define(Level_Not_Fit_Multi_Dungeon, 27003).  %等级不符合要求
-define(Current_Multi_Dungeon_Cding, 27004).  %该秘境今日已通关！
-define(Multi_Dungeon_Not_Open, 27005).  %当前不是多人秘境活动时间|多人秘境活动已经结束啦！
-define(Multi_Dungeon_Not_Exists, 27006).  %队伍已开战，加入失败。
-define(Not_In_Multi_Dungeon_Team, 27007).  %没有队伍
-define(Not_Multi_Dungeon_Team_Leader, 27008).  %您不是队长不能操作
-define(Not_Multi_Dungeon_Map, 27009).  %您当前不在多人秘境场景中
-define(Multi_Dungeon_Duplicate_Not_Alive, 27010).  %秘境副本不存在
-define(Multi_Dungeon_Duplicate_Achieved, 27011).  %秘境副本已完成
-define(Duplicate_Target_Monster_Not_Exists, 27012).  %目标怪物不存在|怪物已经被击杀啦！
-define(Player_And_Target_Different_Map, 27013).  %目标不在当前场景
-define(Player_Not_In_Multi_Dungeon, 27014).  %玩家当前不在多人秘境中
-define(Player_Not_In_Injury, 27015).  %您当前不是重伤状态
-define(Player_In_Injury_Cannot_Battle, 27016).  %您当前是重伤状态请先疗伤|你处于濒死状态，请用右上方的“复活”按钮重新进入战斗！
-define(Multi_Dungeon_Duplicate_Team_Full, 27017).  %队伍人数已满
-define(Multi_Dungeon_Now_Multi_Conquest, 27018).  %多人征战中不能进行多人秘境 | 您当前正在参与多人征战

%% ---------------------- angel overlord 29 谪仙台相关 ----------------------------
-define(Angel_Overlord_Buy_Times_Success, 29000).  %% `购买挑战次数成功|购买挑战次数成功
-define(Angel_Overlord_Not_Times, 29001).  %% 没有挑战次数
-define(Angel_Overlord_Not_Can_Buy_Times, 29002).  %% 剩余购买次数不足
-define(Angel_Overlord_Not_Overlord_Info, 29003).  %% 没有霸主信息
-define(Angel_Overlord_Not_Lv_Limit, 29004).  %% 玩家等级不够
-define(Angel_Overlord_Not_Athletics_Rank_Limit, 29005).  %% 玩家竞技场排名未达到要求 200名以内
-define(Angel_Overlord_Overlord_Died, 29006).  %% 目标霸主已死亡|擂主已经被击败
-define(Angel_Overlord_Overlord_In_Battle, 29007).  %% 目标霸主正在战斗中|擂主正在战斗中
-define(Angel_Overlord_Not_In_Doing, 29008).  %% 活动不在进行期间|活动不在进行期间，明天再来吧
-define(Angel_Overlord_Not_In_Cd, 29009).  %% 霸主之战不在冷却中
-define(Angel_Overlord_Permission_Denied, 29010).  %% 没有达到开启权限要求 等级不够 | 你的竞技排名不够
-define(Angel_Overlord_Cancel_CD_Success, 29050).  %% `消除战斗CD成功|消除战斗CD成功
-define(Angel_Overlord_Logout_Success, 29051).  %% `注销谪仙台系统成功
-define(Angel_Overlord_Not_Partake_Challenge, 29052).  %% 霸主自己不能参与挑战|擂主自己不能参与挑战

%% ------------------------------------仙域之战----------------------------------------------
-define(Not_In_Activity_Time, 30001). %% 不在活动时间
-define(No_Camp, 30002). %% 请选择阵营

%% ------------------------------------九神殿------------------------------------------------
-define(Temple_Already_Open_Temple, 31001).%九神殿已经开启过
-define(Temple_Open_Fun_Lv_Limit, 31002).%玩家等级未达到开启限制|等级不足，还不能挑战哦~
-define(Temple_Invalid_Battle_Challenge, 31003).%无效的攻关挑战
-define(Temple_Bad_Record_Info, 31004).%无效的基础关卡信息
-define(Temple_Not_Enough_Strength, 31005).%体力不足

%% ----------------------------------晋神之战-------------------------------------
-define(Has_In_Team, 32001). %% 已经有队伍了，不能创建队伍！
-define(Has_Join_War, 32002). %% 已经参加晋神之战了，不能重新组队！
-define(Team_Not_Exist, 32003). %% 队伍不存在
-define(Team_Num_Full, 32004). %% 队伍人数已满
-define(No_Jin_God_Player_Info, 32005). %% 没有晋神之战玩家信息
-define(Not_Team_Leader, 32006). %% 不是队长无法进行此操作
-define(Team_Member_Not_Enough, 32007). %% 队伍人数不足
-define(No_team, 32008). %% 没有队伍
-define(Not_In_Same_Team, 32009). %% 不在同一队伍
-define(No_This_Player, 32010). %% 没有该apc
-define(Has_In_This_Team, 32011). %% 已经在该队伍中！
-define(In_Same_Team_Cannot_Battle, 32012). %% 在同一队伍中，不能战斗！
-define(Lv_Difference_Too_Big, 32013). %% 等级差距大于15级，不能发起战斗！
-define(Not_All_Ready, 32014). %% 有队员没有准备！
-define(Player_Not_In_Battle_Scene, 32015). %% 该区域不可战斗！
-define(Can_Not_Kick_Out_Self, 32016). %% 不能踢出自己！
-define(Not_In_Normal_Map_Cannot_Join_Jin_God_Team, 32017). %% 不在普通场景，不能加入晋神之战队伍！
-define(Cell_Wrong, 32018). %% 位置不合法！
-define(Jin_God_Team_Disband, 32019). %% 队伍已解散!
-define(Jin_God_Be_Kick_Out, 32020). %% 你被踢出了队伍!
-define(Jin_God_Full_Hp, 32021). %% 满血，无需恢复！
-define(Jin_God_Has_In_Battle_Scene, 32022).  %% 已经在战斗区域！
-define(Jin_God_Die, 32023). %% 玩家已死亡！
-define(Jin_God_Now_Multi_Conquest, 32024). %%  多人征战中不能进行晋神之战 | 您当前正在参与多人征战
-define(Jin_God_Battle_Times_limit, 32025). %%  晋神之战战斗场数达到最大限制无法进入|你的战斗次数已满，下次活动再来吧
-define(Jin_God_Battle_TarPlayer_Times_limit, 32026). %%  对方战斗次数已满|对方战斗次数已满，换个人点吧

%% ----------------------------------家族守卫战-------------------------------------
-define(Guild_Defend_War_Can_Not_Battle_ByTime, 33001). %% 家族守卫战活动已结束
-define(Guild_Defend_War_Can_Not_Battle_ByBossDead, 33002). %% BOSS已死，不能执行此操作
-define(Guild_Defend_War_Can_Not_Battle_ByGuild, 33003). %% 家族成员不能进攻BOSS
-define(Guild_Defend_War_Can_Not_Battle_ByTimes, 33004). %% 没有可战斗次数
-define(Guild_Defend_War_Can_Not_Battle_ByScene, 33005). %% 您不在家族守卫战场景
-define(Guild_Defend_War_Can_Not_Battle_ByGuildMember, 33006). %% 家族成员不能互相进攻
-define(Guild_Defend_War_Can_Not_Battle_ByTimes2, 33007). %% 对方没有可战斗次数
-define(Guild_Defend_War_Can_Not_Battle_BySide, 33008). %% 您不是家族守卫不能发起战斗
-define(Guild_Defend_War_Can_Not_Buy_ByTimes, 33009). %% 没有可购买次数

-define(Guild_Pet_Can_Not_Create_ByMax, 33010). %% 已到达最大放养萌兽个数
-define(Guild_Pet_Not_Exist, 33011). %% 萌兽不存在
-define(Guild_Pet_Can_Not_Feed_ByGuild, 33012). %% 只能喂养本家族的萌兽
-define(Guild_Pet_Can_Not_Feed_ByState, 33013). %% 只能喂养饥饿的萌兽
-define(Guild_Pet_Can_Not_Feed_ByTimes, 33014). %% 今日可喂养次数已用完
-define(Guild_Pet_Can_Not_Delete_ByOwner, 33015). %% 只能投放你自己的萌兽|这只萌兽已经成年，不需要喂养啦！
-define(Guild_Pet_Can_Not_Delete_ByState, 33016). %% 只能投放已成年的萌兽
-define(Guild_Pet_Can_Not_Own_ByLv, 33017). %% 没有达到诱拐等级
-define(Guild_Pet_Can_Not_Own_ByTime, 33018). %% BOSS未死不能诱拐
-define(Guild_Pet_Can_Not_Own_ByScene, 33019). %% 您不在家园后院
-define(Guild_Pet_Can_Not_Own_ByCD, 33020). %% 诱拐CD中
-define(Guild_Pet_Own_Fail, 33021). %% 诱拐失败！
-define(Guild_Pet_Can_Not_Create_ByTime, 33022). %% 家族守卫战活动期间不能放养萌兽


-define(Guild_Pet_Market_Can_Not_Buy_ByCirculation, 33022). %% 没有流通量不能购买
-define(Guild_Pet_Market_Can_Not_Sell_ByStorage, 33023). %% 存量不足
-define(Guild_Pet_Market_Can_Not_Trade_ByTimes, 33024). %% 今日的交易次数已用完
-define(Guild_Pet_Market_Can_Not_Trade_ByTime, 33025). %% 萌兽市场已经休市
-define(Guild_Pet_Market_Can_Not_Trade_ByCount, 33026). %% 交易数量有误


%%--------------------------------儿童节活动-------------------------------------
-define(OPEN_MECHANISM_TIMES_REACH_LIMIT, 34001).      %%开启机关次数达到上限|你今天已经开过5次机关啦！
-define(OPEN_TREASURE_TIMES_REACH_LIMIT, 34002).        %%开启宝箱次数达到上限|你今天已经开过50次宝箱啦！
-define(TREASURE_NOT_FOUND, 34003).                     %%宝箱不存在|宝箱被别人抢先一步打开了，再去找找别的宝箱吧
-define(ALREADY_KILLED_CHILDRENS_MONSTER, 34004).       %%你今天已经击杀过儿童节萌兽啦！
-define(CHILDRENS_DAY_NOT_OPENED, 34005).               %%儿童节活动尚未开启
-define(ALREADY_EXIST_DROP_TREASURE, 34006).            %%还有宝箱存在，不能开启机关哦~再去找找吧

%%--------------------------------端午节活动-------------------------------------
-define(DRAGON_BOAT_FESTIVAL_NOT_OPENED, 34007).        %%端午节活动尚未开启
-define(CANNOT_OPEN_MECHANISM_DURING_MONSTER_ATTACK, 34008).    %怪物进村活动期间不能开启机关
-define(ALREADY_EXIST_DROP_MONSTER, 34009).             %%水妖入侵正在进行中，不能开启机关
-define(KILL_MONSTER_COUNT_REACH_LIMIT, 34010).         %%你今天已经击杀50次水妖啦！


%% ---------------------------------虚冥幻境------------------------------
-define(Unreal_Not_Exist, 35001). %% 幻境不存在
-define(Unreal_Lv_Not_Enough, 35002). %% 等级不够
-define(Unreal_Not_Active, 35003). %% 幻境未激活
-define(Unreal_Star_Limit, 35004). %% 星级不够
-define(Has_get_gift, 35005). %% 今日已经领取过礼包了
-define(Unreal_In_Cd, 35006). %% cd中不能邀请
-define(No_Unreal_Gift, 35007). %% 没有星级对应的礼包


%% ---------------------------------多人征战------------------------------
-define(ALREADY_IN_MULTI_CONQUEST_TEAM, 36001).         %已有队伍
-define(CANNOT_CREATE_TEAM_WHEN_JIN_GOD_WAR, 36002).    %晋神之战组队中，不能创建队伍
-define(CANNOT_CREATE_TEAM_WHEN_MULTI_DUNGEON, 36003).  %多人秘境组队中，不能加入队伍
-define(MULTI_CONQUEST_TEAM_NOT_EXIST, 36004).          %队伍不存在|这个队伍已经不存在了，找找别的队伍吧
-define(MULTI_CONQUEST_TEMPLATE_NOT_EXIST, 36005).      %征战副本参数错误
-define(TEAM_IS_IN_CONQUEST, 36006).                    %无法加入队伍
-define(TEAM_MEMBERS_REACH_LIMIT, 36007).               %队伍已满员
-define(LV_NOT_ENOUGH_FOR_MULTI_CONQUEST, 36008).       %等级不足
-define(NOT_MULTI_CONQUEST_TEAM_LEADER, 36009).         %不是队长|你不是队长，只有队长才能带领队伍进入下一关
-define(MEMBER_STRENGTH_NOT_ENOUGH, 36010).             %有队员体力不足
-define(MEMBER_MAP_NOT_NORMAL, 36011).                  %有队员不在常规场景
-define(NOT_IN_NORMAL_MAP, 36012).                      %不在常规场景
-define(CANNOT_GET_AWARD, 36013).                       %你没有领取奖励的资格
-define(AWARD_TIME_OUT, 36014).                         %奖励已超时
-define(YOU_HAVE_DEAD_CANNOT_MOVE, 36015).              %你已经死亡，5秒后将自动复活
-define(ALREADY_THE_LAST_MISSION, 36016).               %已经是最后一关了
-define(ALREADY_INVINCIBLE, 36017).                     %已经是无敌状态了|您现在已经是无敌状态了
-define(TEAM_NOT_IN_CONQUEST, 36018).                   %队伍不在征战中
-define(PROP_NOT_EXIST, 36019).                         %道具不存在
-define(PROP_NOT_ACTIVATED, 36020).                     %道具未激活
-define(CANNOT_REMOVE_YOURSELF, 36021).                 %不能移除自己
-define(TEAM_MEMBER_NOT_EXIST, 36022).                  %队员不存在
-define(HAVE_NOT_CLEAR_CONQUEST_MONSTER, 36023).        %当前场景怪物尚未清除|还有怪物没杀，不能进入下一关哦
-define(MEMBER_HAVENOT_GET_AWARD, 36024).               %还有队员尚未领取奖励
-define(CANNOT_GET_INVINCIBLE_WHEN_DYING, 36025).       %濒死状态不能无敌
-define(CANNOT_BATTLE_WHEN_DYING, 36026).                %濒死状态不能战斗
-define(CANNOT_GET_AWARD_WHEN_DYING, 36027).            %濒死状态不能获得奖励


















