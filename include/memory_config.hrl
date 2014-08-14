%%%-------------------------------------------------------------------
%%% @author sngyai
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. 八月 2014 下午3:57
%%%-------------------------------------------------------------------
-author("sngyai").

-ifndef(memory_config).
-define(memory_config, true).


-define(ETS_MEMORY_CONFIG, ets_memory_config). %  系统配置ets表名定义


-define(memory_config_type_service_open, 1). %服务是否开启,0否,1是,默认为1开启

%% 系统配置record
-record(memory_config,
{
    key = 1,      %对应 上面的宏定义
    value = 0       %key决定了值是具体什么意义
}).


-define(memory_config_value_service_closed, 0). %服务关闭
-define(memory_config_value_service_open, 1). %服务开启

-endif.

