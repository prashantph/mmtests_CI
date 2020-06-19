#!/bin/bash
#./run-mmtests.sh --config configs/config-io-filebench-oltp-large  filebench        >> results/filebench_oltp.out
#./run-mmtests.sh --config configs/config-io-filebench-oltp-directio-large filebench        >> results/filebench_oltp.out
#./run-mmtests.sh --config configs/config-io-dbench4-fsync dbench4  >> results/dbench4_fsync.out
#./run-mmtests.sh --config configs/config-io-dbench4-async dbench4  >> results/dbench4_async.out
#./run-mmtests.sh --config configs/config-io-bonniepp-file-async   bonniepp         >> results/bonniepp_file.out
#./run-mmtests.sh --config configs/config-io-bonnie-dir-async      bonnie   >> results/bonnie_dir.out
#./run-mmtests.sh --config configs/config-io-blogbench     blogbench        >> results/blogbench.out
#./run-mmtests.sh --config configs/config-http-phpbench    phpbench         >> results/phpbench.out
#./run-mmtests.sh --config configs/config-db-sysbench-postgres-oltp-ro-medium      sysbench         >> results/sysbench_postgres.out
#./run-mmtests.sh --config configs/config-db-sysbench-mariadb-oltp-ro-medium       sysbench         >> results/sysbench_mariadb.out
#./run-mmtests.sh --config configs/config-db-sqlite-insert-medium  sqlite   >> results/sqlite_insert.out
#./run-mmtests.sh --config configs/config-db-pgbench-timed-rw-medium       pgbench  >> results/pgbench_timed.out
#./run-mmtests.sh --config configs/config-reaim-io-alltests        io       >> results/io_alltests.out
#./run-mmtests.sh --config configs/config-pagereclaim-performance  performance      >> results/performance.out
#./run-mmtests.sh --config configs/config-pagealloc-performance    performance      >> results/performance.out
#./run-mmtests.sh --config configs/config-numa-autonumabench       autonumabench    >> results/autonumabench.out
#./run-mmtests.sh --config configs/config-network-tbench-quick     tbench   >> results/tbench_quick.out
#./run-mmtests.sh --config configs/config-network-sockperf-unbound sockperf         >> results/sockperf_unbound.out
#./run-mmtests.sh --config configs/config-network-sockperf-pinned  sockperf         >> results/sockperf_pinned.out
#./run-mmtests.sh --config configs/config-network-sockperf-tcp-throughput  sockperf         >> results/sockperf_tcp.out
#./run-mmtests.sh --config configs/config-network-netperf-unbound  netperf  >> results/netperf_unbound.out
#./run-mmtests.sh --config configs/config-network-netperf-rr-unbound       netperf  >> results/netperf_rr.out
#./run-mmtests.sh --config configs/config-network-iperf-s14-r10000-tcp-unbound     iperf    >> results/iperf_s14.out
#./run-mmtests.sh --config configs/config-memdb-redis-large        redis    >> results/redis_large.out
#Killed redis test as it was running for more than 17 to 18 hours 
#./run-mmtests.sh --config configs/config-jvm-specjvm      specjvm  >> results/specjvm.out
#./run-mmtests.sh --config configs/config-jvm-specjbb2015-single   specjbb2015      >> results/specjbb2015_single.out
#./run-mmtests.sh --config configs/config-jvm-specjbb2015-multi    specjbb2015      >> results/specjbb2015_multi.out
#./run-mmtests.sh --config configs/config-ipc-scale-long   scale    >> results/scale_long.out
#./run-mmtests.sh --config configs/config-io-xfsio xfsio    >> results/xfsio.out
#./run-mmtests.sh --config configs/config-io-sparsetruncate-large  sparsetruncate   >> results/sparsetruncate_large.out
#./run-mmtests.sh --config configs/config-io-seeker-file-write     seeker   >> results/seeker_file.out
#./run-mmtests.sh --config configs/config-io-seeker-file-read      seeker   >> results/seeker_file.out
#./run-mmtests.sh --config configs/config-io-pgioperf      pgioperf         >> results/pgioperf.out
#killed since pgioperf using more disk size and no space left on device 
./run-mmtests.sh --config configs/config-io-paralleldd-read-large paralleldd       >> results/paralleldd_read.out
./run-mmtests.sh --config configs/config-io-iozone        iozone   >> results/iozone.out
./run-mmtests.sh --config configs/config-io-filebench-webproxy-large      filebench        >> results/filebench_webproxy.out
./run-mmtests.sh --config configs/config-workload-wp-tlbflush     wp       >> results/wp_tlbflush.out
./run-mmtests.sh --config configs/config-workload-unixbench       unixbench        >> results/unixbench.out
./run-mmtests.sh --config configs/config-workload-stream-omp-nodes        stream   >> results/stream_omp.out
./run-mmtests.sh --config configs/config-workload-sembench-futex  sembench         >> results/sembench_futex.out
./run-mmtests.sh --config configs/config-workload-rt-migration    rt       >> results/rt_migration.out
./run-mmtests.sh --config configs/config-workload-perfsyscall     perfsyscall      >> results/perfsyscall.out
./run-mmtests.sh --config configs/config-workload-pedsort pedsort  >> results/pedsort.out
./run-mmtests.sh --config configs/config-workload-mlc-peak-bandwidth      mlc      >> results/mlc_peak.out
./run-mmtests.sh --config configs/config-speccpu2017-speed-parallel-full  speed    >> results/speed_parallel.out
./run-mmtests.sh --config configs/config-speccpu2017-rate-parallel-full   rate     >> results/rate_parallel.out
./run-mmtests.sh --config configs/config-serverpair-sockperf      sockperf         >> results/sockperf.out
./run-mmtests.sh --config configs/config-serverpair-network-streaming     network  >> results/network_streaming.out
./run-mmtests.sh --config configs/config-scheduler-perfpipe-cpufreq       perfpipe         >> results/perfpipe_cpufreq.out
./run-mmtests.sh --config configs/config-scheduler-forkintensive  forkintensive    >> results/forkintensive.out
./run-mmtests.sh --config configs/config-reaim-stress     stress   >> results/stress.out
