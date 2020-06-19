#!/bin/sh
for i in 1 2 3 4 5
do
#./run-mmtests.sh --config  configs/config-scheduler-schbench scheduler-schbench
#echo "I am $i"
./run-mmtests.sh --config  configs/config-workload-stream-single config-workload-stream-single222
sleep 5
rm -rf /root/mmtests/work/testdata
rm -rf /root/mmtests/work/sources/sockperf-0
done 
