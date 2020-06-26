#!/bin/bash
Home_dir=`pwd`
Result_dir=$Home_dir/$1
cvs_dir=$Result_dir/Final_csv
csv_file=$cvs_dir/sparsetruncate-tiny/result.csv
if [ ! -d "$cvs_dir/sparsetruncate-tiny" ]
then
        mkdir -p $cvs_dir/sparsetruncate-tiny
fi
kernel=$(uname -r)
Time=$(grep Time $Result_dir/sparsetruncate-tiny.out | tail -1 | awk '{ print $4}')
echo "$kernel,$Time"> $csv_file
cat $csv_file
