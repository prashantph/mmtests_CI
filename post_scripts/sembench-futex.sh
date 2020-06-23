#!/bin/bash

Home_dir=`pwd`
Result_dir=$Home_dir/$1
cvs_dir=$Result_dir/Final_csv
csv_file=$cvs_dir/sembench/results.csv
if [ ! -d "$cvs_dir/sembench" ]
then
        mkdir -p $cvs_dir/sembench
fi
kernel=$(uname -r)
combined=""
#for i in $(grep sembench-futex sembench-futex.out); do // extract all the data
for i in sembench-futex-2 sembench-futex-10240; do
  ops=$(grep -w "$i"     $Result_dir/sembench-futex.out | awk '{print $4}')
  combined="${combined}${combined:+,}$ops"
done
echo "$kernel,$combined" > $csv_file
