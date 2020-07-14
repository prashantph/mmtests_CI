#!/bin/bash

Home_dir=`pwd`
Result_dir=$1
Log_dir="/mmtests/mmtests_CI/work/log/iperf-s14-r10000-tcp-unbound/iter-0/iperf3/logs/"
cvs_dir=$Result_dir/Final_csv
csv_file=$cvs_dir/iperf/result.csv
echo "$Log_dir"

if [ -d $Log_dir ]
then
        grep SUM $Log_dir/*|grep sender|awk '{ SUM += $6; CNT++} END { print SUM/CNT }' >> $Result_dir/iperf.out
        grep SUM $Log_dir/*|grep receiver |awk '{ SUM += $6; CNT++} END { print SUM/CNT }' >> $Result_dir/iperf.out
fi

if [ ! -d "$cvs_dir/iperf" ]
then
        mkdir -p $cvs_dir/iperf
fi

str="BUILD NAME"
res="$2"
str=`echo "$str,sender(Kbits/sec),receiver(Kbits/sec)"`
 echo $str
params=($(cat $Result_dir/iperf.out))
for i in "${params[@]}"
do
     echo $i
                res=`echo "$res,$i"`
                echo $res

done

if [ ! -f "$csv_file" ]
then
        echo $str > $csv_file

fi
echo $res  >> $csv_file
