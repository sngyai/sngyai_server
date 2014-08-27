%%%-----------------------------------
%%% @Module  : tcp_request_broker
%%% @Created : 2012.06.15
%%% @Description: 读取并处理客户端连接
%%%
%%% 玩家登陆相关逻辑有:policy文件获取/账号登陆/获取角色列表/创建角色/登陆角色
%%% 这个过程的参数有:1>来自平台url的:a.平台编号,b.原始服编号,c.账号,d.时间戳,e.身份认证标识,g.生成的flag
%%% 2>来自玩家输入:a.角色名,b.性别,c.职业(apc_id),d.角色id(选择角色登陆时传递)
%%%
%%%
%%%-----------------------------------
-module(tcp_request_broker).

-include("common.hrl").
-include("protocol.hrl").
-include("global_msg.hrl").

-define(TCP_TIMEOUT, 60 * 1000). % 解析协议超时时间
-define(HEART_TIMEOUT, 60 * 1000). % 心跳包超时时间
-define(HEART_TIMEOUT_TIME, 3).  % 心跳包超时次数
-define(HEADER_LENGTH, 5). % 消息头长度,5个字节,两个字节包长度 + 两个字节协议号 + 1个字节是否压缩

%%记录客户端进程
-record(client, {
  player_pid = undefined, %玩家进程pid
  player_id = 0,        %%玩家id
  acc_id = 0,          %%玩家所属平台id
  server_id = 0,        %%玩家原始服id
  player_account = [],  %%玩家平台账号
  login = 0,           %%玩家是否登录0:否,1:是
  cm = 1,               %%登陆账号的防沉迷信息
  openkey,
  pf,
  pfkey,
  timeout = 0, % 超时次数
  check_login = 0  %是否测试登陆 0:正常登陆 1:测试登陆
}).

-export([start_link/0, init/0]).

%% 启动进程处理socket消息
start_link() ->
  {ok, proc_lib:spawn_link(?MODULE, init, [])}.

%%初始化
init() ->
  %io:format("~p,pid:~p--init ~n", [lib_util_time:get_timestamp(),self()]),
  put(tag, ?MODULE),
  process_flag(trap_exit, true),
  Client = #client{},
  receive
    {go, Socket} ->
      try
        entirety_loop(Socket, Client)
      catch
        _:Reason ->
          Stack_trace = erlang:get_stacktrace(),
          login_lost(Socket, Client, {error, Reason}),
          ?T("broker init catch reason:~p, ~nstacktrace: ~p", [Reason, Stack_trace]),
          ?Error(debug_logger, "get_socket_data reason:~p, trace:~p", [Reason, Stack_trace]),
          error
      end
  end.

%%------------------------------------------------------------------------------
%% 接收来自客户端的数据并处理
%% Socket：socket id
%% Client: client记录
%% 不使用返回值
%%------------------------------------------------------------------------------
entirety_loop(Socket, Client) ->
  %?T("entirety_loop--1"),
  Ref = async_recv(Socket, ?HEADER_LENGTH, ?HEART_TIMEOUT),
  %?T("entirety_loop--2, ref:~p", [Ref]),
  receive
  %%flash安全沙箱
    {inet_async, Socket, Ref, {ok, ?FL_POLICY_REQ}} ->
      %?T("entirety_loop_FL_POLICY_REQ"),
      Len = 23 - ?HEADER_LENGTH,%这里23的意思是<<"<policy-file-request/>\0">>)长度为23,我们已经取了头长度,剩余的要取干净
      async_recv(Socket, Len, ?TCP_TIMEOUT),
      %gen_tcp:recv(Socket, Len, ?TCP_TIMEOUT),
      %?T("entirety_loop_FL_POLICY_REQ1"),
      lib_sender:send_to_socket(Socket, ?FL_POLICY_FILE);
%        {inet_async, Socket, Ref, {ok, XXTEst}} -> %TGW路由
%            ?T("XXTEst:~p", [XXTEst]);
    {inet_async, Socket, Ref, {ok, <<Str_Len_tgw:2/binary-unit:8, Header_tgw/binary>>}} when Header_tgw =:= <<"tgw">> -> %TGW路由
      Len_tgw = lib_util_type:to_integer(Str_Len_tgw),
      ?T("tgw header Str_Len_tgw:~p,len:~p,_Header_tgw:~p", [Len_tgw, Str_Len_tgw, Header_tgw]),
      Len_Rest_Header = Len_tgw - ?HEADER_LENGTH + 2,%剩余的要取干净
      ?T("tgw header len:~p,headerlen:~p", [Len_Rest_Header, ?HEADER_LENGTH]),
      gen_tcp:recv(Socket, Len_Rest_Header, ?TCP_TIMEOUT),
      entirety_loop(Socket, Client);
  %%数据处理
    {inet_async, Socket, Ref, {ok, <<Len:16, Cmd:16, IsZip:8>>}} ->
      %?T("entirety_loop inet_async len:~p,cmd:~p,iszip:~p", [Len, Cmd, IsZip]),
      login_parse_packet(Socket, Client, Cmd, Len, IsZip);
  %%超时处理
    {inet_async, Socket, Ref, {error, timeout}} ->
      %?T("entirety_loop inet_async timeout"),
      case Client#client.timeout >= ?HEART_TIMEOUT_TIME of
        true ->
          login_lost(Socket, Client, {error, timeout});
        false ->
          entirety_loop(Socket, Client#client{timeout = Client#client.timeout + 1})
      end;
  %%用户断开连接或出错
    Other ->
      ?T("tcp_request_broker:entirety_loop:~p~n", [Other]),
      login_lost(Socket, Client, Other)
  end.

%%------------------------------------------------------------------------------
%% 处理登陆前消息
%% Socket:socket
%% Client:client记录
%% Cmd:当前协议号,两个字节大小
%% Len:当前处理的消息包的总长度,消息体的长度=消息包的总长度 - 消息头长度
%% IsZip:是否压缩消息,0:否,1:是
%% 返回值:不使用
%%------------------------------------------------------------------------------
login_parse_packet(Socket, Client, Cmd, Len, IsZip) ->
  %io:format("~p,pid:~p--login_parse_packet ~n", [lib_util_time:get_timestamp(),self()]),
  case analysis_body_data(Socket, Len, IsZip) of
    {ok, Final_Binary} ->
      %?T("broker login_parse_packet a"),
      case routing(Client, Cmd, Final_Binary) of %登陆前,只能处理几个特定类型的消息
        {ok, {heartbeat, _Timestamp}} -> %心跳包
          {ok, Bin} = ?p_account:write(?p_heartbeat_response, <<>>),
          lib_sender:send_to_socket(Socket, Bin), %回应心跳包
          entirety_loop(Socket, Client);
        {ok, p_account_login_request, {Acc_id, Server_id, Cm, Timestamp, Player_account, OpenKey, Pf, PfKey, Flag, Check_Login}} -> %账号登陆请求
          %?T("login_request"),
          case ph_10_account:handle(?p_account_login_request, Socket, {Acc_id, Server_id, Cm, Timestamp, Player_account, OpenKey, Pf, PfKey, Flag}) of
            true -> %登陆成功
              ?T("account login_success"),
              %io:format("~p,pid:~p--p_account_login_request ~n", [lib_util_time:get_timestamp(),self()]),
              Client_Login = Client#client{acc_id = Acc_id, server_id = Server_id, player_account = Player_account, cm = Cm, login = 1, openkey = OpenKey, pf = Pf, pfkey = PfKey, check_login = Check_Login},
              entirety_loop(Socket, Client_Login);
            false ->
              ?T("login_fail"),
              login_lost(Socket, Client, "login fail")
          end;
        {ok, p_is_nickname_occupied_request, NickName} -> %Nickname是否已经被占用
          %?T("broker p_account_check_role_request a"),
          case Client#client.login == 1 of
            true -> %如果已经登陆的话可以获取当前账号角色列表
              ph_10_account:handle(?p_is_nickname_occupied_request, Socket, NickName),
              %?T("~p,pid:~p--p_account_check_role_request ~n", [lib_util_time:get_timestamp(),self()]),
              entirety_loop(Socket, Client);
            false -> %没有登陆就
              ?T("p_account_check_role_request false"),
              login_lost(Socket, Client, "p_account_check_role_request before login")
          end;
        {ok, p_account_check_role_request} -> %账号是否有角色请求
          %?T("broker p_account_check_role_request a"),
          case Client#client.login == 1 of
            true -> %如果已经登陆的话可以获取当前账号角色列表
              ph_10_account:handle(?p_account_check_role_request, Socket, {Client#client.acc_id, Client#client.player_account, Client#client.server_id}),
              %?T("~p,pid:~p--p_account_check_role_request ~n", [lib_util_time:get_timestamp(),self()]),
              entirety_loop(Socket, Client);
            false -> %没有登陆就
              ?T("p_account_check_role_request false"),
              login_lost(Socket, Client, "p_account_check_role_request before login")
          end;
        {ok, p_create_role_request, {Nick_Name, Apc_Id}} ->%创建角色
          case Client#client.login == 1 of
            true -> %如果已经登陆的话可以创建角色
              ph_10_account:handle(?p_create_role_request, Socket, {Client#client.player_account, Client#client.acc_id, Client#client.server_id, Client#client.cm, Nick_Name, Apc_Id}),
              entirety_loop(Socket, Client);
            false -> %没有登陆就
              login_lost(Socket, Client, "create role before login")
          end;
        {ok, p_get_account_role_list_request} -> %请求获取账号角色列表
          case Client#client.login == 1 of
            true -> %如果已经登陆的话可以获取当前账号角色列表
              ph_10_account:handle(?p_get_account_role_list_request, Socket, {Client#client.acc_id, Client#client.player_account, Client#client.server_id}),
              %?T("~p,pid:~p--p_get_account_role_list_request ~n", [lib_util_time:get_timestamp(),self()]),
              entirety_loop(Socket, Client);
            false -> %没有登陆就
              ?T("p_get_account_role_list_request false"),
              login_lost(Socket, Client, "get_account_role before login")
          end;
        {ok, p_check_in_by_playerid_request, Player_Id} ->%进入游戏
          %?T("p_check_in_by_playerid_request ~p~n",[Player_Id]),
          case ph_10_account:handle(?p_check_in_by_playerid_request, Socket, {Client#client.acc_id, Client#client.player_account, Player_Id, self(), Client#client.openkey, Client#client.pf, Client#client.pfkey, Client#client.check_login}) of
            {true, Pid_player} ->
              ?T("player check_in_success ~p~n", [Player_Id]),
              do_parse_packet_catch_ex(Socket, Client#client{player_pid = Pid_player, player_id = Player_Id});
            false ->
              ?T("p_check_in_by_playerid_request stop"),
              stop
          end;
        Other_Routing_Data ->
          %?T("Other_Routing_Data:~p", [Other_Routing_Data]),
          login_lost(Socket, Client, Other_Routing_Data)
      end;
    timeout ->
      %io:format("~p,pid:~p--timeout ~n", [lib_util_time:get_timestamp(),self()]),
      case Client#client.timeout >= ?HEART_TIMEOUT_TIME of
        true ->
          login_lost(Socket, Client, {error, timeout});
        false ->
          entirety_loop(Socket, Client#client{timeout = Client#client.timeout + 1})
      end;
    Other ->
      %?T("login_parse_packet Other:~p", [Other]),
      login_lost(Socket, Client, Other)
  end.

%%------------------------------------------------------------------------------
%%接收来自客户端的数据 - 登陆后进入游戏逻辑
%%Socket：socket id
%%Client: client记录
%%------------------------------------------------------------------------------
do_parse_packet_catch_ex(Socket, Client) ->
  try
    do_parse_packet(Socket, Client)
  catch
    _:Reason ->
      Stack_trace = erlang:get_stacktrace(),
      ?T("broker init catch reason:~p, ~nstacktrace: ~p", [Reason, Stack_trace]),
      do_lost(Socket, Client, do_parse_packet_catch_ex, {error, Reason}),
      ?Error(broker_logger, "do_parse_packet: reason:~p, trace:~p", [Reason, Stack_trace]),
      error
  end.

do_parse_packet(Socket, Client) ->
  Ref = async_recv(Socket, ?HEADER_LENGTH, ?HEART_TIMEOUT),%拉取指定消息头的长度
  receive
    {inet_async, Socket, Ref, {ok, <<Len:16, Cmd:16, IsZip:8>>}} ->
      case analysis_body_data(Socket, Len, IsZip) of
        {ok, BinData} ->
          case routing(Client, Cmd, BinData) of
            {ok, error_protocol} -> %解析出现问题,可能是攻击行为
              mod_player:cast(Client#client.player_pid, error_protocol);
            {ok, Data} ->
              gen_server:cast(Client#client.player_pid, {'SOCKET_EVENT', Cmd, Data});
            _Other_Data ->
              ?Error(broker_logger, "rounting error cmd:~p,result:~p", [Cmd, _Other_Data]),
              ?T("rounting error cmd:~p,result:~p", [Cmd, _Other_Data])
          end,
          do_parse_packet(Socket, Client);
        timeout -> %接受到了超时消息
          case Client#client.timeout >= ?HEART_TIMEOUT_TIME of
            true ->
              do_lost(Socket, Client, timeout1, {error, timeout});
            false ->
              do_parse_packet(Socket, Client#client{timeout = Client#client.timeout + 1})
          end;
        {fail, Other_RecvData} ->
          ?Error(broker_logger, "RecvData error Data:~p", [Other_RecvData]),
          ?T("RecvData error Data:~p", [Other_RecvData]),
          do_lost(Socket, Client, Cmd, Other_RecvData)
      end;
  %%接收到超时消息处理
    {inet_async, Socket, Ref, {error, timeout}} ->
      case Client#client.timeout >= ?HEART_TIMEOUT_TIME of
        true ->
          do_lost(Socket, Client, timeout2, {error, timeout});
        false ->
          do_parse_packet(Socket, Client#client{timeout = Client#client.timeout + 1})
      end;
  %%用户断开连接或出错
    Other_Msg ->
      do_lost(Socket, Client, unkownmsg, Other_Msg)
  end.

%%------------------------------------------------------------------------------
%% 这个方法作用是关闭socket连接,主要用于登录前错误和登陆后循环try catch的错误
%% Socket:当前socket, _Client:当前进程信息,  Reason:断开原因
%%------------------------------------------------------------------------------
login_lost(Socket, _Client, Reason) ->
  case Reason of
    {inet_async, _X, _Y, {error, closed}} ->
      %?T("login lost Client:~p, Reason:~p", [_Client, Reason]),
      skip;
    {'EXIT', _Pid_Link, normal} ->
      ?T("login lost Client:~p, Reason:~p", [_Client, Reason]),
      skip;
    {'EXIT', _Pid_Link, shutdown} ->
      ?T("login lost Client:~p, Reason:~p", [_Client, Reason]),
      skip;
    {fail, {inet_async, _Port, _Id, {error, closed}}} ->
      ?T("login lost Client:~p, Reason:~p", [_Client, Reason]),
      skip;
    {inet_async, _Port, _Id, {error, etimedout}} ->
      ?T("login lost Client:~p, Reason:~p", [_Client, Reason]),
      skip;
    _Other ->
      ?T("login lost Client:~p, Reason:~p", [_Client, Reason]),
      ?Error(debug_logger, "login lost Client:~p, Reason:~p", [_Client, Reason])
  %skip
  end,
  %?Error(broker_logger, "RecvData error Data:~p", [Reason]),
  %timer:sleep(100),
  fixed_close(Socket)
%exit({unexpected_message, Reason})
.
%% 关闭socekt操作,一段时间之后没有返回,就强行杀死
fixed_close(Socket) ->
  catch erlang:port_close(Socket),
  receive
    {'EXIT', Socket, _} ->
      ok
  after 0 ->
    ok
  end,
  ok.
%    receive
%        _ ->
%            case is_process_alive(Pid) of
%                true -> exit(Pid, kill);
%                false -> skip
%            end
%    after 3000 ->
%            case is_process_alive(Pid) of
%                true -> exit(Pid, kill);
%                false -> skip
%            end
%    end.


%%------------------------------------------------------------------------------
%% 退出游戏,这个方法是用来调用清理方法,是登陆成功后的循环中调用
%% Socket:当前socket, Client:当前进程信息, Cmd:当前处理的消息号,有可能不是处理消息中断开的,所以这里可能为0, Reason:断开原因
%%------------------------------------------------------------------------------
do_lost(_Socket, Client, _Cmd, Reason) ->
  case Reason of
    {inet_async, _X, _Y, {error, closed}} ->
      skip;
    _Other ->
      ?T("do_lost Client:~p, Cmd_or_Msg:~p, Reason:~p", [Client, _Cmd, Reason])
  end,
  lib_player_login:logout(Client#client.player_pid, Client#client.player_id, "normal"),
  %   莫删除啊亲
  %    Pid = Client#client.player_pid,
  %    case monitor_child(Client#client.player_pid) of
  %        ok ->
  %            %exit(Pid, shutdown), %% Try to shutdown gracefully
  %            lib_player_login:logout(Client#client.player_pid, 0),
  %            receive
  %                {'DOWN', _MRef, process, Pid, shutdown} ->
  %                    ok;
  %                {'DOWN', _MRef, process, Pid, _OtherReason} ->
  %                    %{error, OtherReason}
  %                    skip
  %            after 100000 ->
  %                    exit(Pid, kill),  %% Force termination.
  %                    receive
  %                        {'DOWN', _MRef, process, Pid, _OtherReason} ->
  %                            %{error, OtherReason}
  %                            skip
  %                    end
  %            end;
  %        {error, _Reason} ->
  %            %{error, Reason}
  %            skip
  %    end,
  %socket处理
  login_lost(_Socket, Client, Reason).

%
% 莫删除啊亲
%monitor_child(Pid) ->
%
%    %% Do the monitor operation first so that if the child dies
%    %% before the monitoring is done causing a 'DOWN'-message with
%    %% reason noproc, we will get the real reason in the 'EXIT'-message
%    %% unless a naughty child has already done unlink…
%    erlang:monitor(process, Pid),
%    unlink(Pid),
%
%    receive
%        %% If the child dies before the unlik we must empty
%        %% the mail-box of the 'EXIT'-message and the 'DOWN'-message.
%        {'EXIT', Pid, Reason} ->
%            receive
%                {'DOWN', _, process, Pid, _} ->
%                    {error, Reason}
%            end
%    after 0 ->
%            %% If a naughty child did unlink and the child dies before
%            %% monitor the result will be that shutdown/2 receives a
%            %% 'DOWN'-message with reason noproc.
%            %% If the child should die after the unlink there
%            %% will be a 'DOWN'-message with a correct reason
%            %% that will be handled in shutdown/2.
%            ok
%    end.


%%------------------------------------------------------------------------------
%% 路由,这里根据cmd路由到对应的协议处理模块,根据约定解析协议内容
%% 组成如:pt_10:read
%% _Client:当前broker状态, Cmd:当前协议号, Binary:待解析的包体数据
%%------------------------------------------------------------------------------
routing(_Client, Cmd, Binary) ->
  %?T("routing--1  cmd:~p, bianry:~p", [Cmd,Binary]),
  try
    %%取前面二位区分功能类型
    [H1, H2, _, _, _] = integer_to_list(Cmd),
    Module = list_to_atom("p_" ++ [H1, H2]),
    %    ?T("routing--2 cmd:~p, Module:~p, data:~p", [Cmd, Module, Module:read(Cmd, Binary)]),
    Module:read(Cmd, Binary)
  catch
    _:Reason ->
      Stack_trace = erlang:get_stacktrace(),
      ?T("broker init catch reason:~p, ~nstacktrace: ~p", [Reason, Stack_trace]),
      ?Error(broker_logger, "do_parse_packet: reason:~p, trace:~p", [Reason, Stack_trace]),
      {ok, error_protocol}
  end.


%%------------------------------------------------------------------------------
%% 异步接收消息
%% Sock:socket, Length:请求长度, Timeout:超时时间
%%------------------------------------------------------------------------------
async_recv(Sock, Length, Timeout) when is_port(Sock) ->
  case prim_inet:async_recv(Sock, Length, Timeout) of
    {error, Reason} -> throw({Reason});
    {ok, Res} -> Res;
    Res -> Res
  end.

%%------------------------------------------------------------------------------
%% 根据包长度和是否压缩解析包体数据,包体数据有可能不存在
%% Socket:当前socket, Packet_Len:当前包长度, IsZip:是否压缩数据:0否, 1:是
%% 返回值:{ok, Binary} | {fail, Other_Msg} | timeout:请求消息体超时
%%------------------------------------------------------------------------------
analysis_body_data(Socket, Packet_Len, IsZip) ->
  %?T("analysis_body_data1 Packet_Len:~p,iszip:~p", [Packet_Len, IsZip]),
  BodyLen = Packet_Len - ?HEADER_LENGTH,
  case BodyLen > 0 of
    true ->
      Ref_Body = async_recv(Socket, BodyLen, ?TCP_TIMEOUT),
      receive
        {inet_async, Socket, Ref_Body, {ok, Binary}} ->
          case IsZip of
            0 ->
              %?T("analysis_body_data2 BodyLen:~p,iszip:~p,binary:~p", [BodyLen, IsZip,Binary]),
              {ok, Binary};
            1 -> %压缩数据的话先解压
              %?T("analysis_body_data3 BodyLen:~p,iszip:~p,binary:~p", [BodyLen, IsZip,Binary]),
              UnBinary = zlib:uncompress(Binary),
              {ok, UnBinary}
          end;
      %%接收到超时消息处理
        {inet_async, Socket, Ref_Body, {error, timeout}} ->
          %?T("analysis_body_data4 BodyLen:~p,iszip:~p", [BodyLen, IsZip]),
          timeout;
        Other_Return ->
          %?T("analysis_body_data5 BodyLen:~p,Other_Return:~p", [Other_Return]),
          {fail, Other_Return}
      end;
    false ->
      %?T("analysis_body_data6 BodyLen:~p", [BodyLen]),
      {ok, <<>>}
  end.


