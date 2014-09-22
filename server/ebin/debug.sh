ulimit -HSn 102400
export ERL_MAX_PORTS=102400
export ERL_MAX_ETS_TABLES=10000
erl -setcookie angel_trunk_yourname -name angel_debug@127.0.0.1 +K true +P 500000  +hms 8192  +hmbs 8192

