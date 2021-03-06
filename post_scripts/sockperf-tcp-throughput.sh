#!/bin/bash
Home_dir=`pwd`
Result_dir=$1
cvs_dir=$Result_dir/Final_csv
csv_file=$cvs_dir/socketperf-tcp/result.csv
if [ ! -d "$cvs_dir/socketperf-tcp" ]
then
        mkdir -p $cvs_dir/socketperf-tcp
fi

MS_14=$(grep '^14 ' $Result_dir/sockperf-tcp-throughput.out | head -1 | awk '{ print $4 }')
MS_100=$(grep '^100 ' $Result_dir/sockperf-tcp-throughput.out | head -1 | awk '{ print $4 }')
MS_300=$(grep '^300 ' $Result_dir/sockperf-tcp-throughput.out | head -1 | awk '{ print $4 }')
MS_500=$(grep '^500 ' $Result_dir/sockperf-tcp-throughput.out | head -1 | awk '{ print $4 }')
MS_850=$(grep '^850 ' $Result_dir/sockperf-tcp-throughput.out | head -1 | awk '{ print $4 }')

kernel=$(uname -r)
#echo "Build_Name,MsgSize_14,MS_100,MS_300,MS_500,MS_850"
echo "$kernel,$MS_14,$MS_100,$MS_300,$MS_500,$MS_850" > $csv_file
cat $csv_file
