#!/bin/bash
Home_dir=`pwd`
Result_dir=$1
cvs_dir=$Result_dir/Final_csv

csv_file=$cvs_dir/sysbench-postgres/result.csv
if [ ! -d "$cvs_dir/sysbench-postgres" ]
then
        mkdir -p $cvs_dir/sysbench-postgres
fi
# THREADS=1,5,12,30,48,79,110,141
kernel=$(uname -r)
combined=""
for i in 1 5 12 21; do
  ops=$(grep "^$i" $Result_dir/sysbench-postgres-oltp-rw-small.out | head -1 | awk '{ print $4 }')
  combined="${combined}${combined:+,}$ops"
done
#echo "Build_Name,THREADS_1(Ops),T_5,T_12,T_21" > $csv_file
echo "$kernel,$combined" >> $csv_file
