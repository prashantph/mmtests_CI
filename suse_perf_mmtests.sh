
MM_OUT_FILE=/root/mmtests/results/mm_out_file.out
LOG=/root/mmtests/results/

date | tee -a $MM_OUT_FILE
#./run-mmtests.sh --config  configs/config-workload-libmicro-smallbatch  workload-libmicro-smallbatch    |tee -a $MM_OUT_FILE  >>    $LOG/workload-libmicro-smallbatch.out
#rm -rf /root/mmtests/work/testdisk/data/*
#sleep 5
#date | tee -a $MM_OUT_FILE 

#echo "-------------------------------------------------------------------------------------"
#./run-mmtests.sh --config  configs/config-http-siege  http-siege    |tee -a $MM_OUT_FILE  >>    $LOG/http-siege.out
#rm -rf /root/mmtests/work/testdisk/data/*
#sleep 5
#date | tee -a $MM_OUT_FILE 

echo "-------------------------------------------------------------------------------------"
rm -rf /root/mmtests/work/sources/sockperf-0
./run-mmtests.sh --config  configs/config-network-sockperf-tcp-throughput-small network-sockperf-tcp-throughput-small    |tee -a $MM_OUT_FILE  >>    $LOG/network-sockperf-tcp-throughput-small.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE 

echo "-------------------------------------------------------------------------------------"
./run-mmtests.sh --config  configs/config-network-iperf-s14-r10000-tcp-unbound network-iperf-s14-r10000-tcp-unbound    |tee -a $MM_OUT_FILE  >>    $LOG/network-iperf-s14-r10000-tcp-unbound.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE 

echo "-------------------------------------------------------------------------------------"
./run-mmtests.sh --config  configs/config-network-netperf-unix-unbound network-netperf-unix-unbound    |tee -a $MM_OUT_FILE  >>    $LOG/network-netperf-unix-unbound.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE 

echo "-------------------------------------------------------------------------------------"
./run-mmtests.sh --config  configs/config-io-iozone-small io-iozone-small    |tee -a $MM_OUT_FILE  >>    $LOG/io-iozone-small.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE 

echo "-------------------------------------------------------------------------------------"
./run-mmtests.sh --config  configs/config-io-fio-randread-direct-multi io-fio-randread-direct-multi    |tee -a $MM_OUT_FILE  >>    $LOG/io-fio-randread-direct-multi.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE 

echo "-------------------------------------------------------------------------------------"
./run-mmtests.sh --config  configs/config-io-bonnie-file-async io-bonnie-file-async    |tee -a $MM_OUT_FILE  >>    $LOG/io-bonnie-file-async.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE 

echo "-------------------------------------------------------------------------------------"
./run-mmtests.sh --config  configs/config-io-dbench4-async io-dbench4-async    |tee -a $MM_OUT_FILE  >>    $LOG/io-dbench4-async.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE 

echo "-------------------------------------------------------------------------------------"
./run-mmtests.sh --config  configs/config-db-pgbench-timed-ro-small db-pgbench-timed-ro-small    |tee -a $MM_OUT_FILE  >>    $LOG/db-pgbench-timed-ro-small.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE 

echo "-------------------------------------------------------------------------------------"
./run-mmtests.sh --config  configs/config-db-pgbench-timed-rw-small db-pgbench-timed-rw-small    |tee -a $MM_OUT_FILE  >>    $LOG/db-pgbench-timed-rw-small.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE 

echo "-------------------------------------------------------------------------------------"
./run-mmtests.sh --config  configs/config-workload-hackbench-process-pipes workload-hackbench-process-pipes    |tee -a $MM_OUT_FILE  >>    $LOG/workload-hackbench-process-pipes.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE 

echo "-------------------------------------------------------------------------------------"
./run-mmtests.sh --config  configs/config-db-sysbench-mariadb-oltp-rw-small db-sysbench-mariadb-oltp-rw-small    |tee -a $MM_OUT_FILE  >>    $LOG/db-sysbench-mariadb-oltp-rw-small.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE 

echo "-------------------------------------------------------------------------------------"
./run-mmtests.sh --config  configs/config-db-sysbench-postgres-oltp-rw-small db-sysbench-postgres-oltp-rw-small    |tee -a $MM_OUT_FILE  >>    $LOG/db-sysbench-postgres-oltp-rw-small.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE 

echo "-------------------------------------------------------------------------------------"
./run-mmtests.sh --config  configs/config-scheduler-schbench scheduler-schbench    |tee -a $MM_OUT_FILE  >>    $LOG/scheduler-schbench.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE 

echo "-------------------------------------------------------------------------------------"
./run-mmtests.sh --config  configs/config-workload-stream-single workload-stream-single    |tee -a $MM_OUT_FILE  >>    $LOG/workload-stream-single.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE 

echo "-------------------------------------------------------------------------------------"
echo "starting post process \n"
./extract_average.sh 
echo "post processing ended \n"
