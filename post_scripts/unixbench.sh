#!/bin/bash
Home_dir=`pwd`
Result_dir=$1
cvs_dir=$Result_dir/Final_csv
csv_file=$cvs_dir/unixbench/result.csv
if [ ! -d "$cvs_dir/unixbench" ]
then
        mkdir -p $cvs_dir/unixbench
fi
Log_dir=$Home_dir/work/log
#cp $Log_dir/unixbench/iter-0/unixbench-dhry2reg/logs/dhry2reg-* $Result_dir

dry_min=$(grep -m1 unixbench-dhry2reg $Result_dir/unixbench.out | awk '{ print $4 }')
dry_max=$(grep unixbench-dhry2reg $Result_dir/unixbench.out | grep -v unixbench-dhry2reg-1|head -1 | awk '{ print $4 }')
#dry_max=$(grep lps dhry2reg-320-1.log | awk '{ print $6 }')
#dmax=$(ls | grep -v dhry2reg-1 | head -1 )
execl_min=$(grep -m1 unixbench-execl $Result_dir/unixbench.out | awk '{ print $4 }')
execl_max=$(grep unixbench-execl $Result_dir/unixbench.out | grep -v unixbench-execl-1 | head -1 | awk '{ print $4 }' )
pipe_min=$(grep -m1 unixbench-pipe $Result_dir/unixbench.out | awk '{ print $4 }')
pipe_max=$(grep  unixbench-pipe $Result_dir/unixbench.out | grep -v unixbench-pipe-1 | head -1 | awk '{ print $4 }')
spawn_min=$(grep -m1 unixbench-spawn $Result_dir/unixbench.out | awk '{ print $4 }')
spawn_max=$(grep unixbench-spawn $Result_dir/unixbench.out | grep -v unixbench-spawn-1 | head -1 | awk '{ print $4 }')
syscall_min=$(grep -m1 unixbench-syscall $Result_dir/unixbench.out | awk '{ print $4 }')
syscall_max=$(grep  unixbench-syscall $Result_dir/unixbench.out | grep -v unixbench-syscall-1 | head -1 | awk '{ print $4 }')
kernel=$(uname -r)
echo "$kernel,$dry_min,$dry_max,$execl_min,$execl_max,$pipe_min,$pipe_max,$spawn_min,$spawn_max,$syscall_min,$syscall_max"> $csv_file
cat $csv_file
