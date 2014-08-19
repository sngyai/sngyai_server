%%% -------------------------------------------------------------------
%%% Author  : tj
%%% Description : 竞技场排名生成器
%%%	系统ID管理服务，服务启动时首先从数据库中初始化当前表中最大ID值，运行中在此基础上递增,作为数据记录的唯一ID
%%% 动态ID = 平台ID(1-45)*100000000000000 + 服ID(1-9999)*10000000000 + 增长ID(1-9999999999)
%%% 平台ID(1-45)  服ID(1-9999)   动态ID增长区间为100亿
%%% 支持45个平台  9999个服  100亿个动态ID
%%% Created : 2012-6-18
%%% -------------------------------------------------------------------
-module(mod_increase_athletics).

-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("common.hrl").
%% --------------------------------------------------------------------

%% API
-export([
  get_info/0,
  get_god_rank_idx/0,
  get_ground_rank_idx/0
]).

%% External exports
-export([
  start_link/0
]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%% ID状态信息
-record(state, {
  top_god_max_rank = 0,       %天榜当前最大名次
  top_ground_max_rank = 0     %地榜当前最大名次
}).

%% ====================================================================
%% External functions
%% ====================================================================

start_link() ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], ?Public_Service_Options).


%% ====================================================================
%% 外部API接口
%% ====================================================================
%% 获取进程State信息
get_info() ->
  State = gen_server:call(?MODULE, 'get_info'),
  State.

%% 获取天榜最后排名索引
%% 返回当前天榜最后的名次索引
get_god_rank_idx() ->
  Rank_Idx = gen_server:call(?MODULE, 'get_god_rank_idx'),
  Rank_Idx.

%% 获取地榜最后排名索引
%% 返回当前地榜最后的名次索引
get_ground_rank_idx() ->
  Rank_Idx = gen_server:call(?MODULE, 'get_ground_rank_idx'),
  Rank_Idx.

%t() ->
%	db_agent_test:t_insert1(["tjgoahead","angine",30,2]),
%	timer:sleep(1000),
%	t().
%% ====================================================================
%% Server functions
%% ====================================================================

%% --------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%% --------------------------------------------------------------------
init([]) ->
  put(tag, ?MODULE),
  process_flag(trap_exit, true),
  % 初始化排名索引
  {ok, God_Max_Rank, Ground_Max_Rank} = init_rank_index(),
  State = #state{
    top_god_max_rank = God_Max_Rank,
    top_ground_max_rank = Ground_Max_Rank
  },
  {ok, State}.

%% --------------------------------------------------------------------
%% Function: handle_call/3
%% Description: Handling call messages
%% Returns: {reply, Reply, State}          |
%%          {reply, Reply, State, Timeout} |
%%          {noreply, State}               |
%%          {noreply, State, Timeout}      |
%%          {stop, Reason, Reply, State}   | (terminate/2 is called)
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_call(Info, _From, State) ->
  try
    do_call(Info, _From, State)
  catch
    _:Reason ->
      Stacktrace = erlang:get_stacktrace(),
      ?Error(increase_logger, "mod_increase_athletics handle_call is Info:~p, Reason:~p, Trace:~p, State:~p", [Info, Reason, Stacktrace, State]),
      ?T("*****Error mod_increase_athletics handle_call info: ~p,~n reason:~p,~n stacktrace:~p", [Info, Reason, Stacktrace]),
      {reply, ok, State}
  end.

%% --------------------------------------------------------------------
%% Function: handle_cast/2
%% Description: Handling cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_cast(Info, State) ->
  try
    do_cast(Info, State)
  catch
    _:Reason ->
      Stacktrace = erlang:get_stacktrace(),
      ?Error(increase_logger, "mod_increase_athletics handle_cast is Info:~p, Reason:~p, Trace:~p, State:~p", [Info, Reason, Stacktrace, State]),
      ?T("*****Error mod_increase_athletics handle_cast info: ~p,~n reason:~p,~n stacktrace:~p", [Info, Reason, Stacktrace]),
      {noreply, State}
  end.

%% --------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_info(Info, State) ->
  try
    do_info(Info, State)
  catch
    _:Reason ->
      Stacktrace = erlang:get_stacktrace(),
      ?Error(increase_logger, "mod_increase_athletics handle_info is Info:~p, Reason:~p, Trace:~p, State:~p", [Info, Reason, Stacktrace, State]),
      ?T("*****Error mod_increase_athletics handle_info info: ~p,~n reason:~p,~n stacktrace:~p", [Info, Reason, Stacktrace]),
      {noreply, State}
  end.

%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(_Reason, _State) ->
  ok.

%% --------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

%% --------------------------------------------------------------------
%%% Internal functions
%% --------------------------------------------------------------------

%%---------------------do_call--------------------------------
%% 获取进程State
do_call('get_info', _, State) ->
  {reply, State, State};
%% 获取自增索引值
do_call('get_god_rank_idx', _, State) ->
  AutoIdx = State#state.top_god_max_rank + 1,
  NewState = State#state{top_god_max_rank = AutoIdx},
  {reply, AutoIdx, NewState};
do_call('get_ground_rank_idx', _, State) ->
  AutoIdx = State#state.top_ground_max_rank + 1,
  NewState = State#state{top_ground_max_rank = AutoIdx},
  {reply, AutoIdx, NewState};

do_call(Info, _, State) ->
  ?Error(increase_logger, "mod_increase call is not match:~w", [Info]),
  {reply, ok, State}.


%%---------------------do_cast--------------------------------
do_cast(Info, State) ->
  ?Error(increase_logger, "mod_increase cast is not match:~w", [Info]),
  {noreply, State}.

%%---------------------do_info--------------------------------	
do_info(Info, State) ->
  ?Error(increase_logger, "mod_increase info is not match:~w", [Info]),
  {noreply, State}.


%%%-------------------------------------------------------------------
%% 内部函数
%%%-------------------------------------------------------------------

init_rank_index() ->
  Table_Name = athletics,
  {ok, God_Max_Rank} = case ?DB_GAME:select_one(Table_Name, "Max(rank)", [{top, 1}]) of
                         {scalar, undefined} ->%没有找到，初始化 起始值
                           {ok, 0};
                         {scalar, God_Max} ->%数据库表中目前最大值
                           {ok, God_Max};
                         {error, Reason1} ->
                           {error, Reason1}
                       end,
  {ok, Ground_Max_Rank} = case ?DB_GAME:select_one(Table_Name, "Max(rank)", [{top, 2}]) of
                            {scalar, undefined} ->%没有找到，初始化 起始值
                              {ok, 0};
                            {scalar, Ground_Max} ->%数据库表中目前最大值
                              {ok, Ground_Max};
                            {error, Reason2} ->
                              {error, Reason2}
                          end,
  {ok, God_Max_Rank, Ground_Max_Rank}.
	