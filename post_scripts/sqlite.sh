#!/bin/bash

Home_dir=`pwd`
Result_dir=$1
Log_dir="/mmtests/mmtests_CI/work/log/sqlite-insert-small/iter-0/sqlite/logs"
cvs_dir=$Result_dir/Final_csv
csv_file=$cvs_dir/sqlite/result.csv
echo "$Log_dir"

if [ -d $Log_dir ]
then 
	echo "direectory found"
	cat $Log_dir/sqlite.time |grep output|cut -d '+' -f2 |cut -d '0' -f1 >  $Result_dir/sqlite.out
fi

if [ ! -d "$cvs_dir/sqlite" ]
then
        mkdir -p $cvs_dir/sqlite
fi

str="BUILD NAME"
res="$2"
params=($(cat $Result_dir/sqlite.out))
     str=`echo "$str,Inserts"`		
     echo $str
		res=`echo "$res,$params"`
		echo $res


if [ ! -f "$csv_file" ]
then
        echo $str > $csv_file

fi
echo $res  >> $csv_file
