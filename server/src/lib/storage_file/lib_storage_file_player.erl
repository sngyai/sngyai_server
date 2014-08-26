%%%==============================================================================
%%% Author      :fangjie008@163.com
%%% Created     :2012-11
%%% Description :des
%%%==============================================================================
-module(lib_storage_file_player).
-include("common.hrl").
-include("storage_file.hrl").
-include("record.hrl").
-include_lib("stdlib/include/ms_transform.hrl").

-export([
  select/0,
  insert/1
]).


-export([
  init/1,
  terminate/0
]).


%% ----------------------------------------------------
%% 对外接口方法,可在任意进程调用,dets可以在非owner进程直接访问
%% 所以就没有必要通过mod_storage_file来访问了
%% ----------------------------------------------------

%% 查找所有玩家数据
%% 返回值:[#storage_file_player_status]
select() ->
  dets:match_object(?dets_key_storage_player, #storage_file_player_status{_ = '_'}).


%% 玩家数据插入
%% Player_Status:#player_status
%% Ver:当前版本号
%% 返回值:不使用
insert(Player_Status) ->
  Ver = lib_storage_file:get_ver(),
  %?T("insert1 ver:~p", [Ver]),
  dets:insert(?dets_key_storage_player, #storage_file_player_status{id = Player_Status#player_status.id, ver = Ver, time = lib_util_time:get_timestamp(), value = Player_Status}),
  dets:sync(?dets_key_storage_player).


%% ----------------------------------------------------
%% mod_storage_file进程中执行的方法
%% ----------------------------------------------------
%% 玩家备份数据初始化,这里保存指定最新的几个版本号的数据
%% 每次启动服务器的时候版本号递增,这里会清理老版本号的数据
%% 之所以保存几个版本号内数据,就是为了修复数据使用,否则可能会导致有用的数据被误删除(由于服的启动等)
%% Ver:本次版本号
%% 返回值:ok
init(Ver) ->
  %% 打开表
  dets:open_file(?dets_key_storage_player, [{access, read_write}, {type, set}, {keypos, #storage_file_player_status.id}, {auto_save, infinity}, {version, 9}]),
  %% 清理过期数据
  Expire_Ver = Ver - 5, %目前保存前5个版本的数据
  dets:select_delete(?dets_key_storage_player, ets:fun2ms(fun(#storage_file_player_status{ver = Ver_E}) ->
    Ver_E < Expire_Ver end)),
  ok.


%% 结束的时候关闭dets
terminate() ->
  %?T("terminate1"),
  dets:close(?dets_key_storage_player).







