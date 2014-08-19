%%%----------------------------------------------------------------------------------------
%%% @Module  : lib_util
%%% @Author  : all
%%% @Created : 2012-6
%%% @Description:基础库方法维护,这里主要是一些上层的算法
%%%----------------------------------------------------------------------------------------
-module(lib_util_algo).
-include("record.hrl").
-include("common.hrl").

%% 数据处理相关----------------------------------------------

-export([
  append_list/2,

  shuffle/1,
  get_elems_from_head/2,
  get_elem_index/3,

  is_ascii_in_list/2,

  take_first_while/2,
  drop_first_while/2,

  replace_or_insert_list/2,
  key_append_replace/4,
  sort/1,

  set_list_nth/3

]).


%% 将Addition_List中的每一个元素放到Original_List中
%% 特别注意这个方法为了效率的提高合并后的结果会改变顺序,需要顺序使用的列表禁止使用此方法
%% 使用头取得方式,提高效率
%% Addition_List:需要附加进入原列表的新列表
%% Original_List:原列表
%% 返回值:New_List_After_Append:合并后的列表
append_list([], Original_List) when is_list(Original_List) ->
  Original_List;
append_list([Current_Elem | Rest_Addition_List], Original_List) when is_list(Original_List) ->
  append_list(Rest_Addition_List, [Current_Elem | Original_List]).


%% 随机打乱一个列表
%% shuffle(List1) -> List2
%% Takes a list and randomly shuffles it. Relies on random:uniform
shuffle(List) ->
  %% Determine the log n portion then randomize the list.
  randomize(round(math:log(length(List)) + 0.5), List).

randomize(1, List) ->
  randomize(List);
randomize(T, List) ->
  lists:foldl(fun(_E, Acc) ->
    randomize(Acc)
  end, randomize(List), lists:seq(1, (T - 1))).

randomize(List) ->
  D = lists:map(fun(A) ->
    {lib_util_random:rand(), A}
  end, List),
  {_, D1} = lists:unzip(lists:keysort(1, D)),
  D1.


%% 从头部取得指定数量的列表中的项
%% List:源列表
%% Result_List:中间存放过程列表
%% Num:要取得的最大数量,不够的话停止
%% 返回值:相应数量的头部元素列表(注意顺序是反的)
get_elems_from_head(List, Num) ->
  get_elems_from_head(List, [], Num).
get_elems_from_head([], Result_List, _Num) ->
  Result_List;
get_elems_from_head([Current_Elem | Rest_List], Result_List, Num) ->
  case Num > 0 of
    true -> %未取够数量
      get_elems_from_head(Rest_List, [Current_Elem | Result_List], Num - 1);
    false -> %如果已经取够数量
      Result_List
  end.

%% 获取对像在List中的索引(从1开始)
%% 未找到返回0
get_elem_index([], _Elem, _Index) ->
  0;
get_elem_index(List, Elem, Index) ->
  [E | ListLeft] = List,
  if E =:= Elem ->
    Index + 1;
    true ->
      get_elem_index(ListLeft, Elem, Index + 1)
  end.

%% ASCII是否存在于List中
%% 返回值:true:是 | false:否
is_ascii_in_list(ASCII, List) ->
  lists:any(fun(X) -> X =:= ASCII end, List).

%% 获取列表中的第一个满足条件的元素
%% Take first Element while Pred(Item)=true.
%% lib_util:take_first_while(fun(X)-> X>5 end,[1,2,45,56]).
%% -spec take_first_while(fun((T) -> boolean()), [T]) -> [T].
take_first_while(Pred, [H | Tail]) ->
  case Pred(H) of
    true ->
      H;
    false ->
      take_first_while(Pred, Tail)
  end;
take_first_while(Pred, []) when is_function(Pred, 1) -> [].


%% 删除列表中的第一个满足条件的元素,删除后排列顺序不变
%% 第一个参数是列表
%% Pred:判断条件返回true的删除
%% Passed_List:返回的更新后的列表 | 验证通过后的列表
drop_first_while(Pred, List) when is_list(List) ->
  drop_first_while(Pred, List, []).
drop_first_while(_Pred, [], Passed_List) ->
  lists:reverse(Passed_List);
drop_first_while(Pred, [Current_Elem | Rest_List], Passed_List) ->
  case Pred(Current_Elem) of
    true ->
      lists:append(lists:reverse(Passed_List), Rest_List);
    false ->
      drop_first_while(Rest_List, Pred, [Current_Elem | Passed_List])
  end.


%% 列表中存在当前项目就替换,不存在就插入
%% Elem:当前项目
%% List:原列表
%% 返回值:处理后的列表处理
replace_or_insert_list(Elem, List) ->
  List_After_Delete = lists:delete(Elem, List),
  [Elem | List_After_Delete].

%% 替换或者新增tuple到列表中,不存在就新增,存在就替换
%% keyreplace(Key, N, TupleList1, NewTuple) -> TupleList2
%% Types:
%% Key = term()
%% N = integer() >= 1
%% 1..tuple_size(Tuple)
%% TupleList1 = TupleList2 = [Tuple]
%% NewTuple = Tuple
%% Tuple = tuple()
%% Returns a copy of TupleList1 where the first occurrence of a T tuple whose Nth element compares equal to Key is replaced with NewTuple, if there is such a tuple T.
%% if there is not sucha a tuple T then append T into the list
key_append_replace(Key, N, TupleList1, NewTuple) ->
  Delete_List = lists:keydelete(Key, N, TupleList1),
  [NewTuple | Delete_List].


%% @doc quick sort
%% 快速排序
sort([]) ->
  [];
sort([H | T]) ->
  sort([X || X <- T, X < H]) ++ [H] ++ sort([X || X <- T, X >= H]).

%%将列表List中第N个元素的值设为Val
set_list_nth(List, N, Val) ->
  set_list_nth_internal(1, N, List, [], Val).

set_list_nth_internal(_Index, _N, [], TargetList, _Val) ->
  TargetList;

set_list_nth_internal(Index, N, [H | T], TargetList, Val) ->
  NewTargetList = case Index =:= N of
                    true ->
                      TargetList ++ [Val];
                    false ->
                      TargetList ++ [H]
                  end,
  set_list_nth_internal(Index + 1, N, T, NewTargetList, Val).








