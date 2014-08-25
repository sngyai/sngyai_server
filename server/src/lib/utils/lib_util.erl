%%%----------------------------------------------------------------------------------------
%%% @Module  : lib_util
%%% @Author  : all
%%% @Created : 2012-6
%%% @Description:基础库方法维护,这里是一些不能明确区分所属类别并且又常用的方法
%%%----------------------------------------------------------------------------------------
-module(lib_util).

-include("common.hrl").

-export([
  for/3,
  md5/1,

  local_path/1,
  get_ip/1,
  get_integer_ip/1,

  get_rec_value/3,
  set_rec_value/4,

  void_fun/2,

  try_spawn/1,

  get_tgw_header_byte_len/0,

  flush_event/1
]).


%% for循环
%% Max:上限,I:开始值, F:循环方法,
%% 返回值[F(I) | ...] 列表,对每个数值进行F操作
for(Max, Max, F) -> [F(Max)];
for(I, Max, F) -> [F(I) | for(I + 1, Max, F)].

%% 转换成HEX格式的md5
md5(S) ->
  lists:flatten([io_lib:format("~2.16.0b", [N]) || N <- binary_to_list(erlang:md5(S))]).


%% @spec local_path(Components) -> string()
%% @doc Return an application-relative directory for this application.
%%      Equivalent to local_path(Components, ?MODULE).
local_path(Components) ->
  local_path(Components, ?MODULE).
%% @spec local_path([string()], Module) -> string()
%% @doc Return an application-relative directory from Module's application.
local_path(Components, Module) ->
  filename:join([get_base_dir(Module) | Components]).
%% @spec get_base_dir(Module) -> string()
%% @doc Return the application directory for Module. It assumes Module is in
%%      a standard OTP layout application in the ebin or src directory.
get_base_dir(Module) ->
  {file, Here} = code:is_loaded(Module),
  filename:dirname(filename:dirname(Here)).

%% 从socket获取整数形式ip
%% Socket:socket
%% 返回值:integer
get_integer_ip(Socket) ->
  case is_port(Socket) of
    true ->
      case inet:peername(Socket) of
        {ok, {{Ip1, Ip2, Ip3, Ip4}, _Port}} ->
          Ip1 * 1000000000 + Ip2 * 1000000 + Ip3 * 1000 + Ip4;
        _Wrong ->
          0
      end;
    false -> 0
  end.


%% 从socket获取来源IP
%% 返回值:string
get_ip(Socket) ->
  case inet:peername(Socket) of
    {ok, {PeerIP, _Port}} ->
      ip_to_list(PeerIP);
    {error, _NetErr} ->
      ""
  end.

ip_to_list(Ip) ->
  case Ip of
    {A1, A2, A3, A4} ->
      [integer_to_list(A1), ".", integer_to_list(A2), ".", integer_to_list(A3), ".", integer_to_list(A4)];
    _ ->
      "-"
  end.

%%-------------------------------动态存取记录字段信息----------------------------------------------------
%% rd(person, {id, name, email}).
%% get_rec_value(name, #person{name="Tianjun"}, record_info(fields, person)).
%% set_rec_value(email, "tj@gmail.com", #person{name="Tianjun", id="1001", email="ok@qq.com"}, record_info(fields, person)).
%%------------------------------------------------------------------------------------------------------
find(Item, List) ->
  find_(Item, List, 1).
find_(_Item, [], _) -> not_found;
find_(Item, [H | T], Count) ->
  case H of
    Item ->
      Count;
    _ ->
      find_(Item, T, Count + 1)
  end.
%% 获取字段Key的Value值
%% 返回 Value
get_rec_value(Key, Rec, RecordInfo) ->
  case find(Key, RecordInfo) of
    not_found ->
      undefined;
    Num ->
      element(Num + 1, Rec)
  end.
%% 设定字段Key的Value值
%% 返回 新Record数据记录
set_rec_value(Key, Value, Rec, RecordInfo) ->
  RecList = tuple_to_list(Rec),
  case find(Key, RecordInfo) of
    not_found ->
      Rec;
    Num ->
      List1 = lists:sublist(RecList, Num),
      List2 = lists:sublist(RecList, Num + 2, length(RecList)),
      List3 = List1 ++ [Value] ++ List2,
      %?T("=======================~p",[List3]),
      list_to_tuple(List3)
  end.




void_fun(_, _) -> void.


%% 带try catch 的spawn
try_spawn(Fun) ->
  spawn(fun() ->
    try
      Fun
    catch
      _:Reason ->
        Stacktrace = erlang:get_stacktrace(),
        ?Error(default_logger, "spawn Error Fun:~p, Reason:~p, Trace:~p~n", [Fun, Reason, Stacktrace]),
        ?T("*****spawn Error Fun:~p :reason:~p,~n stacktrace:~p", [Fun, Reason, Stacktrace])
    end
  end).


%% tgw包头的长度
%% 返回值:数值
get_tgw_header_byte_len() ->
  Tgw_header = get_tgw_header(),
  erlang:byte_size(Tgw_header).
%% 获取tgw包头信息
%% 返回值:二进制
get_tgw_header() ->
  Domain_name = lib_config:get_server_domain_name(),
  {_ip, Port} = lib_config:get_tcp_listener(),
  Str = lists:concat([Domain_name, ":", Port]),
  Bin_Str = lib_util_type:to_binary(Str),
  <<<<"tgw_l7_forward\r\nHost: ">>/binary, Bin_Str/binary, <<"\r\n\r\n">>/binary>>.


%% 清理某种类型的协议请求
%% Cmd:约定协议号
%% 返回值:不使用
flush_event(Cmd) ->
  receive
    {'$gen_cast', {'SOCKET_EVENT', Cmd, _}} ->
      %?T("flush_event cmd:~p", [Cmd]),
      flush_event(Cmd)
  after 0 ->
    %?T("flush_event timeout"),
    ok
  end.





