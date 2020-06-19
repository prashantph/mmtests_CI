MM_OUT_FILE=/root/mmtests/$LOG/mm_out_file.out
LOG=/root/mmtests/$LOG/

date | tee -a $MM_OUT_FILE

./run-mmtests.sh --config configs/config-io-filebench-oltp-small  filebench        >> $LOG/filebench_oltp.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE

./run-mmtests.sh --config configs/config-io-filebench-oltp-directio-small filebench        >> $LOG/filebench_oltp.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE

./run-mmtests.sh --config configs/config-io-bonniepp-file-async   bonniepp         >> $LOG/bonniepp_file.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE

./run-mmtests.sh --config configs/config-io-bonnie-dir-async      bonnie   >> $LOG/bonnie_dir.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE

./run-mmtests.sh --config configs/config-io-blogbench     blogbench        >> $LOG/blogbench.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE

./run-mmtests.sh --config configs/config-db-sysbench-mariadb-oltp-ro-small       sysbench         >> $LOG/sysbench_mariadb.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE

./run-mmtests.sh --config configs/config-db-sqlite-insert-small  sqlite   >> $LOG/sqlite_insert.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE

./run-mmtests.sh --config configs/config-db-pgbench-timed-rw-small       pgbench  >> $LOG/pgbench_timed.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE

./run-mmtests.sh --config configs/config-reaim-io-alltests        io       >> $LOG/io_alltests.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE

./run-mmtests.sh --config configs/config-pagereclaim-performance  performance      >> $LOG/performance.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE

./run-mmtests.sh --config configs/config-pagealloc-performance    performance      >> $LOG/performance.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE

./run-mmtests.sh --config configs/config-network-sockperf-unbound sockperf         >> $LOG/sockperf_unbound.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE

./run-mmtests.sh --config configs/config-network-sockperf-tcp-throughput  sockperf         >> $LOG/sockperf_tcp.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE

./run-mmtests.sh --config configs/config-network-netperf-unbound  netperf  >> $LOG/netperf_unbound.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE

./run-mmtests.sh --config configs/config-network-netperf-rr-unbound       netperf  >> $LOG/netperf_rr.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE

./run-mmtests.sh --config configs/config-network-iperf-s14-r10000-tcp-unbound     iperf    >> $LOG/iperf_s14.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE

./run-mmtests.sh --config configs/config-ipc-scale-short   scale    >> $LOG/scale_short.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE

./run-mmtests.sh --config configs/config-io-xfsio xfsio    >> $LOG/xfsio.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE

./run-mmtests.sh --config configs/config-io-sparsetruncate-tiny sparsetruncate   >> $LOG/sparsetruncate_tiny.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE

./run-mmtests.sh --config configs/config-io-pgioperf      pgioperf         >> $LOG/pgioperf.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE

./run-mmtests.sh --config configs/config-io-paralleldd-read-small paralleldd       >> $LOG/paralleldd_read.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE

./run-mmtests.sh --config configs/config-io-iozone        iozone   >> $LOG/iozone.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE

./run-mmtests.sh --config configs/config-io-filebench-webproxy-small      filebench        >> $LOG/filebench_webproxy.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE

./run-mmtests.sh --config configs/config-workload-wp-tlbflush     wp       >> $LOG/wp_tlbflush.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE

./run-mmtests.sh --config configs/config-workload-unixbench       unixbench        >> $LOG/unixbench.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE

./run-mmtests.sh --config configs/config-workload-stream-omp-nodes        stream   >> $LOG/stream_omp.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE

./run-mmtests.sh --config configs/config-workload-sembench-futex  sembench         >> $LOG/sembench_futex.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE

./run-mmtests.sh --config configs/config-workload-perfsyscall     perfsyscall      >> $LOG/perfsyscall.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE

./run-mmtests.sh --config configs/config-scheduler-perfpipe-cpufreq       perfpipe         >> $LOG/perfpipe_cpufreq.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE

./run-mmtests.sh --config configs/config-scheduler-forkintensive  forkintensive    >> $LOG/forkintensive.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE

#./run-mmtests.sh --config configs/config-reaim-stress     stress   >> $LOG/stress.out
#rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE

./run-mmtests.sh --config  configs/config-io-fio-randread-direct-multi io-fio-randread-direct-multi    |tee -a $MM_OUT_FILE  >>    $LOG/io-fio-randread-direct-multi.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE

./run-mmtests.sh --config  configs/config-workload-hackbench-process-pipes workload-hackbench-process-pipes    |tee -a $MM_OUT_FILE  >>    $LOG/workload-hackbench-process-pipes.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE

./run-mmtests.sh --config  configs/config-db-sysbench-postgres-oltp-rw-small db-sysbench-postgres-oltp-rw-small    |tee -a $MM_OUT_FILE  >>    $LOG/db-sysbench-postgres-oltp-rw-small.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE

./run-mmtests.sh --config  configs/config-scheduler-schbench scheduler-schbench    |tee -a $MM_OUT_FILE  >>    $LOG/scheduler-schbench.out
rm -rf /root/mmtests/work/testdisk/data/*
sleep 5
date | tee -a $MM_OUT_FILE

