#!/bin/bash

Home_dir=`pwd`
csv_dir="Results/Final_csv/"
model=`lscpu | grep "Model name" | awk '{print $3;}'`

if [ "$model" == "POWER8" ] 
then
	Power="Power8"
else
	Power="Power9"
fi 			
distro="RedHat"
#distro_version=`cat /etc/os-release|grep ^VERSION=|cut -f2 -d '"'|cut -c1-1`
distro_version="8.2"
workload_list=($(ls -ltr $Home_dir/$csv_dir| awk '{print  $9}'))

for i in "${workload_list[@]}"
do
	#echo $i 
	expect $Home_dir/ex_create.exp  $i $Power $distro$distro_version 
done

