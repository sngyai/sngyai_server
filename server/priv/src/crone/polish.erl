%%% @author Torbjorn Tornkvist <tobbe@tornkvist.org>
%%% @copyright (C) 2010, Torbjorn Tornkvist

-module(polish).

-export([
  hostname/0
  , gnow/0
  , date/0
  , time/0
]).


gnow() ->
  calendar:datetime_to_gregorian_seconds(calendar:local_time()).

local_time() ->
  calendar:gregorian_seconds_to_datetime(gnow()).

time() ->
  element(2, local_time()).

date() ->
  element(1, local_time()).


hostname() ->
  {ok, Host} = inet:gethostname(),
  Host.

 