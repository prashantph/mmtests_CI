   
Result_dir=$1 
NUMCPU=$(grep -c '^processor' /proc/cpuinfo)  
filename="result_score_card.csv"  
filename_old="result_score_card.csv_OLD" 
 
if [ ! -f $Result_dir/$filename ] 
then   
		touch $Result_dir/$filename 
else   
		mv $Result_dir/$filename $Result_dir/$filename_old  
fi   
 
cat $1/blogbench.out |grep WriteScore|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "BlogBench: WriteScore ,  " total/count }'   >> $Result_dir/$filename
cat $1/blogbench.out |grep ReadScore|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "Blogbench: ReadScore ,  " total/count }'   >> $Result_dir/$filename

cat $1/usemem-swap-ramdisk.out |grep syst|awk '{print $NF}'|awk '{ total += $1; count++ } END { print " usemem-swap-ramdisk: system time ,  " total/count "secs" }'   >> $Result_dir/$filename
cat $1/usemem-swap-ramdisk.out |grep elsp|awk '{print $NF}'|awk '{ total += $1; count++ } END { print " usemem-swap-ramdisk : elapsed time ,  " total/count "secs" }'   >> $Result_dir/$filename

cat $1/usemem-stress-numa-compact.out |grep syst|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "usemem-stress-numa-compact : System time   " total/count "secs" }'   >> $Result_dir/$filename
cat $1/usemem-stress-numa-compact.out |grep elsp|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "usemem-stress-numa-compact : elapsed time ,  " total/count "secs" }'   >> $Result_dir/$filename

cat $1/sparsetruncate-tiny.out |awk '{print $NF}'|awk '{ total += $1; count++ } END { print "sparsetruncate-tiny : average time(16 X 16) ,  " total/count  }'   >> $Result_dir/$filename

half_cpu=$(($NUMCPU/2 |bc))
cat $1/pgbench-timed-rw-small.out |grep ^half_cpu|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "pgbench-timed-rw-small : tps for clients $NUMCPU/2 ,  " total/count  }'   >> $Result_dir/$filename

cat $1/rt-migration.out |grep task-$NUMCPU-p82 |awk '{print $NF}'|awk '{ total += $1; count++ } END { print "rt-migration : task-$NUMCPU-p82 time ,  " total/count "secs" }'   >> $Result_dir/$filename

cat $1/perfsyscall.out |awk '{print $NF}'|awk '{ total += $1; count++ } END { print "perfsyscall : Time taken  ,  " total/count "secs" }'   >> $Result_dir/$filename

cat $1/sembench-futex.out |awk '{print $NF}'|awk '{ total += $1; count++ } END { print "sembench-futex : Threads burned  ,  " total/count "/secs" }'   >> $Result_dir/$filename

cat $1/perfpipe.out |sed -n '1p'|awk '{print "perfpipe : pipe ops/sec, " $1 }'   >> $Result_dir/$filename

cat $1/hackbench-process-pipes.out |awk '{print $NF}'|awk '{ total += $1; count++ } END { print "hackbench-process-pipes : Time taken  ,  " total/count "secs" }'   >> $Result_dir/$filename
cat $1/hackbench-process-pipes.out|grep ^$NUMCPU |awk '{print $NF}'|awk '{ total += $1; count++ } END { print "hackbench-process-pipes :  Time taken by thread $NUMCPU  ,  " total/count "secs" }'   >> $Result_dir/$filename

less_NUMCPU=$((NUMCPU-1|bc))
 cat $1/schbench.out |grep qrtle-$less_NUMCPU |awk '{print $NF}'|awk '{ total += $1; count++ } END { print "schbench : for $less_NUMCPU threads  ,  " total/count "usecs" }'   >> $Result_dir/$filename

cat $1/thpscale.out |grep "fault-both"|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "thpscale : fault-both latency ,  " total/count "usecs" }'   >> $Result_dir/$filename
cat $1/thpscale.out |grep "fault-base"|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "thpscale : fault-base latency  ,  " total/count "usecs" }'   >> $Result_dir/$filename


cat $1/scale-short.out |grep ^$NUMCPU|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "scale-short : for thread $NUMCPU  ,  " total/count  }'   >> $Result_dir/$filename

cat $1/sysbench-mariadb-oltp-ro-small.out |grep ^$NUMCPU |awk '{print $NF}'|awk '{ total += $1; count++ } END { print "sysbench-mariadb-oltp-ro-small : throughput for $NUMCPU threads  ,  " total/count "tps" }'   >> $Result_dir/$filename


cat $1/paralleldd-read-small.out |grep ^$NUMCPU |awk '{print $NF}'|awk '{ total += $1; count++ } END { print "paralleldd-read-small : latency for $NUMCPU threads  ,  " total/count "sec" }'   >> $Result_dir/$filename


cat $1/iozone.out |grep SeqWrite|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "iozone : total SeqWrite ops  ,  " total/count  }'   >> $Result_dir/$filename
cat $1/iozone.out |grep Rewrite|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "iozone : total Rewrite ops  ,  " total/count  }'   >> $Result_dir/$filename
cat $1/iozone.out |grep SeqRead |awk '{print $NF}'|awk '{ total += $1; count++ } END { print "iozone : total SeqRead ops  ,  " total/count  }'   >> $Result_dir/$filename
cat $1/iozone.out |grep Reread|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "iozone : total Reread ops  ,  " total/count  }'   >> $Result_dir/$filename
cat $1/iozone.out |grep RandRead|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "iozone : total RandRead ops  ,  " total/count  }'   >> $Result_dir/$filename
cat $1/iozone.out |grep RandWrite|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "iozone : total RandWrite ops  ,  " total/count  }'   >> $Result_dir/$filename
cat $1/iozone.out |grep BackRead|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "iozone : total BackRead ops  ,  " total/count  }'   >> $Result_dir/$filename

cat $1/iperf.out|sed -n '1p'|awk '{print "iperf : sender throughput , " $1 "(Kbits/sec)"}'   >> $Result_dir/$filename
cat $1/iperf.out|sed -n '2p'|awk '{print "iperf : receiver throughput , " $1 "(Kbits/sec)"}'   >> $Result_dir/$filename

cat $1/netperf-rr-unbound.out |sed -n '2,3p'|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "netperf-rr-unbound : for TCP ,  " total/count "tps"  }'   >> $Result_dir/$filename
cat $1/netperf-rr-unbound.out |sed -n '5,6p'|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "netperf-rr-unbound : for UDP ,  " total/count "tps"  }'   >> $Result_dir/$filename
 
cat $1/unixbench.out |grep execl|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "unixbench : unixbench-execl ,  " total/count  }'   >> $Result_dir/$filename
cat $1/unixbench.out |grep pipe|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "unixbench :  unixbench-pipe ,  " total/count  }'   >> $Result_dir/$filename
cat $1/unixbench.out |grep spawn|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "unixbench :  unixbench-spawn ,  " total/count  }'   >> $Result_dir/$filename
cat $1/unixbench.out |grep syscall|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "unixbench :  unixbench-syscall ,  " total/count  }'   >> $Result_dir/$filename

cat $1/pgbench-timed-rw-small.out |grep ^$half_cpu|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "pgbench-timed-rw-small :  $half_cpu threads ,  " total/count  }'   >> $Result_dir/$filename

cat $1/netperf-unbound.out |grep ^163840|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "netperf-unbound : TCP throughput for size 163840 ,  " total/count  }'   >> $Result_dir/$filename
cat $1/netperf-unbound.out |grep recv-163840|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "netperf-unbound : UDP recv throughput for size 163840 ,  " total/count  }'   >> $Result_dir/$filename
cat $1/netperf-unbound.out |grep loss-163840|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "netperf-unbound : UDP loss throughput for size 163840 ,  " total/count  }'   >> $Result_dir/$filename
cat $1/netperf-unbound.out |grep send-163840|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "netperf-unbound : UDP send throughput for size 163840 ,  " total/count  }'   >> $Result_dir/$filename

cat $1/sockperf-unbound.out |grep ^850|sed -n '1,5p'|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "sockperf-unbound : TCP throughput for size 850 ,  " total/count  }'   >> $Result_dir/$filename
cat $1/sockperf-unbound.out |grep ^850|sed -n '6,10p'|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "sockperf-unbound : UDP throughput for size 850 ,  " total/count  }'   >> $Result_dir/$filename


cat $1/netperf-unbound.out |grep send-16384 |awk '{print $NF}'|awk '{ total += $1; count++ } END { print " netperf-unbound:send-16384 , " total/count  }' >> $Result_dir/$filename
cat $1/netperf-unbound.out |grep recv-16384 |awk '{print $NF}'|awk '{ total += $1; count++ } END { print " netperf-unbound:recv-16384 , " total/count  }' >> $Result_dir/$filename
cat $1/netperf-unbound.out |grep loss-16384 |awk '{print $NF}'|awk '{ total += $1; count++ } END { print " netperf-unbound:loss-16384 , " total/count  }'  >> $Result_dir/$filename


cat $1/stream-omp-nodes.out |awk '{ print "stream : "$1 "," $3}'|tail -4 >> $Result_dir/$filename

cat $1/forkintensive.out |sed -n '1p'|awk '{print "forkintensive : process-pipes , " $1}' >> $Result_dir/$filename
cat $1/forkintensive.out |sed -n '2p'|awk '{print "forkintensive : process-sockets , " $1}' >> $Result_dir/$filename
cat $1/forkintensive.out |sed -n '3p'|awk '{print "forkintensive : thread-pipes , " $1}' >> $Result_dir/$filename
cat $1/forkintensive.out |sed -n '4p'|awk '{print "forkintensive : thread-sockets , " $1}' >> $Result_dir/$filename

 cat $1/io-alltest.out|sed -n '1p'|awk '{print "io-alltest : Max Jobs per Minute ," $1 }' >> $Result_dir/$filename


