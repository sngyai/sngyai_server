%%%==============================================================================
%%% Author      :fangjie008@163.com
%%% Created     :2012-6
%%% Description :des
%%%==============================================================================
-module(lib_util_random).

-export([
  rand/0,
  rand/2,
  rand/3,

  random_list_item/1,
  random_list_item/2,

  random_result/1,
  random_result_partition/1,

  random_token/0,
  rngchars/1
]).


%% 随机一个介于0到1的小数
%% 返回值0到1的小数
rand() ->
  %% 如果没有种子，将从核心服务器中去获取一个种子，以保证不同进程都可取得不同的种子
  ensure_seed(),
  random:uniform().

%% 产生一个介于Min到Max之间的随机整数(包含Min和Max)
%% Min:起始值
%% Max:最大值
%% 返回值:介于两者之间(包含两者)的值
rand(Same, Same) -> Same;
rand(Min, Max) ->
  ensure_seed(),
  M = Min - 1,
  random:uniform(Max - M) + M.

%% 是否有随机种子,如果当前进程还没有随机种子的话(就是还没有生成过随机数的话)
%% 那么从种子生成器,生成种子,这个生成器是共用的,
%% random生成的随机数是根据当前的seed计算出来的,这个seed种子相同,生成的随机数就相同
%% 返回值:不使用返回值
ensure_seed() ->
  %% 如果没有种子，将从核心服务器中去获取一个种子，以保证不同进程都可取得不同的初始种子
  case get("rand_seed") of % 注意"rand_seed"只是一个标识,标识当前进程是否已经拥有种子
    undefined ->
      RandSeed = mod_random:get_seed(),
      random:seed(RandSeed), %将随机种子设置到random模块使用的进程字典,其实就是当前进程
      put("rand_seed", RandSeed);
    _ -> skip
  end.

%在范围Min~Max之内生成N个随机数
rand(Min, Min, N) when 0 < N ->
  lists:duplicate(N, Min);
rand(Min, Max, N) when Min < Max, 0 < N ->
  rand_r(Min, Max, N, []).

rand_r(_Min, _Max, 0, Ret) ->
  Ret;
rand_r(Min, Max, N, Ret) ->
  rand_r(Min, Max, N - 1, [rand(Min, Max) | Ret]).


%% 等几率随机列表中的一项
%% 随机List中的一项,若list中存在项,随机里面的一项,
%% 若列表是空返回[],一项的话返回唯一项,否则做随机
%% 例如:传入[1,2,3,4,5,6],等几率随机列表中的项目,例如返回4
random_list_item(List) ->
  Len = length(List),
  case Len of
    0 ->%如果是没有元素或者只有一个元素的话,不需要再去随机,效率高,因为这个方法用的地方比较多,效率重要
      [];
    1 ->
      [Item] = List,
      Item;
    _More_Than_One ->
      N = rand(1, Len),
      lists:nth(N, List)
  end.

%% 随机列表中的Num项
%% List:list()
%% Num: integer()
%% 返回值:list()
random_list_item(List, Num) when Num > 0 ->
  Len = length(List),
  case Len =< Num of
    true -> %如果数量不足全返回
      List;
    false ->
      random_list_item_each(List, Num, [], Len)
  end.

%% 随机算法
random_list_item_each(_List, 0, Result, _Len) ->
  Result;
random_list_item_each(List, Num, Result, Len) ->
  N = rand(1, Len),
  Item = lists:nth(N, List),
  random_list_item_each(lists:delete(Item, List), Num - 1, [Item | Result], Len - 1).


%% 随机数比率计算
%% Rate随机比率(0~1小数)
%% 返回值: true:概率成功, false:概率失败
%% 使用场景,例如策划说一个动作触发几率80%,那么就可以传入0.8,看返回值是否为true,为true说明随机成功
random_result(Rate) ->
  rand() < Rate.


%% 比例计算,传入整数值列表,取其和,随机,根据随机数的范围
%% 判断结果在哪个区间
%% RateList:范围项列表
%% 随机数值在那个范围内就返回对应位置,从1开始,即第一项为1
%% 返回值:随机结果索引[A, B, C] 命中谁返回谁的索引
%% 例如:传入[10,50,40],那么几种第一项的几率就是 10/列表总和(10+50+40),几种第二项几率就是 50/总和,以此类推
random_result_partition(RateList) ->
  %%计算总几率的和
  Sum = round(lists:sum(RateList)),
  %%计算随机数,随机数范围在1~Sum 包含 上下限值
  RandomNumber = rand(1, Sum),
  calc_partition(RateList, RandomNumber, 0, 1).

%% 随机数范围划分计算
%% 第一个参数是命中可能性区间列表
%% RandomNum:随机数值,判断它所在区间
%% CurrentSum:当前区间和
%% CurrentIndex:当前区间索引
%% 返回值,返回命中的区间索引
calc_partition([CurrentNum | RestNumList], RandomNum, CurrentSum, CurrentIndex) ->
  case RandomNum =< CurrentSum + CurrentNum of
    true ->
      CurrentIndex;
    false ->
      calc_partition(RestNumList, RandomNum, CurrentSum + CurrentNum, CurrentIndex + 1)
  end.


%% 产生GUID
%% 返回 GUID_String
random_token() ->
  Term = term_to_binary({node(), make_ref()}),
  Digest = erlang:md5(Term),
  binary_to_hex(Digest).

binary_to_hex(Bin) when is_binary(Bin) ->
  [oct_to_hex(N) || <<N:4>> <= Bin].
oct_to_hex(0) -> $0;
oct_to_hex(1) -> $1;
oct_to_hex(2) -> $2;
oct_to_hex(3) -> $3;
oct_to_hex(4) -> $4;
oct_to_hex(5) -> $5;
oct_to_hex(6) -> $6;
oct_to_hex(7) -> $7;
oct_to_hex(8) -> $8;
oct_to_hex(9) -> $9;
oct_to_hex(10) -> $a;
oct_to_hex(11) -> $b;
oct_to_hex(12) -> $c;
oct_to_hex(13) -> $d;
oct_to_hex(14) -> $e;
oct_to_hex(15) -> $f.


-define(SAFE_CHARS, {$a, $b, $c, $d, $e, $f, $g, $h, $i, $j, $k, $l, $m,
  $n, $o, $p, $q, $r, $s, $t, $u, $v, $w, $x, $y, $z,
  $A, $B, $C, $D, $E, $F, $G, $H, $I, $J, $K, $L, $M,
  $N, $O, $P, $Q, $R, $S, $T, $U, $V, $W, $X, $Y, $Z,
  $0, $1, $2, $3, $4, $5, $6, $7, $8, $9, $_}).

%% YA生成随机字符串
%% N 随机字符串长度
%% 返回 Random_String
rngchars(0) ->
  "";
rngchars(N) ->
  [rngchar() | rngchars(N - 1)].

rngchar() ->
  rngchar(crypto:rand_uniform(0, tuple_size(?SAFE_CHARS))).

rngchar(C) ->
  element(1 + C, ?SAFE_CHARS).
