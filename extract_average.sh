
Log_dir=/root/mmtests/work/log
workloads=($(ls -ltr $Log_dir | awk '{print  $9}'))
out_dir=/root/mmtests/work/results
for i in "${workloads[@]}"
do

 benchmark=`echo $i |cut -d '-' -f2`
 if [ $benchmark == "netperf" ]
 then 
	benchmark="netperf-unix"
	echo $benchmark

 elif [ $benchmark == "sockperf" ]
 then 
	 benchmark="sockperf-tcp-throughput"
	echo $benchmark

 else
	echo $benchmark
 fi	

./bin/extract-mmtests.pl -d work/log -b  $benchmark  -n $i --print-header >> $out_dir/$i.out

done
