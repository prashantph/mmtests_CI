# MonitorSyscalls.pm
package MMTests::MonitorSyscalls;
use MMTests::SummariseMonitor;
our @ISA = qw(MMTests::SummariseMonitor);
use strict;

sub new() {
	my $class = shift;
	my $self = {
		_ModuleName    => "MonitorSyscalls",
	};
	bless $self, $class;
	return $self;
}

my %_colMap = (
	"Count"		=> 4,
	"Latency"	=> 5,
);

use constant typeMap => {
	"Count"		=> DataTypes::DATA_ACTIONS,
	"Latency"	=> DataTypes::DATA_TIME_NSECONDS,
};

use constant headings => {
	"Count"		=> "Syscalls",
	"Latency"	=> "Syscall time (ns)",
};

sub initialise() {
	my ($self, $subHeading) = @_;
	my ($subHeading, $subSummary) = split(/-/, $subHeading);

	if (!defined $_colMap{$subHeading}) {
		die("Unrecognised heading $subHeading");
	}
	$self->{_DataType} = typeMap->{$subHeading};
	$self->{_PlotYAxis} = headings->{$subHeading};
	$self->SUPER::initialise($subHeading);
}

sub extractReport($$$$) {
	my ($self, $reportDir, $testBenchmark, $subHeading, $rowOrientated) = @_;
	my $timestamp;
	my $start_timestamp = 0;

	my ($subHeading, $subSummary) = split(/-/, $subHeading);

	if (!defined $_colMap{$subHeading}) {
		die("Unrecognised heading $subHeading");
	}
	my $headingindex = $_colmap{$subheading};

	my %totalEvents;
	my $input = $self->SUPER::open_log("$reportDir/syscalls-$testBenchmark");
	while (<$input>) {
		my $line = $_;
		$line =~ s/^\s+//;

		if ($line =~ /^time: ([0-9]+)/) {
			if ($start_timestamp == 0) {
				$timestamp = $1;
				$start_timestamp = $timestamp;
			} else {
				foreach my $thread (sort keys %totalEvents) {
					$self->addData($thread,
						$timestamp - $start_timestamp,
						$totalEvents{$thread});
				}
				$timestamp = $1;
			}
			%totalEvents = ();
			next;
		}

		next if ($line !~ /^[0-9].*/);

		my @elements = split(/\s+/, $line);
		my $thread;
		if ($subSummary eq "thread") {
			$thread = "$elements[3]__$elements[2]-$elements[1]";
		} else {
			$thread = "$elements[3]";
		}
		$totalEvents{$thread} += $elements[$headingIndex];
	}
	close($input);
}

1;
