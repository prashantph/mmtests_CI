#!/bin/bash
Home_dir=`pwd`
Result_dir=$1
cvs_dir=$Result_dir/Final_csv

csv_file=$cvs_dir/sysbench-mariadb/result.csv
if [ ! -d "$cvs_dir/sysbench-mariadb" ]
then
        mkdir -p $cvs_dir/sysbench-mariadb
fi
# THREADS=1,5,12,30,48,79,110,141
kernel=$(uname -r)
combined=""
params=($(tail -n +2 $Result_dir/sysbench-mariadb-oltp-ro-small.out|awk '{print $1}'|uniq))
for i in "${params[@]}"
do
 ops=$(grep "^$i" $Result_dir/sysbench-mariadb-oltp-ro-small.out | head -1 | awk '{ print $4 }')
  combined="${combined}${combined:+,}$ops"
done
echo "$kernel,$combined" > $csv_file
cat $csv_file
