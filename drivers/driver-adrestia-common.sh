$SHELLPACK_TOPLEVEL/shellpack_src/src/refresh.sh adrestia

run_bench() {
	$SCRIPTDIR/shellpacks/shellpack-bench-adrestia \
		--test $ADRESTIA_TEST \
		--loops $ADRESTIA_LOOPS \
		--iterations $ADRESTIA_ITERATIONS \
		--threads $ADRESTIA_THREADS \
		--service-time $ADRESTIA_SERVICE_TIME \
		--min-arrival-time $ADRESTIA_MIN_ARRIVAL_TIME \
		--max-arrival-time $ADRESTIA_MAX_ARRIVAL_TIME
	return $?
}
