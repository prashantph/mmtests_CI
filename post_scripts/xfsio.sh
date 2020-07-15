#!/bin/bash

Home_dir=`pwd`
Result_dir=$1
cvs_dir=$Result_dir/Final_csv
csv_file=$cvs_dir/xfsio/result.csv
if [ ! -d "$cvs_dir/xfsio" ]
then
        mkdir -p $cvs_dir/xfsio
fi
System=$(grep -m1 "System" $Result_dir/xfsio.out | awk '{ print $4 }')
Elapsd=$(grep -m1 "Elapsd" $Result_dir/xfsio.out | awk '{ print $4 }')
kernel=$(uname -r)
#echo "Build_Name,System_Ops,Elapsd_Ops"
echo "$kernel,$System,$Elapsd" > $csv_file
cat $csv_file
