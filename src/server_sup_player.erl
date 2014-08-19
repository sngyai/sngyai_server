%%%==============================================================================
%%% Author      :fangjie008@163.com
%%% Created     :2012-8
%%% Description :des
%%%==============================================================================
-module(server_sup_player).
-behaviour(supervisor).

-include("common.hrl").

-export([start_link/0, init/1]).
-export([start_service/0, stop_service/0]).

-export([start_player/7]).

%% 启动supervisor
start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ---------------------------------------------------------------------------------------------------------------------
%% init回调方法
%% ---------------------------------------------------------------------------------------------------------------------
%% supervisor的回调init方法,定义了重启机制
%init([]) ->
%    %% 返回
%	{ok, {
%        {one_for_one, 8, 10},
%        []
%         }}.

% simple_one_for_one的方式simple_one_for_one形式启动的子进程根本没有放在supervisor的state.children里面，也就是说supervisor在terminate的时候根本没管simple_one_for_one形式启动的子进程，如此当supervisor结束时，所有的simple_one_for_one子进程都会收到一条{‘EXIT’, Pid, Reason}的消息，如果子进程有处理这样的消息并返回了stop，则会调用terminate。 但在执行terminate期间，app可能已经结束，从而正在停止中的系统会直接kill掉该进程（实际上是所有剩余的进程），使得其没有时间执行完所有的功能代码（参考之前的分析《init:stop浅析》）。
init(_Args) ->
  {ok, {{simple_one_for_one, 10, 1},
    [{player_server, {player_server, start_link, []},
      temporary, 120000, worker, [player_server]}]}}.


%%====================================================================
%% External functions
%%====================================================================
%% 游戏服务节点启动代码
%% 返回值:ok
start_service() ->
  %% gen_player相关初始化
  ok = gen_player:start(),
  ok.

%% 结束的清理
%% 返回值:ok
stop_service() ->
  gen_player:stop(),
  ok.


%% ---------------------------------------------------------------------------------------------------------------------
%% 启动子进程
%% ---------------------------------------------------------------------------------------------------------------------
%% 开启一个玩家 - one_for_one的方式
%% Player_id:玩家id, Socket:玩家socket, ClientPid:此玩家brokerpid
%% OpenKey:string:来自url-sesseionkey, Pf:string:来自url-来源平台, PfKey:string:平台key
%% 返回值:{ok, Pid} | false:不可用
%start_player(Player_id, Socket, ClientPid, Openkey, Pf, Pfkey) ->
%    %    case lib_util_proc:whereis_name_local(server_sup_player) of
%    %        undefined ->
%    %            false;
%    %        _Pid_sup ->
%    case supervisor:start_child(
%        server_sup_player,
%        {lists:concat([player_server, Player_id]),
%         {player_server, start_link,[Player_id, Socket, ClientPid, Openkey, Pf, Pfkey]},
%         temporary, 120000, worker, [player_server]}) of  %我们给其20分钟的时间,然后来看
%        {ok, Pid} ->
%            {ok, Pid};
%        Fail_Info ->
%            ?Error(player_logger, "start_player fail Info:~p, Player_id:~p, Openkey:~p, Pf:~p, Pfkey:~p", [Fail_Info, Player_id, Openkey, Pf, Pfkey]),
%            throw("start_player fail")
%    end.

% simple_one_for_one的方式
start_player(Player_id, Socket, ClientPid, Openkey, Pf, Pfkey, Check_login) ->
  %    case lib_util_proc:whereis_name_local(server_sup_player) of
  %        undefined ->
  %            false;
  %        _Pid_sup ->
  %   supervisor:start_child(?PLAYER_SUP, [{?NEW, Id, Args}])
  case supervisor:start_child(server_sup_player, [Player_id, Socket, ClientPid, Openkey, Pf, Pfkey, Check_login]) of
    {ok, Pid} ->
      {ok, Pid};
    Fail_Info ->
      ?Error(player_logger, "start_player fail Info:~p, Player_id:~p, Openkey:~p, Pf:~p, Pfkey:~p", [Fail_Info, Player_id, Openkey, Pf, Pfkey]),
      throw("start_player fail")
  end.







