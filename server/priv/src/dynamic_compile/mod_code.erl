-module(mod_code).
%% 目标代码样例

-export([
  test/0,
  calc_val/2,
  add/2,
  sub/2
]).

test() -> "tjgoahead---- hehe~n".


calc_val(A, B) ->
  {val, A * B}.


add(A, B) ->
  {val, A + B}.

sub(A, B) ->
  A - B.