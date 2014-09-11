ulimit -HSn 102400
export ERL_MAX_PORTS=102400
export ERL_MAX_ETS_TABLES=10000

exec erl  -pa deps/*/ebin/ -pa ebin/ -setcookie lizhuan -detached -name sngyai@127.0.0.1 +c +K true +P 500000 +hms 8192 +hmbs 8192 -s main server_start && echo " start ok"
