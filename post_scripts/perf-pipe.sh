#!/bin/bash

Home_dir=`pwd`
Result_dir=$1
Log_dir="/mmtests/mmtests_CI/work/log.rakshithlinux3.2020-07-12_1239/perfpipe-cpufreq/iter-0/perfpipe/logs"
cvs_dir=$Result_dir/Final_csv
csv_file=$cvs_dir/perfpipe/result.csv
echo "$Log_dir"

if [ -d $Log_dir ]
then 
	echo "direectory found"
	grep "ops/sec" $Log_dir/* |awk '{ SUM += $2; CNT++} END { print SUM/CNT }'  >  $Result_dir/perfpipe.out
fi

if [ ! -d "$cvs_dir/perfpipe" ]
then
        mkdir -p $cvs_dir/perfpipe
fi

str="BUILD NAME"
res="$2"
params=($(cat $Result_dir/perfpipe.out))
     str=`echo "$str,ops/sec"`		
     echo $str
		res=`echo "$res,$params"`
		echo $res


if [ ! -f "$csv_file" ]
then
        echo $str > $csv_file

fi
echo $res  >> $csv_file
