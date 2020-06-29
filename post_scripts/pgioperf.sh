#!/bin/bash

Home_dir=`pwd`
Result_dir=$1
cvs_dir=$Result_dir/Final_csv
csv_file=$cvs_dir/pgioperf/result.csv

if [ ! -d "$cvs_dir/pgioperf" ]
then
        mkdir -p $cvs_dir/pgioperf
fi

str="BUILD NAME"
res="$2"
params=($(tail -n +2 $Result_dir/pgioperf.out|awk '{print $1}'|uniq))
for i in "${params[@]}"
do
     if [ $i != "Operation" ]
     then	
	str=`echo "$str,$i"`		
     	echo $str
		temp=`cat $Result_dir/pgioperf.out |grep $i|awk '{print $NF}'|awk '{s+=$1} END {print s}'`
		res=`echo "$res,$temp"`
		echo $res
    fi
done


if [ ! -f "$csv_file" ]
then
        echo $str > $csv_file

fi
echo $res  >> $csv_file
