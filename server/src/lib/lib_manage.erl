-module(lib_manage).

-include("common.hrl").
-include("chat.hrl").
-include("record.hrl").
-include("protocol.hrl").


-export(
[
  get_online_count/1,
  get_system_info/1,
  add_daily_bulletin/1,
  get_all_daily_bulletin/0,
  reload_module/1,

  set_restrict_state/1,
  kick_player_off/1,
  get_player_restrict_state/1
]
).

-export([close_listener/0]).


%% ------------------------------ 后台监控 begin-----------------------------
%% 查看系统内存、进程信息
%% ParaList:参数列表:格式[{key, Value} | ...]
%% 返回值
%%      {TYPE, OnlineCount} | 定义好的消息号:
%%          其中TYPE为ParaList中指定的要查询的范围（原子，如total_online，map_online）
%%          OnlineCount为TYPE对应的在线人数（整型）
get_system_info(ParaList) ->
  lib_monitor_system:get_system_info(ParaList).

%% 获取实时在线人数
%% ParaList:参数列表:格式[{key, Value} | ...]
%% 返回值 
%%      {TYPE, OnlineCount} | 定义好的消息号:
%%          其中TYPE为ParaList中指定的要查询的范围（原子，如total_online，map_online）
%%          OnlineCount为TYPE对应的在线人数（整型）
get_online_count(ParaList) ->
  lib_monitor_system:get_online_count(ParaList).

%% ------------------------------ 后台监控 end-----------------------------

%% -------------------------------------
%% 服务器管理相关
%% -------------------------------------

%%-------------------------------------
%% 关闭listen,防止玩家继续创建socket
%%-------------------------------------
%% 关闭socket监听
%% 返回值:不使用
close_listener() ->
  gen_server:cast(tcp_listener, stop).


%% 添加系统日常公告
%% ParaList:参数列表:格式[{key, Value} | ...]
%% 返回值:{finish, Result:需要返回的定义好的消息}
add_daily_bulletin(ParaList) ->
  Version = mod_webserver:resolve_parameter("version", ParaList),
  Content = mod_webserver:resolve_parameter("content", ParaList),
  StartTime = mod_webserver:resolve_parameter("start_time", ParaList),
  lib_storage_file_bulletin:insert(Version, Content, StartTime).

%% 查看已添加的所有公告
get_all_daily_bulletin() ->
  lib_storage_file_bulletin:get_latest_top10_bulletin_file().

%% 代码热更新
%% ParaList:参数列表:格式[{key, Value} | ...]
reload_module(ParaList) ->
  ModuleAtom = lib_util_type:to_atom(mod_webserver:resolve_parameter("m", ParaList)),
  case is_atom(ModuleAtom) of
    false ->
      "Invalid Parameter \"m\"";
    true ->
      case ModuleAtom of
        undefined ->
          "Need Parameter \"m\"";
        _Other ->
          case mod_reloader:reload_modules([ModuleAtom]) of
            [{module, _ModuleName}] ->
              "Updated Successfully";
            [{error, nofile}] ->
              "Module Not Exist";
            [{error, not_purged}] ->
              "Module Not Purged";
            Res ->
              lists:concat(["Unrecognized Error", Res]),
              "true"
          end
      end
  end.

%% 频道聊天禁言指定玩家
%% ParaList:参数列表:格式[{key, Value} | ...]
set_restrict_state(ParaList) ->
  PlayerId = lib_util_type:to_integer(mod_webserver:resolve_parameter("player_id", ParaList)),
  RestrictState = lib_util_type:to_integer(mod_webserver:resolve_parameter("rs", ParaList)), %是否受限（rs=0 不受限| rs=1 禁言 | rs=2 禁止登录）
  case PlayerId =< 0 of
    true ->
      "Invalid Parameter \"player_id\"";
    false ->
      case RestrictState >= 0 andalso
        RestrictState =< 3 of
        false ->
          "Invalid Parameter \"rs\"";
        true ->
          case lib_player:get_player_pid(PlayerId) of
            [] ->
              case db_agent_player:get_info_by_id(PlayerId) of
                {ok, Player_Status} when is_record(Player_Status, player_status) ->
                  {update, _} = ?DB_GAME:update(player, [{restrict_state, RestrictState}], [{"id", PlayerId}]),
                  "true";
                _Other ->
                  "Player Not Found"
              end;
            Pid ->
              mod_player:cast(Pid, {set_restrict_state, RestrictState}),
              "true"
          end
      end
  end.

%%将指定玩家踢下线
%% ParaList:参数列表:格式[{key, Value} | ...]
kick_player_off(ParaList) ->
  PlayerId = lib_util_type:to_integer(mod_webserver:resolve_parameter("player_id", ParaList)),
  case PlayerId < 0 of
    true ->
      "Invalid Parameter \"player_id\"";
    false ->
      case lib_player:get_player_pid(PlayerId) of
        [] ->
          "Player is Offline or Not Exist";
        Pid ->
          {ok, BinData} = ?p_account:write(?p_send_player_lost_connect_response, ?KICK_REASON_GM_KICK),
          mod_player:cast(Pid, {send_to_sid, BinData}),
          "true"
      end
  end.

%% 获取指定玩家受限情况
%% ParaList:参数列表:格式[{key, Value} | ...]
get_player_restrict_state(ParaList) ->
  PlayerId = lib_util_type:to_integer(mod_webserver:resolve_parameter("player_id", ParaList)),
  TempResult = case PlayerId =< 0 of
                 true ->
                   [{"error", "\"Invalid Parameter player_id\""}];
                 false ->
                   case lib_player:get_player_info_by_id(PlayerId) of
                     [] ->
                       [{"error", "\"Player Not Exist\""}];
                     PlayerStatus when is_record(PlayerStatus, player_status) ->
                       [{"restrict_state", PlayerStatus#player_status.restrict_state}]
                   end
               end,
  lib_util_string:key_value_to_json(TempResult).










