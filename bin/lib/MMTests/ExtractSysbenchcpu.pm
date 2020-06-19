# ExtractSysbenchcpu.pm
package MMTests::ExtractSysbenchcpu;
use MMTests::SummariseMultiops;
use MMTests::Stat;
our @ISA = qw(MMTests::SummariseMultiops);
use strict;

sub initialise() {
	my ($self, $subHeading) = @_;
	$self->{_ModuleName} = "ExtractSysbenchcpu";
	$self->{_DataType}   = DataTypes::DATA_TIME_SECONDS;
	$self->{_PlotType}   = "client-errorlines";
	$self->SUPER::initialise($subHeading);
}

sub extractReport() {
	my ($self, $reportDir) = @_;
	my @threads = $self->discover_scaling_parameters($reportDir, "sysbench-raw-", "-1");

	foreach my $thread (@threads) {
		my $iteration = 0;
		foreach my $file (<$reportDir/time-$thread-*>) {
			$self->parse_time_elapsed($file, $thread, ++$iteration);
		}
	}
}

1;
