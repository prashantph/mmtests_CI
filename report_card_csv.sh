   
Result_dir=$1 
Log_dir=$2 
NUMCPU=$(grep -c '^processor' /proc/cpuinfo)  
filename="result_score_card.csv"  
filename_old="result_score_card.csv_OLD" 
 
if [ ! -f $Result_dir/$filename ] 
then   
		touch $Result_dir/$filename 
else   
		mv $Result_dir/$filename $Result_dir/$filename_old  
fi   
 
cat $1/usemem-swap-ramdisk.out |grep syst|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "usemem-swap-ramdisk: system time ,  " total/count  }'   >> $Result_dir/$filename
cat $1/usemem-swap-ramdisk.out |grep elsp|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "usemem-swap-ramdisk : elapsed time ,  " total/count  }'   >> $Result_dir/$filename

cat $1/usemem-stress-numa-compact.out |grep syst|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "usemem-stress-numa-compact : System time ,   " total/count  }'   >> $Result_dir/$filename
cat $1/usemem-stress-numa-compact.out |grep elsp|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "usemem-stress-numa-compact : elapsed time ,  " total/count }'   >> $Result_dir/$filename


cat $1/perfsyscall.out |awk '{print $NF}'|awk '{ total += $1; count++ } END { print "perfsyscall : Time taken  ,  " total/count "secs" }'   >> $Result_dir/$filename
echo "cat $1/perfsyscall.out |awk '{print $NF}'|awk '{ total += $1; count++ } END { print "perfsyscall : Time taken  ,  " total/count "secs" }'   >> $Result_dir/$filename
"
cat $1/sembench-futex.out |awk '{print $NF}'|awk '{ total += $1; count++ } END { print "sembench-futex : Threads burned  ,  " total/count }'   >> $Result_dir/$filename

cat $1/perfpipe.out |sed -n '1p'|awk '{print "perfpipe : pipe ops/sec, " $1 }'   >> $Result_dir/$filename
echo "cat $1/perfpipe.out |sed -n '1p'|awk '{print "perfpipe : pipe ops/sec, " $1 }'   >> $Result_dir/$filename"

cat $1/hackbench-process-pipes.out |awk '{print $NF}'|awk '{ total += $1; count++ } END { print "hackbench-process-pipes : Time taken  ,  " total/count }'   >> $Result_dir/$filename
cat $1/hackbench-process-pipes.out|grep ^$NUMCPU |awk '{print $NF}'|awk '{ total += $1; count++ } END { print "hackbench-process-pipes :  Time taken by thread $NUMCPU  ,  " total/count }'   >> $Result_dir/$filename

less_NUMCPU=$((NUMCPU-1|bc))
 cat $1/schbench.out |grep qrtle-$less_NUMCPU |awk '{print $NF}'|awk '{ total += $1; count++ } END { print "schbench : for $less_NUMCPU threads  ,  " total/count  }'   >> $Result_dir/$filename

cat $1/thpscale.out |grep "fault-both"|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "thpscale : fault-both latency ,  " total/count  }'   >> $Result_dir/$filename
cat $1/thpscale.out |grep "fault-base"|awk '{print $NF}'|awk '{ total += $1; count++ } END { print "thpscale : fault-base latency  ,  " total/count }'   >> $Result_dir/$filename



cat $1/iperf.out|sed -n '1p'|awk '{print "iperf : sender throughput , " $1 }'   >> $Result_dir/$filename
cat $1/iperf.out|sed -n '2p'|awk '{print "iperf : receiver throughput , " $1 }'   >> $Result_dir/$filename

cat $1/netperf-rr-unbound.out | grep -v Operation|head -1 |awk '{print "netperf-rr-unbound : for TCP ,  "$4}'  >> $Result_dir/$filename
cat $1/netperf-rr-unbound.out |grep -v Operation|tail -1 |awk '{print "netperf-rr-unbound : for UDP ,  "$4}'   >> $Result_dir/$filename
 
cat $1/unixbench.out | grep -v Operation | grep -v unixbench-dhry2reg-1|awk '{print $1" , " $4}'  >> $Result_dir/$filename

cat $1/sockperf-unbound.out |grep ^850| head -1 |awk '{ print "sockperf-unbound : TCP throughput for size 850 ,  " $NF  }'  >> $Result_dir/$filename
cat $1/sockperf-unbound.out |grep ^850| tail -1 |awk '{ print "sockperf-unbound : UDP throughput for size 850 ,  " $NF  }'  >> $Result_dir/$filename

cat $1/stream-omp-nodes.out |awk '{ print "stream : "$1 "," $3}'|tail -4 >> $Result_dir/$filename

cat $1/forkintensive.out |sed -n '1p'|awk '{print "forkintensive : process-pipes , " $1}' >> $Result_dir/$filename
cat $1/forkintensive.out |sed -n '2p'|awk '{print "forkintensive : process-sockets , " $1}' >> $Result_dir/$filename
cat $1/forkintensive.out |sed -n '3p'|awk '{print "forkintensive : thread-pipes , " $1}' >> $Result_dir/$filename
cat $1/forkintensive.out |sed -n '4p'|awk '{print "forkintensive : thread-sockets , " $1}' >> $Result_dir/$filename

 cat $2/wp-tlbflush/iter-0/wptlbflush/logs/wp-tlbflush-40.log |awk '{print $NF}'|awk '{ total += $1; count++ } END { print "wp-tlbflush: wpflush latency ," total/count  }' >> $Result_dir/$filename

#pgbench_file=$( ls -ltr $Log_dir/pgbench-timed-rw-small/iter-0/pgbench/logs/|grep .log$|grep pgbench|tail -1|awk '{print $9}' )
#cat $Log_dir/pgbench-timed-rw-small/iter-0/pgbench/logs/$pgbench_file |grep tps|cut -d "=" -f2|head -1 |awk '{print "pgbench-timed-rw-small : tps, " $1}' >> $Result_dir/$filename

echo "cat $Log_dir/pgbench-timed-rw-small/iter-0/pgbench/logs/$pgbench_file |grep tps|cut -d "=" -f2|head -1 |awk '{print "pgbench-timed-rw-small : tps, " $1}' >> $Result_dir/$filename
"
#Sysbench_file=$((ls -ltr $Log_dir/sysbench-mariadb-oltp-ro-small/iter-0/sysbench/logs/|grep raw|grep sysbench|tail -1|awk '{print $9}' ))
#cat $Log_dir/sysbench-mariadb-oltp-ro-small/iter-0/sysbench/logs/$Sysbench_file|grep transactions: |awk '{print $3}' |cut -d "(" -f2|awk '{print "sysbench tps, " $1}'  >> $Result_dir/$filename
echo "cat $Log_dir/sysbench-mariadb-oltp-ro-small/iter-0/sysbench/logs/$Sysbench_file|grep transactions: |awk '{print $3}' |cut -d "(" -f2|awk '{print "sysbench tps, " $1}'  >> $Result_dir/$filename
"
grep_thread=$((cat $1/rt-migration.out |tail -1|awk '{print $1}'))
cat $1/rt-migration.out |grep $grep_thread |awk '{print $NF}'|awk '{ total += $1; count++ } END { print "rt-migration : $grep_thread time ,  " total/count  }'   >> $Result_dir/$filename

echo "cat $1/rt-migration.out |grep $grep_thread |awk '{print $NF}'|awk '{ total += $1; count++ } END { print "rt-migration : $grep_thread time ,  " total/count  }'   >> $Result_dir/$filename
"

