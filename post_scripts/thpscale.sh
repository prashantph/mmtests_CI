#!/bin/bash
Home_dir=`pwd`
Result_dir=$1
cvs_dir=$Result_dir/Final_csv
csv_file=$cvs_dir/thpscale/result.csv
if [ ! -d "$cvs_dir/thpscale" ]
then
        mkdir -p $cvs_dir/thpscale
fi
kernel=$(uname -r)
combined=""
params=($(tail -n +2 $Result_dir/thpscale.out|awk '{print $1}'|uniq))
for i in "${params[@]}"
do
 ops=$(grep "^$i" $Result_dir/thpscale.out | head -1 | awk '{ print $4 }')
  combined="${combined}${combined:+,}$ops"
done
echo "$kernel,$combined" >> $csv_file
cat $csv_file
