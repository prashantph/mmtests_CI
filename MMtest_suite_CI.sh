#!/bin/bash

#Run the selcted test cases that are chooses based on requirements and time constarint.

model=`lscpu | grep "Model name" | awk '{print $3;}'`
echo -e "Model name : "$model
HOSTNAME=$(hostname -s)
RUNDATE=$(date +"%F_%H%M")

TEMP_LOG=/tmp/MMtest_suite.log.$HOSTNAME.$RUNDATE
echo "Starting MMTEST suite "
date |tee -a  $TEMP_LOG

if [ -d "/mmtests" ]
then 
	if [ -d "/mmtests/mmtests_CI" ]
	then 
		echo "remove Older version of test suite"
		rm -rf /mmtests/mmtests_CI
	fi
	cp -r /root/mmtests_CI /mmtests
	cd /mmtests/mmtests_CI
fi	

Home_dir=`pwd`
Config_file=$Home_dir/file_configs.txt
Log_dir=$Home_dir/work/log
Result_dir=$Home_dir/Results	
kernelrelease=$(uname -r)
#check if source die already available ; delete if there to avaoid possible errors
if [ -d "$Home_dir/work/sources/postgresbuild-11.3" ]
then 
	rm -rf $Home_dir/work/sources/postgresbuild-11.3*
fi
if [ -d "$Home_dir/work/sources/sockperf-0*" ]
then 
	rm -rf $Home_dir/work/sources/sockperf-0*
fi
if [ -d "$Home_dir/work/sources/rttestbuild-v1.5-installed" ]
then 
	cd $Home_dir/work/sources/rttestbuild-v1.5-installed
	make
	cd -
fi


#run pre-req script
sh $Home_dir/prereq_setup.sh

#Running the choosen test suite 
workloads=($(cat $Config_file))
for i in "${workloads[@]}"
do
	workload_name=`echo $i |cut -d '-' -f3-`
	date |tee -a  $TEMP_LOG
	echo "starting test $workload_name "|tee -a  $TEMP_LOG
	./run-mmtests.sh --config configs/$i $workload_name
	rm -rf $Home_dir/work/testdisk $Home_dir/work/tmp
	date |tee -a  $TEMP_LOG
	echo " test $workload_name ended"|tee -a  $TEMP_LOG
	sleep 5
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
#done

echo "post processing now..."
#workload_list=($(ls -ltr $Log_dir| awk '{print  $9}'))

#for i in "${workload_list[@]}"
#do

 benchmark=`echo $workload_name |cut -d '-' -f1`
 bench=($(ls $Log_dir/$workload_name/iter-0|grep $benchmark))
        for k in "${bench[@]}"
        do
                if [ -d "$Log_dir/$workload_name/iter-0/$k" ]
                then
                    echo $k $i 
                    sleep 5
		    if [ $workload_name == "scale-short" ]
		then 
    			./bin/extract-mmtests.pl -d work/log -b ipcscale-waitforzero -n scale-short --print-header  >> $Result_dir/$workload_name.out 
		fi
                ./bin/extract-mmtests.pl -d $Log_dir -b $k  -n $workload_name --print-header >> $Result_dir/$workload_name.out
                echo "prost process pass 2 - generating result cvs"
                sh $Home_dir/post_proc_main.sh $Result_dir $kernelrelease $k
		sh $Home_dir/perf_out.sh $Log_dir/$workload_name/iter-0
		#perf report -n --no-children --sort=dso,symbol  -i $Log_dir/$i/iter-0/perf-record-$k >> $Log_dir/$i/iter-0/perf.data
                fi
        done


done
mv $Result_dir/Final_csv $Result_dir/old_cvs
sh $Home_dir/post_proc_main1.sh $Result_dir $kernelrelease 
sh $Home_dir/copy_csv_data.sh
sh $Home_dir/report_card_csv.sh $Result_dir $Log_dir

#lpcpu data collection 
lpcpu=`pwd`
echo "Collecting lpcpu data : " | tee $LOG
wget http://ltc-jenkins.aus.stglabs.ibm.com:81/perfTest/lpcpu.tar.bz2
tar xvf lpcpu.tar.bz2
rm -rf lpcpu.tar.bz2
sed -i 's|/hana/data/fio|/tmp|g' lpcpu/lpcpu.sh
$lpcpu/lpcpu/lpcpu.sh duration=60
mv /tmp/lpcpu* $result_dir
rm -rf $lpcpu/lpcpu


#add results scorecard to master scorecard
timestamp=`cat /root/timestamp.txt`
cat $Result_dir/result_score_card.csv >> /hana/data/$timestamp/CI_Results.txt file

mv $Log_dir $Log_dir.$HOSTNAME.$RUNDATE
mv $Result_dir $Result_dir.$HOSTNAME.$RUNDATE
sh backup_data.sh
#tar -cvjf Final_MMTEST_results.$HOSTNAME.$RUNDATE.tar.bz2 $Log_dir.$HOSTNAME.$RUNDATE $Result_dir.$HOSTNAME.$RUNDATE
#cp Final_MMTEST_results.$HOSTNAME.$RUNDATE.tar.bz2 /home/MMTEST_RESULTS

echo "Ending  MMTEST suite "
date |tee -a  $TEMP_LOG

