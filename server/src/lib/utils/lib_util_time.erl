%%%--------------------------------------------------------------------------------------
%%% @Module  : lib_util_time
%%% @Author  : all
%%% @Created : 2012-6
%%% @Description:时间日期相关基础库方法维护,所有时间日期的相关基础方法维护在这里
%%%  注意{{Year,Month,Day},{0,0,0}} 算是新的一天,就是说在零时,零分,零秒的时候算是第二天
%%%--------------------------------------------------------------------------------------
-module(lib_util_time).

-export([
  get_timestamp/0,
  get_fine_timestamp/0,

  timestamp_to_local_datetime/1,
  timestamp_to_local_daystime/1,

  local_datetime_to_timestamp/1,
  local_date_to_gregorian_days/1,

  is_timestamp_same_day/2,
  is_timestamp_same_week/2,

  timestamp_discrepancy_days/2,


  get_current_day_start_timestamp/0,
  get_weekday_today/0,


  time_format/1,
  date_format/1,
  date_hour_format/1,
  date_hour_minute_format/1,
  minute_second_format/1,
  hour_minute_second_format/1,

  calendar_time_to_crone_time/1
]).

-define(ONE_DAY_SECONDS, 86400).              %%一天的时间（秒）

%% 取得当前的时间戳--这里是utc世界协调时间, 从1970年1月1日{1970, 1, 1} 到现在的时间秒数
%%精确到秒
get_timestamp() ->
  {M, S, _} = erlang:now(),  %Returns the tuple {MegaSecs, Secs, MicroSecs} which is the elapsed time since 00:00 GMT, January 1, 1970 (zero hour)
  M * 1000000 + S.

%% 取得当前的时间戳
%% 精确到毫秒,fine是精细的意思 --这里
%% 返回值:世界协调时间 单位:毫秒
get_fine_timestamp() ->
  {M, S, Ms} = erlang:now(),
  M * 1000000000 + S * 1000 + Ms div 1000.

%% 将一个时间戳(单位秒)-- utc 时间戳
%% TimeStamp_Sconds:我们要转化为
%% 返回值：t_datetime() = {t_date(), t_time()}：
%% t_date() = {year(), month(), day()}
%% t_time() = {hour(), minute(), second()}
timestamp_to_local_datetime(TimeStamp_Seconds) ->
  %utc时间转daytime,1970年1月1日到时间戳的天数,这里转换都是utc时间
  {Days_base_utc, Time_base_utc} = calendar:seconds_to_daystime(TimeStamp_Seconds),
  %计算gregorian天数,计算从初始到1970年1月1日的天数
  Gdays_base_utc = 719528, %calendar:date_to_gregorian_days({1970,1,1}),
  %转UTC得date,总天数可以得到时间戳的 date 年月日
  Udate = calendar:gregorian_days_to_date(Gdays_base_utc + Days_base_utc),
  %比如{{年,月,日},{小时,分钟,秒}} 转换为本地的具体日期
  calendar:universal_time_to_local_time({Udate, Time_base_utc}).

%% 将一个时间戳(单位秒)utc时间戳 转化为天数和时间,本地日期时间相对于0000年1月1日的天数
%% TimeStamp_Sconds:我们要转化为
%% 返回值：{days(), t_time()}：
%% days() = integer,本地日期时间相对于0000年1月1日的天数
%% t_time() = {hour(), minute(), second()}
timestamp_to_local_daystime(TimeStamp_Seconds) ->
  %% 转化为本地日期,时间
  {Date_Local, Time_Local} = timestamp_to_local_datetime(TimeStamp_Seconds),
  Days_Local = calendar:date_to_gregorian_days(Date_Local),
  {Days_Local, Time_Local}.

%% 本地日期时间转化为对应的时间戳,utc时间戳
%% Datetime_Local:t_datetime() = {t_date(), t_time()}：
%% t_date() = {year(), month(), day()}
%% t_time() = {hour(), minute(), second()}
%% 返回值:utc时间戳
local_datetime_to_timestamp(Datetime_Local) ->
  [Datetime_Utc] = calendar:local_time_to_universal_time_dst(Datetime_Local),
  %%罗马的秒数,针对utc时间
  G_Seconds = calendar:datetime_to_gregorian_seconds(Datetime_Utc),
  %%罗马基于utc 1970,1,1的秒数
  BaseDate_Seconds = 62167219200, %calendar:datetime_to_gregorian_seconds({{1970,1,1},{0,0,0}}),
  %% 最终的秒数,utc时间戳
  G_Seconds - BaseDate_Seconds.

%% 两个时间是否同一天(秒)
%% TimeStamp_One:时间1,utc 单位为秒的时间戳
%% TimeStamp_Two:时间2,utc 单位为秒的时间戳
%% 返回值:true:同一天, false:不是同一天
is_timestamp_same_day(TimeStamp_One, TimeStamp_Two) ->
  if
    TimeStamp_Two - TimeStamp_One >= 86400 ->
      false;
    TimeStamp_Two - TimeStamp_One =< -86400 ->
      false;
    true -> %如果符合间隔条件的话继续判断
      {Days1, _Time1} = timestamp_to_local_daystime(TimeStamp_One),
      {Days2, _Time2} = timestamp_to_local_daystime(TimeStamp_Two),
      Days1 =:= Days2
  end.

%% -----------------------------------------------------------------
%% 判断是否同一星期
%% -----------------------------------------------------------------
is_timestamp_same_week(Seconds1, Seconds2) ->
  {{Year1, Month1, Day1}, Time1} = timestamp_to_local_datetime(Seconds1),
  % 星期几
  Week1 = calendar:day_of_the_week(Year1, Month1, Day1),
  % 从午夜到现在的秒数
  Diff1 = calendar:time_to_seconds(Time1),
  Monday = Seconds1 - Diff1 - (Week1 - 1) * ?ONE_DAY_SECONDS,
  Sunday = Seconds1 + (?ONE_DAY_SECONDS - Diff1) + (7 - Week1) * ?ONE_DAY_SECONDS,
  if ((Seconds2 >= Monday) and (Seconds2 < Sunday)) -> true;
    true -> false
  end.

%% 时间1相对时间2过了多少天 可能为负 TimeStamp_One - TimeStamp_Two
%% TimeStamp_One:时间1,utc 单位为秒的时间戳, 作为后来的时间
%% TimeStamp_Two:时间2,utc 单位为秒的时间戳, 作为原始时间
%% 返回值:天数(基于罗马的天数)
timestamp_discrepancy_days(TimeStamp_One, TimeStamp_Two) ->
  {Days_Local_A, _Time_Local_A} = timestamp_to_local_daystime(TimeStamp_One),
  {Days_Local_B, _Time_Local_B} = timestamp_to_local_daystime(TimeStamp_Two),
  Days_Local_A - Days_Local_B.


%% 日期转换为一种天数,用于比对天数的差
%% Date:t_date() = {year(), month(), day()}
%% 返回值:天数(基于罗马的天数)
local_date_to_gregorian_days(Date) ->
  calendar:date_to_gregorian_days(Date).

%% 获取当前时间天开始的timestamp,local时间,时区不同,返回值不同
%% 例如:2011年8月29日13点20秒,返回的就是2011年8月29日00点的timestamp 返回的是标准时间utc
%% 返回值:当天开始的timestamp,标准的timestamp utc时间戳
get_current_day_start_timestamp() ->
  {Date_Local, _Time_Local} = calendar:local_time(),
  local_datetime_to_timestamp({Date_Local, {0, 0, 0}}).

%% 获取今天是星期几
%% 返回值 int 表示星期几
get_weekday_today() ->
  {Date, _Local_Time} = calendar:local_time(),
  Weekday = calendar:day_of_the_week(Date),
  Weekday.


%% 时间相关格式转化
time_format(Now) ->
  {{Y, M, D}, {H, MM, S}} = calendar:now_to_local_time(Now),
  lists:concat([Y, "-", one_to_two(M), "-", one_to_two(D), " ",
    one_to_two(H), ":", one_to_two(MM), ":", one_to_two(S)]).
date_format(Now) ->
  {{Y, M, D}, {_H, _MM, _S}} = calendar:now_to_local_time(Now),
  lists:concat([Y, "-", one_to_two(M), "-", one_to_two(D)]).
date_hour_format(Now) ->
  {{Y, M, D}, {H, _MM, _S}} = calendar:now_to_local_time(Now),
  lists:concat([Y, "-", one_to_two(M), "-", one_to_two(D), " ", one_to_two(H)]).
date_hour_minute_format(Now) ->
  {{Y, M, D}, {H, MM, _S}} = calendar:now_to_local_time(Now),
  lists:concat([Y, "-", one_to_two(M), "-", one_to_two(D), " ", one_to_two(H), "-", one_to_two(MM)]).
%% split by -
minute_second_format(Now) ->
  {{_Y, _M, _D}, {H, MM, _S}} = calendar:now_to_local_time(Now),
  lists:concat([one_to_two(H), "-", one_to_two(MM)]).

hour_minute_second_format(Now) ->
  {{_Y, _M, _D}, {H, MM, S}} = calendar:now_to_local_time(Now),
  lists:concat([one_to_two(H), ":", one_to_two(MM), ":", one_to_two(S)]).

%% 将一个calendar返回的时间转化成mod_crone用的时间格式 舍弃秒
%% 参数 t_time() = {hour(), minute(), second()}
%% 返回值：t_datetime() = {hour(), minute(), am/pm}：

calendar_time_to_crone_time({Hours, Min, _Sec}) ->
  case Hours > 12 of
    true ->
      {Hours - 12, Min, pm};
    false ->
      {Hours, Min, am}
  end.


%% time format
one_to_two(One) -> io_lib:format("~2..0B", [One]).




