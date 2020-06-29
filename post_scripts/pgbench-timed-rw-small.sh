#!/bin/bash

Home_dir=`pwd`
Result_dir=$1
cvs_dir=$Result_dir/Final_csv
csv_file=$cvs_dir/pgbench-timed-rw-small/result.csv

if [ ! -d "$cvs_dir/pgbench-timed-rw-small" ]
then
        mkdir -p $cvs_dir/pgbench-timed-rw-small
fi

str="BUILD NAME"
res="$2"
params=($(tail -n +2 $Result_dir/pgbench-timed-rw-small.out|awk '{print $1}'|uniq))
for i in "${params[@]}"
do
     str=`echo "$str,$i"`		
     echo $str
		temp=`cat $Result_dir/pgbench-timed-rw-small.out |grep $i|awk '{print $NF}'|awk '{s+=$1} END {print s}'`
		res=`echo "$res,$temp"`
		echo $res
done


if [ ! -f "$csv_file" ]
then
        echo $str > $csv_file

fi
echo $res  >> $csv_file
