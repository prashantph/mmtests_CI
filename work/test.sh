
Log_dir=/root/mmtests/work/old_dirs/log
workloads=($(ls -ltr $Log_dir | awk '{print  $9}'))
out_dir=/root/mmtests/work/old_dirs/results
for i in "${workloads[@]}"
do

 benchmark=`echo $i |cut -d '-' -f2`
./bin/compare-mmtests.pl --directory work/log --benchmark $benchmark  --names $i >> $out_dir/$i.out

done
