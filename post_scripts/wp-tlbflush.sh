#!/bin/bash
Home_dir=`pwd`
wptlbflush="/mmtests/mmtests_CI/work/log/wp-tlbflush/iter-0/wptlbflush/logs"
Result_dir=$1
cvs_dir=$Result_dir/Final_csv
csv_file=$cvs_dir/wptlbflush/result.csv
if [ ! -d "$cvs_dir/wptlbflush" ]
then
        mkdir -p $cvs_dir/wptlbflush
fi
kernel=$(uname -r)
tlbflush_80=$(awk '{ total += $1; count++ } END { print total/count }' $wptlbflush/wp-tlbflush-80.log)
echo "$kernel,$tlbflush_80" >> $csv_file
cat $csv_file

