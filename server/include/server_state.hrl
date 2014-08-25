%%%----------------------------------------------------------------------
%%% @copyright 2011
%%% @author q
%%% @des 服务器状态数据保存
%%%----------------------------------------------------------------------

-define(server_state_key_turntable_accmoney, 1). %奖池金额
-define(server_state_key_open_server_activity, 2). %开服活动服务器状态数据
-define(server_state_key_angel_overlord, 3). %谪仙台-霸主之战


-record(server_state, {
  id = 0,                  %常量key
  value_number = 0,        %数值
  value_complex = []       %复杂通用结构
}).



-define(save_interval, 1000 * 60 * 1).
-define(key_mod_player_save_interval_timer, key_mod_player_save_interval_timer).
