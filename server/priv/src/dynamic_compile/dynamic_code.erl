%%%----------------------------------------------------------------------
%%%		动态编译模块
%%% 		将目标模块代码字符串序列，动态编译并加载至运行VM中执行
%%%        动态调用执行，每次动态编译相当于一次热更新替换.
%%% 	    @author angine
%%%        例如：
%%% 						dynamic_code:c().
%%% 						mod_code:test().
%%% 					    mod_code:calc_val(10,20).
%%%----------------------------------------------------------------------

-module(dynamic_code).

-export([c/1, fc/1]).
-export([t/0, t1/0]).

-define(Mod_Name, "mod_code").

%% ----------------------------------------------------------------------
%% 					动态编译
%% 		参数  File  目标源代码文件路径  例如: File = "../ebin/mod_code.erl",
%% ----------------------------------------------------------------------
fc(File) ->
  try
    {ok, Binary} = file:read_file(File),
    % 过滤 回车换行
    Bin_Str_Code = binary:replace(Binary, [<<"\r">>], <<>>, [global]),
    %io:format("New_Str_Code: ~p~n",[Bin_Str_Code]),
    Str_Code = binary_to_list(Bin_Str_Code),
    %io:format("Str_Code: ~p~n",[Str_Code]),
    c(Str_Code)
  catch
    Type:Error ->
      io:format("exception: ~p   ~p ~n", [Type, Error])
  end.

%% ----------------------------------------------------------------------
%% 					动态编译
%%  参数 Str_Code type String  模块源代码 字符串类型
%% ----------------------------------------------------------------------
c(Str_Code) ->
  try
    {Mod, BinCode} = dynamic_compile:from_string(Str_Code),
    io:format("mod name: ~p~n", [Mod]),
    code:purge(Mod),
    code:load_binary(Mod, tool:to_list(Mod) ++ ".erl", BinCode)
  catch
    Type:Error ->
      io:format("Error compiling logger (~p): ~p~n", [Type, Error])
  end.


%% ----------------------------------------------------------------------
%% 					 动态编译  测试
%% ----------------------------------------------------------------------
t() ->
  c(code_src()).

t1() ->
  File = "../ebin/mod_code.erl",
  fc(File).


%% ----------------------------------------------------------------------
%% 					源代码示例 
%% ----------------------------------------------------------------------
code_src() ->
  "-module(mod_code).

  -export([
        test/0,
               calc_val/2,
        add/2
      ]).
%% 测试输出
 test() -> \"erlang, hello~world~n\" .

%% 计算乘积
calc_val(A,B) ->
{val,A*B}.

%% 计算加
add(A,B) ->
{val,A+B}.
".
