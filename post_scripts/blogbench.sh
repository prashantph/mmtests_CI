#!/bin/bash

Result_dir=/home/mmtests/$1
cvs_dir=$Result_dir/Final_csv
csv_file=$cvs_dir/blogbench/result.csv

if [ ! -d "$cvs_dir/blogbench" ]
then
        mkdir -p $cvs_dir/blogbench
fi


params=($(tail -n +2 $Result_dir/blogbench.out|awk '{print $1}'|uniq))
for i in "${params[@]}"
do
     echo $i
        if [ $i == "ReadScore" ]
        then
        Read_score=`cat $Result_dir/blogbench.out |grep ^ReadScore|awk '{print $4}'|awk '{s+=$1} END {print s}'`
        echo $Read_score
        else
        Write_score=`cat $Result_dir/blogbench.out |grep ^WriteScore|awk '{print $4}'|awk '{s+=$1} END {print s}'`
        echo $Write_score
        fi
done
if [ ! -f "$csv_file" ]
then
        echo "BUILD NAME,${params[0]},${params[1]}" > $csv_file

fi
echo "$2,$Write_score,$Read_score" >>$csv_file
