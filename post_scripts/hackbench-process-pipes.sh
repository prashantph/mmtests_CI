#!/bin/bash

Result_dir=/home/mmtests/$1
cvs_dir=$Result_dir/Final_csv
csv_file=$cvs_dir/hackbench-process-pipes/result.csv

if [ ! -d "$cvs_dir/hackbench-process-pipes" ]
then
        mkdir -p $cvs_dir/hackbench-process-pipes
fi

str="BUILD NAME"
res="$2"
params=($(tail -n +2 $Result_dir/hackbench-process-pipes.out|awk '{print $1}'|uniq))
for i in "${params[@]}"
do
     str=`echo "$str,$i"`		
     echo $str
		temp=`cat $Result_dir/hackbench-process-pipes.out |grep $i|awk '{print $NF}'|awk '{s+=$1} END {print s}'`
		res=`echo "$res,$temp"`
		echo $res
done


if [ ! -f "$csv_file" ]
then
        echo $str > $csv_file

fi
echo $res  >> $csv_file
