%%%==============================================================================
%%% Author      :fangjie008@163.com
%%% Created     :2012-6
%%% Description :服务日志模块
%%%==============================================================================
-module(mod_server_log).
-behaviour(gen_event).

%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------
-include("common.hrl").

-record(file_appender, {dir, file_name, fd}).
-define(FILE_OPTIONS, [write, raw, binary, append]).
-define(FILE_OPTIONS_ROTATE, [write, raw, binary]).
-define(Server_Loger, server_log).

%%--------------------------------------------------------------------
%% Export
%%--------------------------------------------------------------------
-export([log/2, add_handler/0]).
-export([start_link/0, init/1, handle_event/2, handle_call/2, handle_info/2, terminate/2, code_change/3]).

%%======================================
%% gen_event callback functions  file:open("./server_log/server_log.txt", [write, raw, binary, append]).
%%======================================
%% 启动指定的gen_event
start_link() ->
  Result = gen_event:start_link({local, ?Server_Loger}),
  Result.

%% 记录日志
%% 日志记录接口type类型,data参数数据
%% 返回值:不使用返回值
log(Type, Para_List) ->
  case catch gen_event:sync_notify(?Server_Loger, {log, [Type, Para_List]}) of
    {'EXIT', Reason} ->
      ?T("[mod_server_log] Data:~p Reason: ~p", [{Type, Para_List}, Reason]),
      ?Error(server_log_logger, "[mod_server_log] Data:~p Reason: ~p   ", [{Type, Para_List}, Reason]);
    _Other ->
      skip
  end.

%% --------------------------------------------------------------------
%% Callback functions
%% --------------------------------------------------------------------

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
  erlang:process_flag(priority, high),
  %%获取配置信息
  {Dir, FileName, Suffix} = lib_config:get_server_log(),
  %% 构建完整路径
  filelib:ensure_dir(Dir ++ "/"),
  File = Dir ++ "/" ++ FileName ++ "." ++ Suffix,
  %% 打开文件
  {ok, Fd} = file:open(File, ?FILE_OPTIONS),
  %% state构建
  State = #file_appender{dir = Dir, file_name = File, fd = Fd},
  {ok, State}.

%% --------------------------------------------------------------------------------------------------
%% Event = term()
%% State = term()
%% Result = {ok,NewState} | {ok,NewState,hibernate}
%%  | {swap_handler,Args1,NewState,Handler2,Args2} | remove_handler
%% NewState = term()
%% Args1 = Args2 = term()
%% Handler2 = Module2 | {Module2,Id}
%%  Module2 = atom()
%%  Id = term()
%% Whenever an event manager receives an event sent using gen_event:notify/2 or gen_event:sync_notify/2, this function is called for each installed event handler to handle the event.
%% Event is the Event argument of notify/sync_notify.
%% State is the internal state of the event handler.
%% -------------------------------------------------------------------------------------------------
handle_event(Info, State) ->
  try
    do_event(Info, State)
  catch
    _:Reason ->
      Stacktrace = erlang:get_stacktrace(),
      ?Error(server_log_logger, "mod_server_log handle_event is Info:~p, Reason:~p, Trace:~p, State:~p", [Info, Reason, Stacktrace, State]),
      ?T("*****Error mod_server_log handle_event info: ~p,~n reason:~p,~n stacktrace:~p", [Info, Reason, Stacktrace]),
      {ok, State}
  end.

%% --------------------------------------------------------------------
%% Function: handle_call/3
%% Description: Handling call messages
%% Returns: {ok,Reply,NewState} | {ok,Reply,NewState,hibernate}| {swap_handler,Reply,Args1,NewState,Handler2,Args2}| {remove_handler, Reply}
%% --------------------------------------------------------------------
handle_call(Info, State) ->
  try
    do_call(Info, State)
  catch
    _:Reason ->
      Stacktrace = erlang:get_stacktrace(),
      ?Error(server_log_logger, "mod_server_log handle_call is Info:~p, Reason:~p, Trace:~p, State:~p", [Info, Reason, Stacktrace, State]),
      ?T("*****Error mod_server_log handle_call info: ~p,~n reason:~p,~n stacktrace:~p", [Info, Reason, Stacktrace]),
      {ok, ok, State}
  end.


%% --------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {ok, State}          |
%%          {ok, State, hibernate} |
%%          {swap_handler,Args1,NewState,Handler2,Args2} | remove_handler
%% --------------------------------------------------------------------
handle_info(Info, State) ->
  try
    do_info(Info, State)
  catch
    _:Reason ->
      Stacktrace = erlang:get_stacktrace(),
      ?Error(server_log_logger, "mod_server_log handle_info is Info:~p, Reason:~p, Trace:~p, State:~p", [Info, Reason, Stacktrace, State]),
      ?T("*****Error mod_server_log handle_info info: ~p,~n reason:~p,~n stacktrace:~p", [Info, Reason, Stacktrace]),
      {ok, State}
  end.

%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(Reason, State) ->
  try
    do_terminate(Reason, State)
  catch
    _:Reason ->
      Stacktrace = erlang:get_stacktrace(),
      ?Error(server_log_logger, "mod_server_log do_terminate is Reason:~p, Trace:~p, State:~p", [Reason, Stacktrace, State]),
      ?T("*****Error mod_server_log do_terminate ~n reason:~p,~n stacktrace:~p", [Reason, Stacktrace]),
      ok
  end.
%% --------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

%% --------------------------------------------------------------------------------------------------------------------------
%%										内部Handler
%% --------------------------------------------------------------------------------------------------------------------------

%%---------------------do_event----------------------------------------
%% 别忘记完整注释哦亲
%% 记录日志event 处理
%% Type:记录的日志编号, Para_List:参数列表
%% State:当前类型
%% 返回值:{ok, State}.
do_event({log, [Type, Para_List]}, State) ->
  NewState =
    case (catch do_log({Type, Para_List}, State)) of
      {'EXIT', Reason} ->
        ?Error(server_log_logger, "[mod_server_log] Data:~p Reason: ~p   ", [{Type, Para_List}, Reason]),
        State;
      NormalState when is_record(NormalState, file_appender) ->
        NormalState;
      Other ->
        ?Error(server_log_logger, "[mod_server_log] not_file_appender_record: ~p~n ", [Other]),
        State
    end,
  {ok, NewState};

%% 通配event处理
%% Info:消息
%% State:当前进程状态
%% 返回值:{ok, State}.
do_event(Info, State) ->
  ?Error(server_log_logger, "server_log_logger call is not match:~p", [Info]),
  {ok, State}.

%%---------------------do_call----------------------------------------
%% 别忘记完整注释哦亲

%% 通配call处理
%% Info:消息
%% _From:消息来自
%% State:当前进程状态
%% 返回值:{ok, ok, State}.
do_call(Info, State) ->
  ?Error(server_log_logger, "server_log_logger call is not match:~p", [Info]),
  {ok, ok, State}.


%%--------------------do_info------------------------------------------
%% 别忘记完整注释哦亲

%% 通配info处理
%% Info:消息
%% State:当前进程状态
%% 返回值:{ok, State}.
do_info(Info, State) ->
  ?Error(server_log_logger, "server_log_logger info is not match:~p", [Info]),
  {ok, State}.

%%---------------------do_terminate-------------------------------------

%% 通配进程销毁处理
%% State:当前进程状态
%% 返回值:ok
do_terminate(Reason, State) ->
  %?T("do_terminate"),
  timer:sleep(1000),
  case Reason =:= normal orelse Reason =:= shutdown orelse Reason =:= stop of
    true ->
      skip;
    false ->
      ?Error(server_log_logger, "server_log_logger terminate reason: ~p, state:~p", [Reason, State])
  end,
  %别忘记进程销毁需要做的数据清理哦
  ok.


%%============================================================================================
%% Model internal functions
%%============================================================================================

%% 将event 添加到event管理器
add_handler() ->
  gen_event:add_handler(?Server_Loger, ?MODULE, []).


%% 记录日志
%% Type:日志编号
%% Para_List:参数列表
%% 返回值:新的状态数据
do_log({Type, Para_List}, #file_appender{file_name = Filename, fd = Fd} = State) when is_list(Para_List) ->
  %% 当前时间戳
  Time = lib_util_time:get_timestamp(),
  Para_List_Final = treating_para_list(Para_List),
  %% 格式
  Format = "~p|~p" ++ lists:flatten([begin if is_list(X) -> "|~s"; true ->
    "|~p" end end || X <- Para_List_Final]) ++ "\n",
  %% 参数处理
  Log_Content = io_lib:format(Format, [Type, Time] ++ Para_List_Final),
  %% 记录日志
  case filelib:is_file(Filename) of
    true ->
      file:write(Fd, Log_Content),
      State;
    false ->
      file:close(Fd),
      {ok, NewFd} = file:open(Filename, ?FILE_OPTIONS),
      NewState = State#file_appender{fd = NewFd},
      file:write(NewFd, Log_Content),
      NewState
  end;

%% 通配
do_log(Content, State) ->
  ?Error(server_log_logger, "server_log_logger do log not match Content:~p", [Content]),
  State.


%% 处理参数列表
%% Para_List:参数列表
%% 返回值:处理后的列表
treating_para_list(Para_List) ->
  [treating_para(Para) || Para <- Para_List].

%% 加工处理参数
%% Para:当前要处理的参数
%% 返回值:处理后的参数,目前处理list类型
treating_para(Para) when is_binary(Para) ->
  lib_util_type:to_list(Para);
treating_para(Para) ->
  Para.















    
