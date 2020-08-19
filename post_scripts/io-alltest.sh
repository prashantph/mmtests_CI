#!/bin/bash

Home_dir=`pwd`
Result_dir=$1
Log_dir="/mmtests/mmtests_CI/work/log/io-alltests/iter-0/reaim/logs/workfile.alltests"
cvs_dir=$Result_dir/Final_csv
csv_file=$cvs_dir/io-alltest/result.csv
echo "$Log_dir"

if [ -d $Log_dir ]
then
	grep "Max Jobs per Minute" $Log_dir/* |awk '{ SUM += $NF; CNT++} END { print SUM/CNT }' >> $Result_dir/io-alltest.out
fi

if [ ! -d "$cvs_dir/io-alltest" ]
then
        mkdir -p $cvs_dir/io-alltest
fi

str="BUILD NAME"
res="$2"
str=`echo "$str,MAX_JOBS(/min)"`
 echo $str
params=($(cat $Result_dir/io-alltest.out))
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
