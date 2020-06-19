# ExtractParallelio.pm
package MMTests::ExtractParallelioswap;
use MMTests::SummariseMultiops;
our @ISA = qw(MMTests::SummariseMultiops);
use strict;

sub new() {
	my $class = shift;
	my $self = {
		_ModuleName  => "ExtractParallelioswap",
		_DataType    => DataTypes::DATA_BAD_ACTIONS,
	};
	bless $self, $class;
	return $self;
}

sub extractReport() {
	my ($self, $reportDir) = @_;
	my $lastIOStep = -1;
	my @ioSteps;
	my @ioSizes;
	my $workload;

	# Read the IO steps and workload type
	my $file = "$reportDir/workload-durations.log";
	open(INPUT, $file) || die("Failed to open $file\n");
	while (<INPUT>) {
		my @elements = split(/\s/);
		$workload = $elements[0];
		if ($lastIOStep != $elements[1]) {
			push @ioSteps, $elements[1];
		}
		$lastIOStep = $elements[1];
	}
	close(INPUT);

	# Read the corresponding IO sizes
	$ioSizes[0] = "0M";
	$file = "$reportDir/io-durations.log";
	open(INPUT, $file) || die("Failed to open $file\n");
	while (<INPUT>) {
		my @elements = split(/\s/);
		$ioSizes[$elements[0]] = (int $elements[1] / 1048576) . "M";
	}
	close(INPUT);

	# Read the VM Stats
	foreach my $ioStep (@ioSteps) {
		my $readingBefore;

		my @files = <$reportDir/vmstat-$workload-$ioStep-*.log>;
		my $minOps = -1;
		my $iteration = 0;

		foreach my $file (@files) {

			my ($swapInOut, $swapIns, $minorFaults, $majorFaults);
			open(INPUT, $file) || die("Failed to open $file");
			while (!eof(INPUT)) {
				my $line = <INPUT>;

				if ($line =~ /^start:/) {
					$readingBefore = 1;
					next;
				}

				if ($line =~ /^end:/) {
					$readingBefore = 0;
					next;
				}

				my @elements = split(/\s/, $line);
				if ($readingBefore) {
					$elements[1] = -$elements[1];
				}

				if ($elements[0] eq "pswpin") {
					$swapInOut += $elements[1];
					$swapIns += $elements[1];
				}
				if ($elements[0] eq "pswpout") {
					$swapInOut += $elements[1];
				}
				if ($elements[0] eq "pgmajfault") {
					$majorFaults += $elements[1];
					$minorFaults -= $elements[1];
				}
				if ($elements[0] eq "pgfault") {
					$minorFaults += $elements[1];
				}
			}

			$iteration++;
			$self->addData("swaptotal-$ioSizes[$ioStep]", $iteration, $swapInOut);
			$self->addData("swapin-$ioSizes[$ioStep]", $iteration, $swapIns);
			$self->addData("minorfaults-$ioSizes[$ioStep]", $iteration, $minorFaults);
			$self->addData("majorfaults-$ioSizes[$ioStep]", $iteration, $majorFaults);
		}
	}

	my $op;
	foreach my $op ("swapin", "swaptotal", "minorfaults", "majorfaults") {
		foreach my $ioStep (@ioSteps) {
			push @{$self->{_Operations}}, "$op-$ioSizes[$ioStep]";
		}
	}
}

1;
