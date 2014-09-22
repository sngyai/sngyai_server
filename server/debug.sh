ulimit -HSn 102400
export ERL_MAX_PORTS=102400
export ERL_MAX_ETS_TABLES=10000
exec erl -pa deps/*/ebin/ -pa ebin/ -setcookie lizhuan -name node_3@127.0.0.1 -remsh sngyai@127.0.0.1