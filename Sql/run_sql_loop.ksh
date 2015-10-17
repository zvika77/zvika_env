#!/bin/ksh



counter=$1
script=$2
param2=$3
param3=$4
param4=$5




./watch.bash  $counter  "./run_sql_noecho.ksh $script $param2 $param3 $param4 "
