-module(lib_util_string).

-include("common.hrl").

-export([
  string_width/1,
  string_ver/1,

  key_value_to_json/1
]).


%% 字符宽度，1汉字=2单位长度，1数字字母=1单位长度
string_width(String) ->
  string_width(String, 0).
string_width([], Len) ->
  Len;
string_width([H | T], Len) ->
  case H > 255 of
    true ->
      string_width(T, Len + 2);
    false ->
      string_width(T, Len + 1)
  end.


string_ver(Names_for) ->
  Sumxx = lists:foldl(fun(Name_Char, Sum) ->
    if
      Name_Char =:= 8226 orelse Name_Char < 48 orelse (Name_Char > 57 andalso Name_Char < 65) orelse (Name_Char > 90 andalso Name_Char < 95) orelse (Name_Char > 122 andalso Name_Char < 130) ->
        Sum + 1;
      true -> Sum + 0
    end
  end,
    0, Names_for),
  if
    Sumxx =:= 0 ->
      true;
    true ->
      false
  end.


%% key value 转化为string格式,目前key value 要求int类型
%% List:[{Key, Value}]
%% 返回值:string 格式:{"1":1,"2":1}
key_value_to_json(List) ->
  key_value_to_json(List, "").
key_value_to_json([], Str_Json) ->
  lists:concat(["{", Str_Json, "}"]);
key_value_to_json([{Key, Value} | T], Str_Json) when Str_Json =/= "" ->
  Str_Json_Current = lists:concat(["\"", Key, "\":", Value, ",", Str_Json]),
  key_value_to_json(T, Str_Json_Current);
key_value_to_json([{Key, Value} | T], Str_Json) ->
  Str_Json_Current = lists:concat(["\"", Key, "\":", Value, Str_Json]),
  key_value_to_json(T, Str_Json_Current).










