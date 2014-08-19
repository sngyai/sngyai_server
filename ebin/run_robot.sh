ulimit -HSn 102400
export ERL_MAX_PORTS=102400
export ERL_MAX_ETS_TABLES=10000

erl -setcookie angel_robot_qfj  -name angel_robot_qfj@127.0.0.1 +c +K true +P 500000 +hms 8192 +hmbs 8192 -s rbm app_start

