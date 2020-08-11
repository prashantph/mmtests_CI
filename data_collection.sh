#!/bin/bash
sleep_time=${1:-20}
LOG_DIR=${2:-/mmtests/mmtests_CI/work/data_collection}
ITER=${3:-1}

if [ -d "/mmtests/mmtests_CI/work/data_collection" ] 
then
	mkdir -p /mmtests/mmtests_CI/work/data_collection
fi 

sleep $sleep_time
perf record -a -g -c 10000000 -o $LOG_DIR/perf.raw.callgraph.dat_$i sleep 10 &
vmstat 1 10 > $LOG_DIR/vmstat_$ITER &
iostat -Nxmdt  1 10 > $LOG_DIR/iostat_$ITER &
mpstat -P ALL 1 10 >  $LOG_DIR/mpstat_$ITER &
