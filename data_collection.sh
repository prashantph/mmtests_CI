#!/bin/bash

RESULT_DIR=${1:-/mmtests/mmtests_CI/work/data_collection}
WORKLOAD=${2:-"unknown"}
shift 2 
COMMAND=${@:-"sleep 10"}
echo $COMMAND|grep sleep > /dev/null

#use -a option if using  sleep command 
if [ $? -eq 0 ];
then 
	perf_args="-a"
	sleep_delay=60;	
else
	sleep_delay=0;	
	perf_args=""
fi


echo $COMMAND


if [ ! -d "/mmtests/mmtests_CI/work/data_collection" ]; 
then
	mkdir -p /mmtests/mmtests_CI/work/data_collection
fi 
 
sleep $sleep_delay
#Collect CPI
perf stat -e cycles,instructions -o $RESULT_DIR/perf_cpi_$WORKLOAD.out $COMMAND |tee -a $RESULT_DIR/cpi_console.out
sleep 1

#1M cycles
perf record $perf_args -g -c 1000000 -o $RESULT_DIR/perf_cycles_raw_1M_$WORKLOAD $COMMAND |tee -a $RESULT_DIR/cycle_1M_console.out
#perf record -a -g -c 1000000 -o $RESULT_DIR/perf_cycles_raw_1M_$WORKLOAD $COMMAND
sleep 1

#10M cycles
perf record $perf_args -g -c 10000000 -o $RESULT_DIR/perf_cycles_raw_10M_$WORKLOAD $COMMAND |tee -a $RESULT_DIR/cycle_10M_console.out
#perf record -a -g -c 10000000 -o $RESULT_DIR/perf_cycles_raw_10M_$WORKLOAD $COMMAND
perf archive $RESULT_DIR/perf_cycles_raw_10M_$WORKLOAD
sleep 1

#Inst profile
perf record $perf_args -e instructions -g -o $RESULT_DIR/perf_instr_raw_$WORKLOAD $COMMAND |tee -a $RESULT_DIR/instruction_console.out
perf archive $RESULT_DIR/perf_instr_raw_$WORKLOAD
sleep 1

#Capture kallsyms
cat /proc/kallsyms > $RESULT_DIR/kallsyms_syscall_$WORKLOAD

#capture stats 
vmstat 1 10 > $RESULT_DIR/vmstat_$WORKLOAD &
iostat -Nxmdt  1 10 > $RESULT_DIR/iostat_$WORKLOAD &
mpstat -P ALL 1 10 >  $RESULT_DIR/mpstat_$WORKLOAD &

#Generate reports
for x in perf_cycles_raw_1M_$WORKLOAD perf_cycles_raw_10M_$WORKLOAD perf_instr_raw_$WORKLOAD
do
perf report -n --no-children --sort=dso,symbol -i $RESULT_DIR/$x > $RESULT_DIR/${x}.out
done

##perfdd record -a -g -c 10000000 -o $RESULT_DIR/perf.raw.callgraph.dat_$ITER sleep $perf_sleep &
