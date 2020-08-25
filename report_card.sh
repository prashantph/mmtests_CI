   
Result_dir=$1 
NUMCPU=$2  
filename="result_score_card.txt"  
filename_old="result_score_card.txt_OLD" 
 
if [ ! -f $Result_dir/$filename ] 
then   
		touch $Result_dir/$filename 
else   
		mv $Result_dir/$filename $Result_dir/$filename_old  
fi   
 
echo "$Result_dir/$filename" 
echo "RESULT SOCRE CARD"   >> $Result_dir/$filename
echo "###############################################################"   >> $Result_dir/$filename
echo "Workload : Blogbench"   >> $Result_dir/$filename
cat blogbench.out |grep WriteScore|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "WriteScore :  " total/count }'   >> $Result_dir/$filename
cat blogbench.out |grep ReadScore|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "ReadScore :  " total/count }'   >> $Result_dir/$filename
echo "###############################################################"   >> $Result_dir/$filename
echo "Workload : usemem-swap-ramdisk"   >> $Result_dir/$filename
cat usemem-swap-ramdisk.out |grep syst|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "system time :  " total/count "secs" }'   >> $Result_dir/$filename
cat usemem-swap-ramdisk.out |grep elsp|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "elapsed time :  " total/count "secs" }'   >> $Result_dir/$filename
echo "###############################################################"   >> $Result_dir/$filename
echo "Workload : usemem-stress-numa-compact"   >> $Result_dir/$filename
cat usemem-stress-numa-compact.out |grep syst|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "System time :  " total/count "secs" }'   >> $Result_dir/$filename
cat usemem-stress-numa-compact.out |grep elsp|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "elapsed time :  " total/count "secs" }'   >> $Result_dir/$filename
echo "###############################################################"   >> $Result_dir/$filename
echo "Workload : sparsetruncate-tiny"   >> $Result_dir/$filename
cat sparsetruncate-tiny.out |awk '{print $NF}'|awk '{ total += $1; count++ } END { print "average time(16 X 16) :  " total/count  }'   >> $Result_dir/$filename
echo "###############################################################"   >> $Result_dir/$filename
echo "Workload : pgbench-timed-rw-small"   >> $Result_dir/$filename
half_cpu=$(($NUMCPU/2 |bc))
cat pgbench-timed-rw-small.out |grep ^half_cpu|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "tps for clients $NUMCPU/2 :  " total/count  }'   >> $Result_dir/$filename
echo "###############################################################"   >> $Result_dir/$filename
echo "Workload : rt-migration.out"   >> $Result_dir/$filename
cat rt-migration.out |grep task-$NUMCPU-p82 |awk '{print $NF}'|awk '{ total += $1; count++ } END { print "task-$NUMCPU-p82 time :  " total/count "secs" }'   >> $Result_dir/$filename
echo "###############################################################"   >> $Result_dir/$filename
echo "Workload : perfsyscall.out"   >> $Result_dir/$filename
cat perfsyscall.out |awk '{print $NF}'|awk '{ total += $1; count++ } END { print "Time taken  :  " total/count "secs" }'   >> $Result_dir/$filename
echo "###############################################################"   >> $Result_dir/$filename
echo "Workload : sembench-futex"   >> $Result_dir/$filename
cat sembench-futex.out |awk '{print $NF}'|awk '{ total += $1; count++ } END { print "Threads burned  :  " total/count "/secs" }'   >> $Result_dir/$filename
echo "###############################################################"   >> $Result_dir/$filename
echo "Workload : perfpipe"   >> $Result_dir/$filename
cat perfpipe.out |sed -n '1p'|awk '{print "pipe ops/sec: " $1 }'   >> $Result_dir/$filename
echo "###############################################################"   >> $Result_dir/$filename
echo "Workload : hackbench-process-pipes"   >> $Result_dir/$filename
cat hackbench-process-pipes.out |awk '{print $NF}'|awk '{ total += $1; count++ } END { print "Time taken  :  " total/count "secs" }'   >> $Result_dir/$filename
cat hackbench-process-pipes.out|grep ^$NUMCPU |awk '{print $NF}'|awk '{ total += $1; count++ } END { print "Time taken by thread $NUMCPU  :  " total/count "secs" }'   >> $Result_dir/$filename
echo "###############################################################"   >> $Result_dir/$filename
echo "Workload : schbench"   >> $Result_dir/$filename
less_NUMCPU=$(($NUMCPU-1|bc))
 cat schbench.out |grep qrtle-$less_NUMCPU |awk '{print $NF}'|awk '{ total += $1; count++ } END { print "for 79 threads  :  " total/count "usecs" }'   >> $Result_dir/$filename
echo "###############################################################"   >> $Result_dir/$filename
echo "Workload : thpscale.out"   >> $Result_dir/$filename
cat thpscale.out |grep "fault-both"|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "fault-both latency  :  " total/count "usecs" }'   >> $Result_dir/$filename
cat thpscale.out |grep "fault-base"|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "fault-base latency  :  " total/count "usecs" }'   >> $Result_dir/$filename
echo "###############################################################"   >> $Result_dir/$filename
echo "Workload : scale-short"   >> $Result_dir/$filename
cat scale-short.out |grep ^$NUMCPU|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "for thread $NUMCPU  :  " total/count  }'   >> $Result_dir/$filename
echo "###############################################################"   >> $Result_dir/$filename
echo "Workload : sysbench-mariadb-oltp-ro-small"   >> $Result_dir/$filename
cat sysbench-mariadb-oltp-ro-small.out |grep ^$NUMCPU |awk '{print $NF}'|awk '{ total += $1; count++ } END { print "throughput for $NUMCPU threads  :  " total/count "tps" }'   >> $Result_dir/$filename
echo "###############################################################"   >> $Result_dir/$filename
echo "Workload : paralleldd-read-small"   >> $Result_dir/$filename
cat paralleldd-read-small.out |grep ^$NUMCPU |awk '{print $NF}'|awk '{ total += $1; count++ } END { print "latency for $NUMCPU threads  :  " total/count "sec" }'   >> $Result_dir/$filename
echo "###############################################################"   >> $Result_dir/$filename
echo "Workload : iozone"   >> $Result_dir/$filename
cat iozone.out |grep SeqWrite|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "total SeqWrite ops  :  " total/count  }'   >> $Result_dir/$filename
cat iozone.out |grep Rewrite|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "total Rewrite ops  :  " total/count  }'   >> $Result_dir/$filename
cat iozone.out |grep SeqRead |awk '{print $NF}'|awk '{ total += $1; count++ } END { print "total SeqRead ops  :  " total/count  }'   >> $Result_dir/$filename
cat iozone.out |grep Reread|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "total Reread ops  :  " total/count  }'   >> $Result_dir/$filename
cat iozone.out |grep RandRead|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "total RandRead ops  :  " total/count  }'   >> $Result_dir/$filename
cat iozone.out |grep RandWrite|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "total RandWrite ops  :  " total/count  }'   >> $Result_dir/$filename
cat iozone.out |grep BackRead|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "total BackRead ops  :  " total/count  }'   >> $Result_dir/$filename
echo "###############################################################"   >> $Result_dir/$filename
echo "Workload : Blogbench"   >> $Result_dir/$filename
cat blogbench.out|grep WriteScore|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "WriteScore :  " total/count  }'   >> $Result_dir/$filename
cat blogbench.out|grep ReadScore|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "ReadScore :  " total/count  }'   >> $Result_dir/$filename
echo "###############################################################"   >> $Result_dir/$filename
echo "Workload : iperf"   >> $Result_dir/$filename
cat iperf.out|sed -n '1p'|awk '{print "sender throughput: " $1 "(Kbits/sec)"}'   >> $Result_dir/$filename
cat iperf.out|sed -n '2p'|awk '{print "receiver throughput: " $1 "(Kbits/sec)"}'   >> $Result_dir/$filename
echo "###############################################################"   >> $Result_dir/$filename
echo "Workload : netperf-rr-unbound"   >> $Result_dir/$filename
cat netperf-rr-unbound.out |sed -n '2,3p'|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "for TCP :  " total/count "tps"  }'   >> $Result_dir/$filename
cat netperf-rr-unbound.out |sed -n '5,6p'|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "for UDP :  " total/count "tps"  }'   >> $Result_dir/$filename
echo "###############################################################"   >> $Result_dir/$filename
echo "Workload : unixbench"   >> $Result_dir/$filename
cat unixbench.out |grep execl|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "for unixbench-execl :  " total/count  }'   >> $Result_dir/$filename
cat unixbench.out |grep pipe|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "for unixbench-pipe :  " total/count  }'   >> $Result_dir/$filename
cat unixbench.out |grep spawn|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "for unixbench-spawn :  " total/count  }'   >> $Result_dir/$filename
cat unixbench.out |grep syscall|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "for unixbench-syscall :  " total/count  }'   >> $Result_dir/$filename
echo "###############################################################"   >> $Result_dir/$filename
echo "Workload : pgbench-timed-rw-small."   >> $Result_dir/$filename
cat pgbench-timed-rw-small.out |grep ^$half_cpu|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "for $half_cpu threads :  " total/count  }'   >> $Result_dir/$filename
echo "###############################################################"   >> $Result_dir/$filename
echo "Workload : netperf-unbound"   >> $Result_dir/$filename
cat netperf-unbound.out |grep ^163840|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "TCP throughput for size 163840 :  " total/count  }'   >> $Result_dir/$filename
cat netperf-unbound.out |grep recv-163840|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "UDP recv throughput for size 163840 :  " total/count  }'   >> $Result_dir/$filename
cat netperf-unbound.out |grep loss-163840|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "UDP loss throughput for size 163840 :  " total/count  }'   >> $Result_dir/$filename
cat netperf-unbound.out |grep send-163840|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "UDP send throughput for size 163840 :  " total/count  }'   >> $Result_dir/$filename
echo "###############################################################"   >> $Result_dir/$filename
echo "Workload : sockperf-unbound"   >> $Result_dir/$filename
cat sockperf-unbound.out |grep ^850|sed -n '1,5p'|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "TCP throughput for size 850 :  " total/count  }'   >> $Result_dir/$filename
cat sockperf-unbound.out |grep ^850|sed -n '6,10p'|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "UDP throughput for size 850 :  " total/count  }'   >> $Result_dir/$filename
echo "###############################################################"   >> $Result_dir/$filename

