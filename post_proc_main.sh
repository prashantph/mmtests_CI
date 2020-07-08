#!/bin/bash

Home_dir=`pwd`
script_dir=$Home_dir/post_scripts
work_script=($(ls  $script_dir| grep $3)) 
    echo " sh $script_dir/$work_script $1 $2"
	sh $script_dir/$work_script $1 $2

#workload_list=($(ls -ltr $script_dir| awk '{print  $9}'))


#for i in "${workload_list[@]}"
#do
#	sh $script_dir/$i $1 $2
#done

