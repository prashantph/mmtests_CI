#!/bin/bash

#Netop test included as network test to stress CPU with Network workloads; since netop supports multithreads this is easy
set -x
model=`lscpu | grep "Model name" | awk '{print $3;}'`
echo -e "Model name : "$model
CPUS=`lscpu | grep "^CPU(s)"| awk '{print $2}'`
echo -e "CPUS : "$CPUS
HOSTNAME=$(hostname -s)
RUNDATE=$(date +"%F_%H%M")

#constants 
Home_dir=/home
wrk_dir=$Home_dir/netop
Config_file=$wrk_dir/netop.script
Script_file=$wrk_dir/netop_run.script
Log_dir=$wrk_dir/Netop_log
Result_dir=$wrk_dir/Results	
Result_file=$Result_dir/Netop_Results.$HOSTNAME.$RUNDATE
kernelrelease=$(uname -r)

#download and  netop ; Note : netop has to be copied to /home directory
cd $Home_dir
echo "Downloading netop source \n" |tee -a $NETOP_LOG
git clone https://github.com/prashantph/netop


mkdir -p $Log_dir
mkdir -p $Result_dir

#install xinetd 
yum -y install xinetd


NETOP_LOG=$Log_dir/Netop.log.$HOSTNAME.$RUNDATE

echo "Kernel version is :  $kernelrelease \n" |tee -a $NETOP_LOG
echo "Starting Netop Test \n" |tee -a $NETOP_LOG
date |tee -a  $NETOP_LOG

#install netop
mv $wrk_dir/netop_*.tar $Home_dir
tar -xvf netop_*.tar
sleep 1
cd $wrk_dir
python Netop-Install.py both 

#exit if install failed 
if [ $? -ne 0 ]; then
    echo "Netop install Failed " |tee -a $NETOP_LOG
    exit
fi


#Setting up the threads based on number of CPUS 
sed  "s/THREAD/$CPUS/g" $Config_file > $Script_file

#Run netop workload
echo " Running netop \n" |tee -a $NETOP_LOG
netop $Script_file 2>&1 |tee -a $NETOP_LOG 


#post process
Server_throughput=`cat $NETOP_LOG  |grep Srv |awk '{print $9}'`
client_throughput=`cat $NETOP_LOG  |grep Clt |awk '{print $NF}'`
Server_cpu_util=`cat $NETOP_LOG|grep Srv |awk '{print $6}'`
Clientcpu_util=`cat $NETOP_LOG|grep Clt |awk '{print $5}'`


echo "Server throughput : $Server_throughput " |tee -a $Result_file
echo "Client throughput : $client_throughput " |tee -a $Result_file
echo "Server CPU Utilization : $Server_cpu_util " |tee -a $Result_file
echo "Client CPU Utilization  : $Clientcpu_util " |tee -a $Result_file


echo "Netop test completed \n" | tee -a $NETOP_LOG

