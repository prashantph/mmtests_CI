#!/bin/bash
Home_dir=`pwd`
Result_dir=$1
cvs_dir=$Result_dir/Final_csv
csv_file=$cvs_dir/usemem-stress/result.csv
if [ ! -d "$cvs_dir/usemem-stress" ]
then
        mkdir -p $cvs_dir/usemem-stress
fi

kernel=$(uname -r)
combined=""
combined=""
params=($(tail -n +2 $Result_dir/usemem-stress-numa-compact.out|awk '{print $1}'|uniq))
for i in "${params[@]}"
do
 ops=$(grep "^$i" $Result_dir/usemem-stress-numa-compact.out | head -1 | awk '{ print $4 }')
  combined="${combined}${combined:+,}$ops"
done
echo "$kernel,$combined" > $csv_file
cat $csv_file
