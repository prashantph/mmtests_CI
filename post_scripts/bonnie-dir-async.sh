#!/bin/bash

Home_dir=`pwd`
Result_dir=$1
cvs_dir=$Result_dir/Final_csv
csv_file=$cvs_dir/bonnie-dir-async/result.csv

if [ ! -d "$cvs_dir/bonnie-dir-async" ]
then
        mkdir -p $cvs_dir/bonnie-dir-async
fi

str="BUILD NAME"
res="$2"
params=($(tail -n +2 $Result_dir/bonnie-dir-async.out|awk '{print $1$2}'|uniq))
params1=($(tail -n +2 $Result_dir/bonnie-dir-async.out|awk '{print $1}'|uniq))
params2=($(tail -n +2 $Result_dir/bonnie-dir-async.out|awk '{print $2}'|uniq|sort -u))
for i in "${params[@]}"
do
     str=`echo "$str,$i"`		
     echo $str
done

for i in "${params1[@]}"
do 
	for k in "${params2[@]}"
	do
		temp=`cat $Result_dir/bonnie-dir-async.out |grep "$i $k"|awk '{print $NF}'|awk '{s+=$1} END {print s}'`
		echo $temp
		res=`echo "$res,$temp"`
		echo $res
	done
done



if [ ! -f "$csv_file" ]
then
        echo $str > $csv_file

fi
echo $res  >> $csv_file
