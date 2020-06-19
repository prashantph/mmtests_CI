Log_dir=/home/mmtests/work/log.ltccip8.2020-06-03_1400
Result_dir=/home/mmtests/Results
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
		fi
	done	
done

