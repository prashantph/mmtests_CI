#!/bin/bash
Home_dir=`pwd`
Result_dir=$Home_dir/$1
cvs_dir=$Result_dir/Final_csv
csv_file=$cvs_dir/stream/result.csv
if [ ! -d "$cvs_dir/stream" ]
then
        mkdir -p $cvs_dir/stream
fi
kernel=$(uname -r)
Copy=$(grep "copy" $Result_dir/stream-omp-nodes.out | awk '{ print $3 }')
Scale=$(grep "scale" $Result_dir/stream-omp-nodes.out | awk '{ print $3 }')
Add=$(grep "add" $Result_dir/stream-omp-nodes.out | awk '{ print $3 }')
Triad=$(grep "triad" $Result_dir/stream-omp-nodes.out | awk '{ print $3 }')
echo "$kernel,$Copy,$Scale,$Add,$Triad"> $csv_file
cat $csv_file
