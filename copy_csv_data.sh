#!/bin/bash

Home_dir=`pwd`
csv_dir="Results/Final_csv/"
model=`lscpu | grep "Model name" | awk '{print $3;}'`

if [ "$model" == "POWER8" ] || [ "$model" == "POWER8E" ]; 
then
	Power="Power8"
else
	Power="Power9"
fi

if cat /etc/os-release |grep ^NAME= |grep "Red Hat" ;then
	distro="RedHat"
elif cat /etc/os-release |grep ^NAME= |grep "SUSE" ;then
	distro="Suse"
else
	distro="Linux"
fi 

distro_version=`cat /etc/os-release|grep ^VERSION=|cut -f2 -d '"'|cut -c1-1`

workload_list=($(ls -ltr $Home_dir/$csv_dir| awk '{print  $9}'))

for i in "${workload_list[@]}"
do
	#echo $i 
	expect $Home_dir/ex_create.exp  $i $Power $distro$distro_version 
done
