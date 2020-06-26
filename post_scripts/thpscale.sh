#!/bin/bash
Home_dir=`pwd`
Result_dir=$Home_dir/$1
cvs_dir=$Result_dir/Final_csv
csv_file=$cvs_dir/thpscale/result.csv
if [ ! -d "$cvs_dir/thpscale" ]
then
        mkdir -p $cvs_dir/thpscale
fi
kernel=$(uname -r)
fault_base=$(grep fault-base-1 $Result_dir/thpscale.out  | head -1 | awk '{ print $4 }')
echo "$kernel,$fault_base" >> $csv_file
cat $csv_file
