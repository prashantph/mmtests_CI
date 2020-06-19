
Log_dir=/root/mmtests/work/log
workloads=($(ls -ltr $Log_dir | awk '{print  $9}'))
out_dir=/root/mmtests/work/results
for i in "${workloads[@]}"
do

 benchmark=`echo $i |cut -d '-' -f2`
./bin/compare-mmtests.pl --directory $Log_dir --benchmark $benchmark  --names $i >> $out_dir/$i.out

done
