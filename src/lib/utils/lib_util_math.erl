%%%==============================================================================
%%% Author      :all
%%% Created     :2012-6
%%% Description :数学相关基础方法库
%%%==============================================================================
-module(lib_util_math).

-export([
  ceil/1,
  floor/1,
  pow/2,
  get_distance/4
]).


%% 向上取整,支持正负数
%% -1.5 -> -1
%% 1.5 -> 2
ceil(X) when X < 0 ->
  erlang:trunc(X);
ceil(X) ->
  T = erlang:trunc(X),
  case T == X of
    true -> T;
    _ -> T + 1
  end.

%% 向下取整,支持正负数
%% -1.5 -> -2
%% 1.5 -> 1
floor(X) ->
  T = trunc(X),
  case (X < T) of
    true -> T - 1;
    _ -> T
  end.

%% @spec int_pow(X::integer(), N::integer()) -> Y::integer()
%% @doc  整形幂运算.
%%       int_pow(10, 2) = 100.
pow(_X, 0) ->
  1;
pow(X, N) when N > 0 ->
  pow(X, N, 1).

pow(X, N, R) when N < 2 ->
  R * X;
pow(X, N, R) ->
  pow(X * X, N bsr 1, case N band 1 of 1 -> R * X; 0 -> R end).

%% 两点之间的格子距离
%% x1 x坐标1
%% y1 y坐标1
%% x2 x坐标2
%% y2 y坐标2
%% 返回值:两个格子的距离
get_distance(X1, Y1, X2, Y2) ->
  Dx = X1 - X2,
  Dy = Y1 - Y2,
  math:sqrt(0.8 * math:pow(Dx - Dy, 2) + 0.2 * math:pow(Dx + Dy, 2)).
    