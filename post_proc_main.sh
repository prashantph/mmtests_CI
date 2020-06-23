#!/bin/bash

Home_dir=`pwd`
script_dir=$Home_dir/post_scripts

workload_list=($(ls -ltr $script_dir| awk '{print  $9}'))

for i in "${workload_list[@]}"
do
	sh $script_dir/$i $1 $2
done

