

log_dir=$1
perf_dirs=($(ls -l $log_dir | grep ^d | awk '{print $9}')) 

for k in "${perf_dirs[@]}"
do
	perf_files=($(ls $log_dir/$k/logs/perf.raw.callgraph.dat*|awk '{print $NF}'|rev |cut -d '/' -f 1|rev))

	for i in "${perf_files[@]}"
	do 
		echo $log_dir/$k/logs/$i
		perf report -n --no-children --sort=dso,symbol -i  $log_dir/$k/logs/$i  > $log_dir/$k/logs/${i}.out
	done
done
