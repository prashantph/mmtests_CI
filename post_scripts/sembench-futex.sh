#!/bin/bash
Home_dir=`pwd`
Result_dir=$1
cvs_dir=$Result_dir/Final_csv
csv_file=$cvs_dir/sembench/result.csv
if [ ! -d "$cvs_dir/sembench" ]
then
        mkdir -p $cvs_dir/sembench
fi
kernel=$(uname -r)
combined=""
params=($(tail -n +2 $Result_dir/sembench-futex.out|awk '{print $1}'|uniq))
for i in "${params[@]}"
do
  ops=$(grep -w "$i"     $Result_dir/sembench-futex.out | awk '{print $4}')
  combined="${combined}${combined:+,}$ops"
done
echo "$kernel,$combined" > $csv_file
cat $csv_file
