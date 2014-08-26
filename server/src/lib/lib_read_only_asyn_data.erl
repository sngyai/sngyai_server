-module(lib_read_only_asyn_data).

-include("common.hrl").
-include("record.hrl").
-include_lib("stdlib/include/ms_transform.hrl").

-export([
  set/1,
  get/1,
  logout/1
]).


set(Data) ->
  ets:insert(?ETS_Asyn_Data, Data),
  ok.


get(PlayerID) ->
  L = ets:lookup(?ETS_Asyn_Data, PlayerID),
  case L of
    [] ->
      [];
    [Data] ->
      set(Data),
      Data
  end.

logout(Status) ->
  L = ets:lookup(?ETS_Asyn_Data, Status#player_status.id),
  case L of
    [] ->
      skip;
    [_] ->
      {ok, _, Data} = lib_player:get_current_player_all_info(Status),
      set(Data)
  end.







