#!/bin/bash

script_dir=/home/mmtests/post_scripts

workload_list=($(ls -ltr $script_dir| awk '{print  $9}'))

for i in "${workload_list[@]}"
do
	sh $script_dir/$i $1 $2
done

