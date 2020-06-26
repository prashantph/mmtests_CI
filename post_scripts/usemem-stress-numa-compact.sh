#!/bin/bash
Home_dir=`pwd`
Result_dir=$Home_dir/$1
cvs_dir=$Result_dir/Final_csv
csv_file=$cvs_dir/usemem-stress/result.csv
if [ ! -d "$cvs_dir/usemem-stress" ]
then
        mkdir -p $cvs_dir/usemem-stress
fi

kernel=$(uname -r)
combined=""
#for i in $(grep sembench-futex sembench-futex.out); do // extract all the data
for i in syst-1 syst-3 syst-4 elsp-1 elsp-3 elsp-4; do
  ops=$(grep $i $Result_dir/usemem-stress-numa-compact.out | head -1 | awk '{ print $4 }')
  combined="${combined}${combined:+,}$ops"
done
echo "$kernel,$combined" > $csv_file
cat $csv_file
