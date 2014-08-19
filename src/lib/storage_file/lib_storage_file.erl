%%%==============================================================================
%%% Author      :fangjie008@163.com
%%% Created     :2012-11
%%% Description :文件存储方法库
%%%==============================================================================
-module(lib_storage_file).
-include("common.hrl").
-include("storage_file.hrl").
-include_lib("stdlib/include/ms_transform.hrl").

-export([
  get_ver/0
]).

-export([
  init/0,
  terminate/0
]).

%% ----------------------------------------------------
%% 作为对外接口的方法,路由x->this -> mod_storage_file
%% ----------------------------------------------------
%% 获取当前version
get_ver() ->
  State = gen_server:call(mod_storage_file, get_state),
  State#storage_file_state.version.


%% ----------------------------------------------------
%% mod_storage_file进程中执行的方法
%% ----------------------------------------------------
%% 服务器启动,进行基本的初始化操作
init() ->
  %% 取得当前version值
  New_Ver = init_version(),
  %% 玩家dets初始化
  lib_storage_file_player:init(New_Ver),
  {ok, #storage_file_state{version = New_Ver}}.


%% 版本初始化,判断版本dets文件是否存在数据,不存在版本号为1初始值
%% 存在本次版本号 + 1
init_version() ->
  dets:open_file(?dets_key_storage_version, [{access, read_write}, {type, set}, {keypos, 1}, {ram_file, true}, {auto_save, infinity}, {version, 9}]),
  Last_Ver =
    case dets:lookup(?dets_key_storage_version, storage_ver_key) of
      [{storage_ver_key, Ver}] ->
        %?T("init_version, info:~p", [dets:match_object(?dets_key_storage_version, {_ = '_', _='_'})]),
        Ver;
      _Other ->

        0
    end,
  dets:insert(?dets_key_storage_version, {storage_ver_key, Last_Ver + 1}),
  dets:sync(?dets_key_storage_version),
  dets:close(?dets_key_storage_version),
  Last_Ver + 1.


%% 结束时的处理
terminate() ->
  %玩家dets关闭
  lib_storage_file_player:terminate().

%%------------------------------------------------
%% 通用处理接口
%%------------------------------------------------


























