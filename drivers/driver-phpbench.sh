
run_bench() {
	eval $SHELLPACK_INCLUDE/shellpack-bench-phpbench \
		--iterations $PHPBENCH_ITERATIONS

	return $?
}
