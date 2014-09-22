%%%==============================================================================
%%% Author      :fangjie008@163.com
%%% Created     :2012-6
%%% Description :des
%%%==============================================================================
-module(lib_config).

-define(APP, server).

-export([
  init_ensure_config/0,

  get_tcp_listener/0,
  get_mysql_config/0,
  get_server_log/0,
  get_server_contain/0,

  get_ticket/0,
  get_battle_file_dir/0,
  get_global_battle_file_dir/0,
  get_language/0,
  get_webserver_port/0,

  get_acc_id/0,
  get_server_id/0,
  get_subsection_min/0,
  get_subsection_max/0,
  get_server_type/0,

  get_start_server_timestamp/0,
  get_vm_memory_high_watermark/0,

  get_server_domain_name/0,
  is_tencent_server/0
]).

% 从新加载.app数据到内存
-export([reload_app_config_safe/0]).

%% 启动服务的时候就检查全部信息是否正确
%% 防止启动服务的时候不需要的参数但是在用到的时候却没有
%% 所有需要使用的变量都需要在这里调用一下
%% check_config() -> ok |throw(ex)
init_ensure_config() ->
  get_tcp_listener(),
  get_mysql_config(),
  get_server_log(),
  get_server_contain(),
  get_ticket(),
  get_language(),
  get_webserver_port(),

  get_acc_id(),
  get_server_id(),
  get_subsection_min(),
  get_subsection_max(),
  get_server_type(),
  get_start_server_timestamp(),
  get_vm_memory_high_watermark(),
  ok.


%% 获取application的配置信息-监听信息
%% 正常返回值:{ip, port}
get_tcp_listener() ->
  case application:get_env(?APP, tcp_listener) of
    {ok, false} -> throw(tcp_listener_undefined);
    {ok, Tcp_listener} ->
      try
        {_, Ip} = lists:keyfind(ip, 1, Tcp_listener),
        {_, Port} = lists:keyfind(port, 1, Tcp_listener),
        {Ip, Port}
      catch
        _:_ -> exit({bad_config, {server, {tcp_listener, config_error}}})
      end;
    undefined -> throw(tcp_listener_undefined)
  end.

%% 获取application的配置信息-数据库信息
%% 正常返回值:{Host, Port, User, Password, Database, Encode, Pool_size};
get_mysql_config() ->
  case application:get_env(?APP, mysql_config) of
    {ok, false} -> throw(undefined);
    {ok, Mysql_config} ->
      {_, Host} = lists:keyfind(host, 1, Mysql_config),
      {_, Port} = lists:keyfind(port, 1, Mysql_config),
      {_, User} = lists:keyfind(user, 1, Mysql_config),
      {_, Password} = lists:keyfind(password, 1, Mysql_config),
      {_, Database} = lists:keyfind(database, 1, Mysql_config),
      {_, Pool_size} = lists:keyfind(pool_size, 1, Mysql_config),
      {Host, Port, User, Password, Database, utf8, Pool_size};
    undefined -> throw(get_mysql_config_undefined)
  end.


%% 获取server_log的配置信息-服务日志信息
%% 正常返回值:{Dir, File, Suffix}
get_server_log() ->
  case application:get_env(?APP, server_log) of
    {ok, false} -> throw(server_log_undefined);
    {ok, Server_log} ->
      try
        %list_to_tuple([proplists:get_value(Type, Server_log)|| Type <- [dir, file, suffix]])
        {_, Dir} = lists:keyfind(dir, 1, Server_log),
        {_, File} = lists:keyfind(file, 1, Server_log),
        {_, Suffix} = lists:keyfind(suffix, 1, Server_log),
        {Dir, File, Suffix}
      catch
        _:_ -> exit({bad_config, {server, {server_log, config_error}}})
      end;
    undefined -> throw(server_log_undefined)
  end.

%% 当前服务器包含的服列表
%% 返回值:[{平台编号,服索引}]
get_server_contain() ->
  case application:get_env(?APP, server_contain) of
    {ok, false} ->
      throw(server_server_contain);
    {ok, Server_contain} ->
      Server_contain;
    undefined ->
      throw(server_log_undefined)
  end.

%% 获取application的配置信息-登陆ticket
%% 返回值:实际登陆ticket
get_ticket() ->
  case application:get_env(?APP, ticket) of
    {ok, Ticket} -> Ticket;
    _ -> throw(ticket_undefined)
  end.

%% 获取语种
%% 返回值:当前服的语种
get_language() ->
  case application:get_env(?APP, language) of
    {ok, Language} -> Language;
    _ -> throw(language)
  end.

%% 获取后台服务使用端口
%% 返回值:端口号
get_webserver_port() ->
  case application:get_env(?APP, webserver_port) of
    {ok, Webserver_port} -> Webserver_port;
    _ -> throw(language)
  end.


%%TEST

%get_acc_id() ->
%    io:format("get_acc_id~n"),
%    1 .
%%% 获取服唯一ID
%get_server_id() ->
%    io:format("get_server_id~n"),
%    1 .
%%% 获取分段值
%get_subsection_val() ->
%    io:format("get_subsection_val~n"),
%    7 .

%%TEST

%% 获取平台唯一ID 区间：平台ID(1-45)
get_acc_id() ->
  case application:get_env(?APP, acc_id) of
    {ok, Acc_Id} -> if Acc_Id > 0 andalso Acc_Id =< 89 -> Acc_Id; true -> throw("acc_id id overflow!") end;
    _ -> throw(acc_id)
  end.
%% 获取服唯一ID 区间：服ID(1-9999)
get_server_id() ->
  case application:get_env(?APP, server_id) of
    {ok, Server_Id} ->
      if Server_Id >= 0 andalso Server_Id =< 9999 -> Server_Id; true -> throw("server id overflow!") end;
    _ -> throw(server_id)
  end.
%% 获取分段值 开发用 支持1-99区间 正式服此值必须配置为 0
get_subsection_val() ->
  case application:get_env(?APP, subsection) of
    {ok, Subsection} -> Subsection;
    _ -> 0
  end.

%%%	系统ID管理服务，服务启动时首先从数据库中初始化当前表中最大ID值，运行中在此基础上递增,作为数据记录的唯一ID
%%% 动态ID = 平台ID(1-45)*100000000000000 + 服ID(1-9999)*10000000000 + 增长ID(1-9999999999)
%%% 平台ID(1-45)  服ID(1-9999)   动态ID增长区间为100亿
%%% 支持45个平台  9999个服  100亿个动态ID
%% 获取分段ID下限
get_subsection_min() ->
  Min = get_acc_id() * 100000000000000 + get_server_id() * 10000000000 + get_subsection_val() * 100000000,
  Min.

%% 获取分段ID上限
get_subsection_max() ->
  Max = case get_subsection_val() of
          0 ->
            get_acc_id() * 100000000000000 + get_server_id() * 10000000000 + 9999999999;%正式服动态ID增长区间为100亿
          SubsectionVal ->
            % SubsectionVal: 分段值 开发用 支持1-99区间 正式服此值必须配置为 0  给每个开发调试小段给一个亿动态ID范围
            get_acc_id() * 100000000000000 + get_server_id() * 10000000000 + SubsectionVal * 100000000 + 99999999
        end,
  Max.

%% 获取服务器类型
get_server_type() ->
  case application:get_env(?APP, server_type) of
    {ok, Server_Type} -> Server_Type;
    _ -> throw(server_type)
  end.


%% 获取application的配置信息-战斗脚本文件存放目录
%% 返回值:目录位置
get_battle_file_dir() ->
  case application:get_env(?APP, battle_file_dir) of
    {ok, Dir} -> Dir;
    _ -> throw(battle_file_dir_undefined)
  end.

%% 获取application的配置信息
%% 全局战斗脚本文件存放目录 玩家复制操作保存战斗脚本动画目录
%% 返回值:目录位置
get_global_battle_file_dir() ->
  case application:get_env(?APP, global_battle_file_dir) of
    {ok, Dir} -> Dir;
    _ -> throw(global_battle_file_dir_undefined)
  end.


%% 获取开服时间戳
%% 返回值:开服时间戳
get_start_server_timestamp() ->
  case application:get_env(?APP, start_server_time) of
    {ok, Start_server_time} when is_integer(Start_server_time) ->
      %%开服时间跟奖励有关系,所以做下限制,最早不能小于2013-1-30,最大不能大于2014-1-30,这两个值需要一定时间后做校正
      min(max(Start_server_time, 1359513061), 1391049061);
  %Start_server_time;
    _ -> throw(start_server_time_no_find)
  end.

%% 获取内存警戒线 单位/MB
%% 返回值: value  如 1024 : 1GB
get_vm_memory_high_watermark() ->
  case application:get_env(?APP, vm_memory_high_watermark) of
    {ok, MemoryWatermark} -> MemoryWatermark;
    _ -> throw(vm_memory_high_watermark_no_find)
  end.


%% 获取domain name
%% 返回值:domain name
get_server_domain_name() ->
  case application:get_env(?APP, server_domain_name) of
    {ok, Server_domain_name} -> Server_domain_name;
    _ -> throw(server_domain_name)
  end.

%% %是否腾讯服
%% 返回值:false | true  否|是
is_tencent_server() ->
  case application:get_env(?APP, is_tencent) of
    {ok, 0} -> false;
    {ok, 1} -> true;
    _ -> throw(is_tencent)
  end.


%%--------------------------------------------------------------------------------------
%% server.app文件如果变化的话,这里获取所有的env,
%% 然后执行一次set_env(Application, Par, Val) -> ok
%%--------------------------------------------------------------------------------------

%% 从新加载application的配置信息
%% 返回值:ok | {error, Reason}
reload_app_config_safe() ->
  try
    reload_app_config(),
    ok
  catch
    _:Reason ->
      {error, Reason}
  end,
  ok.
reload_app_config() ->
  case file:consult("server.app") of
    {ok, [{application, server, L}]} ->
      case proplists:get_value(env, L) of
        undefined ->
          no_env;
        Env_List ->
          [application:set_env(server, Key, Value) || {Key, Value} <- Env_List]
      end;
    Error ->
      throw(Error)
  end.























