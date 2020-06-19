#!/bin/bash

#Run the selcted test cases that are chooses based on requirements and time constarint.

model=`lscpu | grep "Model name" | awk '{print $3;}'`
echo -e "Model name : "$model
HOSTNAME=$(hostname -s)
RUNDATE=$(date +"%F_%H%M")

TEMP_LOG=/tmp/MMtest_suite.log.$HOSTNAME.$RUNDATE
echo "Starting MMTEST suite "
date |tee -a  $TEMP_LOG
if [ -d "/home/mmtests" ] 
then
    echo "Directory MMTests exists." 
	#rm -rf /home/schbench
else
	echo "Warning: Directory /home/MMTests does not exists."
fi

Config_dir=/home/mmtests/configs
Log_dir=/home/mmtests/work/log
Result_dir=/home/mmtests/Results	
#Running the choosen test suite 
workloads=($(ls -ltr $Config_dir| awk '{print  $9}'))
for i in "${workloads[@]}"
do
	workload_name=`echo $i |cut -d '-' -f3-`
	date |tee -a  $TEMP_LOG
	echo "starting test $workload_name "|tee -a  $TEMP_LOG
	./run-mmtests.sh --config configs/$i $workload_name
	rm -rf /home/mmtests/work/testdisk/*
	date |tee -a  $TEMP_LOG
	echo " test $workload_name ended"|tee -a  $TEMP_LOG
	sleep 5
done

#post process output part1
echo "post processing now..."
if [ ! -d "$Result_dir" ]
then
    echo "Result directory missing, creating one"
	mkdir -p $Result_dir
fi
#workload_list=($(ls -ltr $Log_dir| awk '{print  $9}')) 

#for i in "${workload_list[@]}"
#do

 #benchmark=`echo $i |cut -d '-' -f1`
 #if [ $benchmark == "netperf" ]
 #then
  #      benchmark="netperf-unix"
   #     echo $benchmark

 #elif [ $benchmark == "sockperf" ]
 #then
 #        benchmark="sockperf-tcp-throughput"
 #       echo $benchmark

 #else
 #       echo $benchmark
 #fi

#./bin/extract-mmtests.pl -d work/log -b  $benchmark  -n $i --print-header >> $Result_dir/$i.out
#echo "./bin/extract-mmtests.pl -d Log_dir.ltccidistro6p9.2020-05-26_1058 -b  $benchmark  -n $i --print-header >> $Result_dir/$i.out "
#./bin/extract-mmtests.pl -d Log_dir.ltccidistro6p9.2020-05-26_1058 -b  $benchmark  -n $i --print-header >> $Result_dir/$i.out 

#done
echo "post processing now..."
workload_list=($(ls -ltr $Log_dir| awk '{print  $9}'))

for i in "${workload_list[@]}"
do

 benchmark=`echo $i |cut -d '-' -f1`
 bench=($(ls $Log_dir/$i/iter-0|grep $benchmark))
        for k in "${bench[@]}"
        do
                if [ -d "$Log_dir/$i/iter-0/$k" ]
                then
                ./bin/extract-mmtests.pl -d $Log_dir -b $k  -n $i --print-header >> $Result_dir/$i.out
		perf report -n --no-children --sort=dso,symbol  -i $Log_dir/$i/iter-0/perf-record-$k >> $Log_dir/$i/iter-0/perf.data
                fi
        done
done


mv $Log_dir $Log_dir.$HOSTNAME.$RUNDATE
mv $Result_dir $Result_dir.$HOSTNAME.$RUNDATE
echo "Ending  MMTEST suite "
date |tee -a  $TEMP_LOG

