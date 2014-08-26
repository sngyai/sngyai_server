%%%----------------------------------------------------------------------
%%% @copyright 2011
%%% @author q
%%% @des 系统配置相关
%%%----------------------------------------------------------------------
-ifndef(system_config).
-define(system_config, true).


-define(ETS_SYSTEM_CONFIG, ets_system_config). %  系统配置ets表名定义
-define(ETS_TIME_ZONE_CONFIG, ets_time_zone_config). %  系统配置ets表名定义

-define(system_config_type_wallow, 1). %防沉迷,对应system_config表的id枚举,值作用,0:未开启,1:开启


%% 系统配置record
-record(system_config,
{
  id = 1,      %对应 上面的宏定义
  value = 0       %key决定了值是具体什么意义
}).





-endif. 

