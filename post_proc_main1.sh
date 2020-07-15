#!/bin/bash

Home_dir=`pwd`
script_dir=$Home_dir/post_scripts

workload_list=($(cat $script_dir/post_script_file.txt))


for i in "${workload_list[@]}"
do
	echo "sh $script_dir/$i $1 $2"
	sh $script_dir/$i $1 $2
done

