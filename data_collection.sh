#!/bin/bash
sleep_time=${1:-60}
ITER=${2:-1}
LOG_DIR=${3:-/mmtests/mmtests_CI/work/data_collection}

echo $LOG_DIR
exit

sleep $sleep_time
perf record -a -e cycles -c 10000000 -o /mmtests/mmtests_CI/work/data_collection/perf.raw_$ITER sleep 7 &
vmstat 1 10 > /mmtests/mmtests_CI/work/data_collection/vmstat_$ITER &
iostat -Nxmdt  1 10 > /mmtests/mmtests_CI/work/data_collection/iostat_$ITER &

