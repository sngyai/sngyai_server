%%%-------------------------------------------------------------------
%%% @author Yudong
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. 八月 2014 22:16
%%%-------------------------------------------------------------------
-module(db_agent_user).
-author("Yudong").

-include("common.hrl").
-include("record.hrl").


%% API
-export([
    create/1,
    update/1,

    get_user_by_name/1,
    get_all_users/0,
    update_score/3,
    set_tokens/2,
    set_account/2
]).

%%创建新用户
create(User) ->
    ValueList = lists:nthtail(1, record2data(User)),
    FieldList = record_info(fields, user),
    {insert, _, _} = ?DB_GAME:insert(db_user, FieldList, ValueList),
    ok.

%%更新记录
update(User) ->
    ValueList = lists:nthtail(2, tuple_to_list(User)),
    [_Id | FieldList] = record_info(fields, user),
    {update, _} = ?DB_GAME:update(db_user, FieldList, ValueList, [{"id", User#user.id}]),
    ok.

get_user_by_name(User) ->
    UserName = lib_util_type:term_to_string(User),
    case ?DB_GAME:select_record_with(user, fun data2record/2, db_user, "*", [{account, UserName}]) of
        {record, UserList} -> {ok, UserList};
        Error ->
            ?T("get_user_by_name: ~p~n", [Error]),
            Error
    end.

%%读取所有用户
get_all_users() ->
    {record_list, Result} = ?DB_GAME:select_record_list_with(user, fun data2record/2, db_user, "*", []),
    Result.

%%更新用户积分
update_score(UserId, ScoreCurrent, ScoreTotal) ->
    {update, _} = ?DB_GAME:update(db_user, [{score_current, ScoreCurrent}, {score_total, ScoreTotal}], [{id, UserId}]).

%%更新用户设备tokens
set_tokens(UserId, Tokens) ->
    {update, _} = ?DB_GAME:update(db_user, [{tokens, Tokens}], [{id, UserId}]).

%%更新用户（支付宝）账号
set_account(UserId, Account) ->
    {update, _} = ?DB_GAME:update(db_user, [{account, Account}], [{id, UserId}]).


data2record(id, Value) ->
    {id, binary_to_list(Value)};
data2record(tokens, Value) ->
    Tokens =
        case Value of
            undefined ->
                undefined;
            Other ->
                binary_to_list(Other)
        end,
    {tokens, Tokens};
data2record(account, Value) ->
  Account =
    case Value of
      undefined ->
        undefined;
      Other ->
        binary_to_list(Other)
    end,
  {account, Account};
data2record(ip, Value) ->
  IPAddress =
    case Value of
      undefined ->
        undefined;
      Other ->
        binary_to_list(Other)
    end,
  {ip, IPAddress};

data2record(Key, Value) ->
    {Key, Value}.



record2data(User) ->
    tuple_to_list(User#user{
    }
    ).

