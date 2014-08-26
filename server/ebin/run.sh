export ERL_MAX_PORTS=102400
export ERL_MAX_ETS_TABLES=10000

erl -setcookie angel_trunk_qfj -detached -name angel_qfj@127.0.0.1 +c +K true +P 500000 +hms 8192 +hmbs 8192 -s main server_start && echo " start ok"

