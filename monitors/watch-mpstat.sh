#!/bin/bash
install-depends sysstat
while [ 1 ]; do
	echo time: `date +%s`
	exec mpstat -P ALL -u $MONITOR_UPDATE_FREQUENCY | perl -e 'select(STDOUT);
		$|=1;
		while (<>) {
			print $_;
			if ($_ =~ /^$/) {
				print "time: " . time . "\n";
			}
		}'
done
