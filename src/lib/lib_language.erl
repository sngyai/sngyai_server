%%%==============================================================================
%%% Author      :fangjie008@163.com
%%% Created     :2012-6
%%% Description :多语言处理
%%%==============================================================================
-module(lib_language).
-include("common.hrl").

-export([
  get_real_laguage_string/1,
  get_real_laguage_string/2
]).

%% 根据语句Lang_Id和参数组合出实际需要展示的中文字符串
%% Lang_Id:字符串标识id, Para_List:参数列表格式[参数1,参数2,参数3]
%% 返回值:处理过语言,参数的字符串
get_real_laguage_string(Lang_Id) ->
  get_real_laguage_string(Lang_Id, []).
get_real_laguage_string(Lang_Id, Para_List) ->
  Language = lib_config:get_language(),
  case catch get_string_by_language_id_para(Language, Lang_Id, Para_List) of
    {'EXIT', Reason} ->
      ?Error(language_logger, "get_real_laguage_string error Language:~p,Lang_Id:~p,para_list:~p,reason:~p", [Language, Lang_Id, Para_List, Reason]),
      "";
    Result ->
      Result
  end.

%% 根据语种和语言id查询应该返回的相应语言的字符串
%% Language:语言, Lang_Id:字符串id, Para_List:参数列表格式[参数1,参数2,参数3]
%% 返回值:处理后的实际应该显示的字符串
get_string_by_language_id_para(Language, Lang_Id, Para_List) ->
  String_Format = get_config_language(Language, Lang_Id),
  case length(Para_List) > 0 of
    false -> %如果没有参数需要处理的话直接返回对应语言的字符串
      String_Format;
    true ->
      deal_para_replace(String_Format, Para_List)
  end.

%% 根据语种和配置id获取配置文件配置的字符串信息
%% Language:语言, Lang_Id:字符串id,
%% 返回值:配置文件配置的信息
get_config_language(Language, Lang_Id) ->
  case config_language:get(Lang_Id) of
    [] ->
      "";
    List_Lang ->
      case length(List_Lang) >= Language of
        false ->
          lists:nth(1, List_Lang);
        true ->
          lists:nth(Language, List_Lang)
      end
  end.


%% 使用参数列表处理字符串,将相应参数替换到字符串中
%% 参数列表从第一个开始往后依次替换字符串中的{1},{2}....这样的占位符
%% String_Format:字符串格式
%% Para_List:参数列表格式[参数1,参数2,参数3]
%% 返回值:相应替换后的字符串
deal_para_replace(String_Format, Para_List) ->
  String_Format_List = case is_binary(String_Format) of false -> String_Format; true ->
    binary_to_list(String_Format) end,
  deal_para_replace_each(String_Format_List, Para_List).

%% 将Para_List替换到string_format中
%% Para_List:需要处理的参数列表
%% String_Format:当前字符串
%Index=string:str(T1," from "),
%   Len=string:len(T1),
%   T2=string:sub_string(T1,Index,Len),
%   Newstring=string:concat("select count(*)",T2),
%   string:str(X,lists:flatten(io_lib:write({1}))).
%   re:replace(String, "\\{1\\}", "nihao", [{return, list}]).
deal_para_replace_each(String_Format, Para_List) ->
  deal_para_replace_each(Para_List, String_Format, 1).
deal_para_replace_each([], String_Format, _Index_Para) ->
  String_Format;
deal_para_replace_each([Para | Rest_Para_List], String_Format, Index_Para) ->
  %Len = string:len(String_Format),
  String_Index = string:str(String_Format, lists:flatten(io_lib:write({Index_Para}))),
  case String_Index > 0 of
    false -> %如果没有匹配的话
      deal_para_replace_each(Rest_Para_List, String_Format, Index_Para + 1);
    true -> %如果查询到了匹配的话,进行替换处理
      %re:replace(String, "\\{1\\}", "nihao", [{return, list}]).
      %lists:flatten([92,123,io_lib:write(1),92,125]).
      String_Format_After_Replace = re:replace(String_Format, lists:flatten([92, 123, io_lib:write(Index_Para), 92, 125]), deal_para_transfer(Para), [{return, list}]),
      deal_para_replace_each(Rest_Para_List, String_Format_After_Replace, Index_Para + 1)
  end.


%% 处理要转换的参数
%% Para:当前要处理的参数
%% 返回值:可以用于替换的参数(字符串或者字符串的二进制形式)
deal_para_transfer(Para) ->
  if
    is_list(Para) ->
      Para;
    is_binary(Para) ->
      Para;
    true ->
      io_lib:write(Para)
  end.

