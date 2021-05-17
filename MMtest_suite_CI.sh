#!/bin/bash

#Run the selcted test cases that are chooses based on requirements and time constarint.

model=`lscpu | grep "Model name" | awk '{print $3;}'`
echo -e "Model name : "$model
HOSTNAME=$(hostname -s)
RUNDATE=$(date +"%F_%H%M")

TEMP_LOG=/tmp/MMtest_suite.log.$HOSTNAME.$RUNDATE
echo "Starting MMTEST suite "
date |tee -a  $TEMP_LOG

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

#post process output part1
echo "post processing now..."
if [ ! -d "$Result_dir" ]
then
    echo "Result directory missing, creating one"
	mkdir -p $Result_dir
fi


#Adding Netop suite here 
#remove old netop folder if exist
if [ -d "/home/netop" ]
then
                echo "remove Older version of Netop test suite" 
                rm -rf /home/netop
fi

#Run Netop automation script
sh Netop_CI.sh

cd $Home_dir
cp -r /home/netop/Netop_log $Log_dir
cp -r /home/netop/logs $Log_dir/Netop_log/
cp -r /home/netop/Results $Result_dir

mv $Result_dir/Final_csv $Result_dir/old_cvs
sh $Home_dir/post_proc_main1.sh $Result_dir $kernelrelease 
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

