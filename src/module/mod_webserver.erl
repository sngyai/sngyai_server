%%%-------------------------------------------------------------------
%%% @author sngyai
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. 八月 2014 下午2:47
%%%-------------------------------------------------------------------
-module(mod_webserver).
-author("sngyai").

-behaviour(gen_server).

-include("common.hrl").

-define(SERVER, ?MODULE).
-define(DEFAULT_PORT, lib_config:get_webserver_port()).
-define(HTTP_OK,200).



%% API
-export([start_link/0, start_link/1, loop/2]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-export([resolve_parameter/2]).

-record(state, {a=0}).


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
    Root =  lib_util:local_path(["ebin","html"]),

    %% Mochiweb callback. Handles requests.
    Loop = fun(Req) ->
        try
            ?MODULE:loop(Req,Root)
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
handle_call(Info,_From, State) ->
    try
        do_call(Info,_From, State)
    catch
        _:Reason ->
            Stacktrace = erlang:get_stacktrace(),
            ?Error(webserver_logger, "mod_webserver handle_call is Info:~p, Reason:~p, Trace:~p, State:~p",[Info, Reason, Stacktrace, State]),
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
            ?Error(webserver_logger, "mod_webserver handle_cast is Info:~p, Reason:~p, Trace:~p, State:~p",[Info, Reason, Stacktrace, State]),
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
            ?Error(webserver_logger, "mod_webserver handle_info is Info:~p, Reason:~p, Trace:~p, State:~p",[Info, Reason, Stacktrace, State]),
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
            ?Error(webserver_logger, "mod_webserver do_terminate is Reason:~p, Trace:~p, State:~p",[Reason, Stacktrace, State]),
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
    ?Error(webserver_logger, "mod_webserver do_call is not match:~p",[Info]),
    {reply, ok, State}.


%%--------------------do_cast-----------------------------------------
%% 别忘记完整注释哦亲

%% 通配cast处理
%% Info:消息
%% State:当前进程状态
%% 返回值:不使用
do_cast(Info, State) ->
    ?Error(webserver_logger, "mod_webserver cast is not match:~p",[Info]),
    {noreply, State}.

%%--------------------do_info------------------------------------------
%% 别忘记完整注释哦亲

%% 通配info处理
%% Info:消息
%% State:当前进程状态
%% 返回值:不使用
do_info(Info, State) ->
    ?Error(webserver_logger, "mod_webserver info is not match:~p",[Info]),
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
            ?Error(webserver_logger, "mod_webserver terminate reason: [~p]" , [Reason])
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
        "/goto.htm"   ->
            Req:serve_file("goto.htm",Root);
        _Other  ->
            {Content, Headers}=handle_request(Req) ,
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
            ?Error(webserver_logger, "mod_webserver handle_request type:~p, Reason :~p, Qs:~p ~n", [Type, Reason, QS]),
            ?T("handle_request return Reason: ~p", [Reason]),
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
    {finish, io_lib:format("~p",[Result])};

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


%% 具体处理消息请求---------------------------------------------------------------------------------------
%% 前面是消息号,每一个请求在这里对应一个方法
%% 后面是本次请求参数列表
%% 返回值 Result:string()

%%  msg=1000
do_request(1000, _QS) ->
    %_PlayerID = list_to_integer(resolve_parameter("id", QS)),
    %do_something,
    "{\"online_count_total\":174}"
;

%% GM从后台添加系统消息
%% 调用方式：msg=1001&type=1&content="充值有好礼"&state=1&start_time=XXXX&end_time=OOOO&cooldown=5
%% 参数说明：
%%  type 消息类型，详见chat.hrl文件中的宏定义CHAT_SYSTEM_x,目前只有一种CHAT_SYSTEM_NOTICE，即201
%%  content 消息内容 HTML格式字符串
%%  state 是否锁定 0：不锁定 1：锁定
%%  start_time 开始生效时间——UNIX时间戳
%%  end_time 开始失效时间——UNIX时间戳
%%  cooldown 冷却时间——单位秒（s）
do_request(1001, QS) ->
    lib_manage:add_system_chat(QS);

%% GM从后台锁定指定系统消息
%% msg=1002&id=1(id:系统消息ID)
do_request(1002, QS) ->
    lib_manage:lock_system_chat(QS);

%% GM从后台解锁指定系统消息
%% msg=1003&id=1(id:系统消息ID)
do_request(1003, QS) ->
    lib_manage:unlock_system_chat(QS);

%% 获取在线玩家人数
%% msg=1004&type=1
%% msg=1004&type=2&map_id=XXXX
do_request(1004, QS) ->
    Res = lib_manage:get_online_count(QS),
    Res;

%% 查看服务器当前运行状况（内存占用、进程数等）
%% msg=1004&type=1(type:1:系统概要状况|2：系统内存占用情况|3：系统进程状况)
do_request(1005, QS) ->
    Res = lib_manage:get_system_info(QS),
    Res;

%% 系统配置相关操作-保存数据库,具体宏定义见:system_config.htl system_config_type_xxx
%% msg=1006&op=1&id=1&value=1 :修改
%% msg=1006&op=2              :查询
%% op:1:修改 | 2:查询当前数据
do_request(1006, QS) ->
    %?T("do_request 1006"),
    Res = lib_system_config:manage(QS),
    %?T("do_request 1006 res:~p", [Res]),
    Res;

%% 根据平台账号查询玩家信息
%% msg=1012&player_account=xxx
%% 返回值:json:[[Id, Nickname, Lv, Career]]
do_request(1012, QS) ->
    Res = lib_manage:select_player_info_by_player_account(QS),
    Res;

%% 根据nickname查询玩家信息
%% msg=1013&nickname=xxx
%% 返回值:json:[[Id, Nickname, Lv, Career]]
do_request(1013, QS) ->
    Res = lib_manage:select_player_info_by_player_nick_name(QS),
    Res;


%% 系统临时配置修改,例如服务是否开放等,不保存数据库
%% msg=1016&op=1&key=1&value=0 -修改
%% msg=1016&op=2 -查询
%% 目前{key:1:服务是否关闭,value:0:服务关闭,0:服务开启}
do_request(1016, QS) ->
    Op = lib_util_type:to_integer(mod_webserver:resolve_parameter("op", QS)),
    case Op of
        1 ->
            Key = lib_util_type:to_integer(mod_webserver:resolve_parameter("key", QS)),
            Value = lib_util_type:to_integer(mod_webserver:resolve_parameter("value", QS)),
            lib_system_config:memory_config_set(Key, Value),
            "true";
        2 -> %查询
            lib_system_config:memory_config_get()
    end;






%% 提供给小宇,用来检查服务器是否开启
%% msg=1020
%% 只有当返回true的时候才认为服务器开启
do_request(1020, _QS) ->
    case whereis(tcp_listener) of
        undefined -> "false";
        _Start ->
            "true"
    end;

%% 腾讯回调发货请求
%% 在此之前,php已经对sig/时间等进行过验证,通过后才会进行到这里
%% http://wiki.open.qq.com/wiki/%E5%9B%9E%E8%B0%83%E5%8F%91%E8%B4%A7URL%E7%9A%84%E5%8D%8F%E8%AE%AE%E8%AF%B4%E6%98%8E_V3
%% msg=1021&openid=a&payitem=a&token=a&billno=a&zoneid=1&amt=1&payamt_coins=1&pubacct_payamt_coins=1
%% 注意
%% true:认为发货成功 php返给腾讯{"ret":0,"msg":"OK"} | Msg 否则php返给腾讯{"ret":x=1,"msg":Msg}
do_request(1021, QS) ->
    lib_player_tencent:call_back_delivery(QS);

%% 腾讯回调赠送道具发货URL的协议说明_V3.0
%% 抽奖送礼包/每日礼包/开通包月礼包/单笔消费送礼包 等腾讯活动赠送都走这里的回调
%% 在此之前,php已经对sig/时间等进行过验证,通过后才会进行到这里
%% http://wiki.open.qq.com/wiki/%E5%9B%9E%E8%B0%83%E8%B5%A0%E9%80%81%E9%81%93%E5%85%B7%E5%8F%91%E8%B4%A7URL%E7%9A%84%E5%8D%8F%E8%AE%AE%E8%AF%B4%E6%98%8E_V3.0
%% msg=1022&openid=a&payitem=a&discountid=a&token=a&billno=a&zoneid=1&providetype=1
%% 注意
%% true:认为发货成功 php返给腾讯{"ret":0,"msg":"OK"} | Msg 否则php返给腾讯{"ret":x=1,"msg":Msg}
do_request(1022, QS) ->
    lib_player_tencent:call_back_delivery_activity(QS);

%% 模块热更新
%% msg=1023&m=a
do_request(1023, QS) ->
    lib_manage:reload_module(QS);

%% 设定玩家是否受限（rs=0 不受限| rs=1 禁言 | rs=2 禁止登录 | rs=3禁止连接（对付外挂制作者））
%% msg=1024&player_id=12345&rs=1
do_request(1024, QS) ->
    lib_manage:set_restrict_state(QS);

%% 将指定玩家踢下线（配合1024使用效果更佳^_^）
%% msg=1025&player_id=12345
do_request(1025, QS) ->
    lib_manage:kick_player_off(QS);

%% 获取玩家受限情况
%% msg=1026&player_id=12345
do_request(1026, QS) ->
    lib_manage:get_player_restrict_state(QS);


%% 向玩家发送游戏币--活动发送---腾讯逻辑
%% http://wiki.open.qq.com/wiki/v3/pay/send_present
%% msg=1027&playerid=a&amount=1
%% 注意,这里的逻辑是和提前配置好的活动id关联起来的
%% true:认为发货成功 | 其他字符串认为失败,字符串为失败原因
do_request(1027, QS) ->
    lib_player_tencent_activity:tencent_activity_present_gold_interface(QS);


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

