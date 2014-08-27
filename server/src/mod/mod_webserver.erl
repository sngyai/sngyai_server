%%%==============================================================================
%%% Author      :fangjie008@163.com
%%% Created     :2012-6
%%% Description :后台通讯模块
%%%==============================================================================
-module(mod_webserver).

-behaviour(gen_server).

-include("common.hrl").
-include("record.hrl").

-define(SERVER, ?MODULE).
-define(DEFAULT_PORT, lib_config:get_webserver_port()).
-define(HTTP_OK, 200).


%% API
-export([start_link/0, start_link/1, loop/2]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-export([resolve_parameter/2]).

-record(state, {a = 0}).


%%--------------------------------------------------------------------
%% Server functions
%%--------------------------------------------------------------------
%% 启动gen_server
start_link() ->
  start_link(?DEFAULT_PORT).

start_link(Port) ->
  Result = gen_server:start_link({local, ?SERVER}, ?MODULE, Port, ?Public_Service_Options),
  Result.

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
init(Port) ->
  put(tag, ?MODULE),
  process_flag(trap_exit, true),
  Root = lib_util:local_path(["ebin", "html"]),

  %% Mochiweb callback. Handles requests.
  Loop = fun(Req) ->
    try
      ?MODULE:loop(Req, Root)
    catch
      _:Reason ->
        Stack_trace = erlang:get_stacktrace(),
        ?Error(webserver_logger, "webserver_logger loop error req:~p, reason:~p, get_stacktrace:~p", [Req, Reason, Stack_trace])
    end
  end,
  %% Start mochiweb
  mochiweb_http:start([{loop, Loop}, {port, Port}]),
  {ok, #state{}}.


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
      ?Error(webserver_logger, "mod_webserver handle_call is Info:~p, Reason:~p, Trace:~p, State:~p", [Info, Reason, Stacktrace, State]),
      ?T("*****Error mod_webserver handle_call info: ~p,~n reason:~p,~n stacktrace:~p", [Info, Reason, Stacktrace]),
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
      ?Error(webserver_logger, "mod_webserver handle_cast is Info:~p, Reason:~p, Trace:~p, State:~p", [Info, Reason, Stacktrace, State]),
      ?T("*****Error mod_webserver handle_cast info: ~p,~n reason:~p,~n stacktrace:~p", [Info, Reason, Stacktrace]),
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
      ?Error(webserver_logger, "mod_webserver handle_info is Info:~p, Reason:~p, Trace:~p, State:~p", [Info, Reason, Stacktrace, State]),
      ?T("*****Error mod_webserver handle_info info: ~p,~n reason:~p,~n stacktrace:~p", [Info, Reason, Stacktrace]),
      {noreply, State}
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
      ?Error(webserver_logger, "mod_webserver do_terminate is Reason:~p, Trace:~p, State:~p", [Reason, Stacktrace, State]),
      ?T("*****Error mod_webserver do_terminate ~n reason:~p,~n stacktrace:~p", [Reason, Stacktrace]),
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

%%---------------------do_call----------------------------------------
%% 别忘记完整注释哦亲

%% 通配call处理
%% Info:消息
%% _From:消息来自
%% State:当前进程状态
%% 返回值:ok
do_call(Info, _From, State) ->
  ?Error(webserver_logger, "mod_webserver do_call is not match:~p", [Info]),
  {reply, ok, State}.


%%--------------------do_cast-----------------------------------------
%% 别忘记完整注释哦亲

%% 通配cast处理
%% Info:消息
%% State:当前进程状态
%% 返回值:不使用
do_cast(Info, State) ->
  ?Error(webserver_logger, "mod_webserver cast is not match:~p", [Info]),
  {noreply, State}.

%%--------------------do_info------------------------------------------
%% 别忘记完整注释哦亲

%% 通配info处理
%% Info:消息
%% State:当前进程状态
%% 返回值:不使用
do_info(Info, State) ->
  ?Error(webserver_logger, "mod_webserver info is not match:~p", [Info]),
  {noreply, State}.

%%---------------------do_terminate-------------------------------------

%% 通配进程销毁处理
%% State:当前进程状态
%% 返回值:ok
do_terminate(Reason, _State) ->
  %?T("do_terminate"),
  %timer:sleep(1000),
  case Reason =:= normal orelse Reason =:= shutdown of
    true ->
      skip;
    false ->
      ?Error(webserver_logger, "mod_webserver terminate reason: [~p]", [Reason])
  end,
  %% Stop mochiweb
  mochiweb_http:stop(?SERVER),
  %别忘记进程销毁需要做的数据清理哦
  ok.


%%--------------------------------------------------------------------
%%% Internal functions  mod_webserver:start_link().
%%--------------------------------------------------------------------
%% 循环处理消息
%% Req:request请求主体
%% Root:指定的根目录
%% 返回值:不使用返回值
loop(Req, Root) ->
  Status = ?HTTP_OK, %% HTTP OK
  case Req:get(path) of
    "/goto.htm" ->
      Req:serve_file("goto.htm", Root);
    _Other ->
      {Content, Headers} = handle_request(Req),
      Content_Final =
        case is_list(Content) of
          true -> Content;
          false -> io_lib:format("~p", [Content])
        end,
      Response = {Status, Headers, Content_Final},
      Req:respond(Response)
  end.


% 功能                                                                 Request
%---------------------------------------------------------------------------------------------------------------------------------
% 举例                       msg=1000&id=100023
%---------------------------------------------------------------------------------------------------------------------------------
%% 处理请求
%% Req:请求主体
%% 返回值:{Content, Headers}
handle_request(Req) ->
  %?T("handle_request path: ~p, method:~p",[Req:get(path), Req:get(method)]),
  QS = case Req:get(method) of 'GET' -> Req:parse_qs(); 'POST' -> Req:parse_post() end,
  ?T("handle_request req:~p, QS:~p", [Req, QS]),
  Type = string:tokens(Req:get(path), "/"),
  try deal_request(Type, QS) of
    {finish, Result} ->
      {Result, [{"Content-type", "text/plain"}]};
    Other ->
      ?Error(webserver_logger, "mod_webserver handle_request type:~p Error :~p~n", [Type, Other]),
      ?T("handle_request return error ~p", [Other]),
      {io_lib:format("handle_request return error: ~p", [Other]), [{"Content-type", "text/plain"}]}
  catch
    _:Reason ->
      Stack_trace = erlang:get_stacktrace(),
      ?Error(webserver_logger, "mod_webserver handle_request type:~p, Reason :~p, Qs:~p,Stack_trace:~p ~n", [Type, Reason, QS, Stack_trace]),
      ?T("handle_request return Reason: ~p, Stack_trace:~p", [Reason, Stack_trace]),
      {io_lib:format("handle_request return Reason: ~p", [Reason]), [{"Content-type", "text/plain"}]}
  end.

%% 开发请求,通用的m:f(a)处理
%% 调用方法:http://127.0.0.1:8088/dev/?apply=lib_util_time:get_timestamp(). 注意别忘记了"."
%% QS:当前参数列表
%% 返回值:{finish, Result:string()}
deal_request(["dev"], QS) ->
  Apply = resolve_parameter("apply", QS),
  MFA = re:replace(Apply, "\r\n$", "", [{return, list}]),
  {match, [M, F, A]} = re:run(MFA, "(.*):(.*)\s*\\((.*)\s*\\)\s*.\s*$", [{capture, [1, 2, 3], list}, ungreedy]),
  {ok, Toks, _Line} = erl_scan:string("[" ++ A ++ "].", 1),
  {ok, Args} = erl_parse:parse_term(Toks),
  Result = apply(list_to_atom(M), list_to_atom(F), Args),
  {finish, io_lib:format("~p", [Result])};

%% 调用方法:http://127.0.0.1:8088/user/?msg=1000&id=....
%% QS:当前参数列表
%% 返回值:{finish, Result:string()}
deal_request(["user"], QS) ->
  Msg = list_to_integer(resolve_parameter("msg", QS)),
  Result = do_user(Msg, QS),
  {finish, Result};

%% 处理请求
%% 系统请求,调用方法:http://127.0.0.1:8088/sys/?msg=1000&id=....
%% QS:当前参数列表
%% 返回值:{finish, Result:string()}
deal_request(["sys"], QS) ->
  Msg = list_to_integer(resolve_parameter("msg", QS)),
  Result = do_request(Msg, QS),
  {finish, Result};

%% 安全沙箱
%% 系统请求,调用方法:http://127.0.0.1:8088/crossdomain.xml
%% 返回值:{finish, Result:string()}
deal_request(["crossdomain.xml"], _QS) ->
  Result = "<cross-domain-policy><allow-access-from domain='*' to-ports='*' /></cross-domain-policy>",
  {finish, Result};

%% 处理请求类型通配
%% Type:类型
%% QS:当前参数列表
%% 返回值:{finish, type_error}
deal_request(Type, QS) ->
  ?Error(webserver_logger, "mod_webserver deal_request type error type:~p, QS:~p~n", [Type, QS]),
  ?T("mod_webserver deal_request type error type:~p, QS:~p~n", [Type, QS]),
  {finish, "type_error"}.

%%创建账号
do_user(1000, QS) ->
  UserName = lib_util_type:string_to_term(resolve_parameter("user_name", QS)),
  PassWd = lib_util_type:string_to_term(resolve_parameter("passwd", QS)),
  Result = lib_user:create_role(UserName, PassWd),
  {finish, Result};

%%登录
do_user(1001, QS) ->
  UserName = lib_util_type:string_to_term(resolve_parameter("user_name", QS)),
  PassWd = lib_util_type:string_to_term(resolve_parameter("passwd", QS)),
  Result = lib_user:login(UserName, PassWd),
  {finish, Result}.




%% 具体处理消息请求---------------------------------------------------------------------------------------
%% 前面是消息号,每一个请求在这里对应一个方法
%% 后面是本次请求参数列表
%% 返回值 Result:string()

%%  msg=1000
do_request(9999, _QS) ->
  %_PlayerID = list_to_integer(resolve_parameter("id", QS)),
  %do_something,
  "{\"online_count_total\":174}"
;

%% 通配
do_request(Msg, QS) ->
  ?Error(webserver_logger, "mod_webserver deal_request type error Msg:~p, QS:~p~n", [Msg, QS]),
  ?T("mod_webserver deal_request type error Msg:~p, QS:~p~n", [Msg, QS]),
  "Msg Error".

%%--------------------------------------------------------------------------------------------------------

%% 参数的解析
%% Key:当前要解析的参数标识
%% QS:当前参数列表
%% 返回值:参数值,不存在的话返回undefined
resolve_parameter(Key, QS) ->
  Key_Final = lib_util_type:to_list(Key),
  case lists:keysearch(Key_Final, 1, QS) of
    {value, {Key_Final, Value}} ->
      Value;
    false ->
      undefined
  end.

