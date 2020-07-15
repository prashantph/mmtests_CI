#!/bin/bash

Home_dir=`pwd`
Result_dir=$1
Log_dir="/mmtests/mmtests_CI/work/log/forkintensive/iter-0/"
cvs_dir=$Result_dir/Final_csv
csv_file=$cvs_dir/forkintensive/result.csv
echo "$Log_dir"

if [ -d $Log_dir ]
then
        grep "Total time"  $Log_dir/hackbench-process-pipes/logs/*|awk '{ SUM += $4; CNT++} END { print SUM/CNT }' >> $Result_dir/forkintensive.out
        grep "Total time"  $Log_dir/hackbench-process-sockets/logs/*|awk '{ SUM += $4; CNT++} END { print SUM/CNT }' >> $Result_dir/forkintensive.out
        grep "Total time"  $Log_dir/hackbench-thread-pipes/logs/*|awk '{ SUM += $4; CNT++} END { print SUM/CNT }' >> $Result_dir/forkintensive.out
        grep "Total time"  $Log_dir/hackbench-thread-sockets/logs/*|awk '{ SUM += $4; CNT++} END { print SUM/CNT }' >> $Result_dir/forkintensive.out
fi

if [ ! -d "$cvs_dir/forkintensive" ]
then
        mkdir -p $cvs_dir/forkintensive
fi

str="BUILD NAME"
res="$2"
str=`echo "$str,process-pipes,process-sockets,thread-pipes,thread-sockets(/sec)"`
 echo $str
params=($(cat $Result_dir/forkintensive.out))
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
