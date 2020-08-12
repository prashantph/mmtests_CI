

log_dir=$1
perf_files=($(ls $log_dir/perf.raw.callgraph.dat*|awk '{print $NF}'|rev |cut -d '/' -f 1|rev))

for i in "${perf_files[@]}"
do 
	echo $i
	perf report -n --no-children --sort=dso,symbol -i  $log_dir/$i  > $log_dir/${i}.out
done
