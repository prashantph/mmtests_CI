# ExtractMutilate.pm
package MMTests::ExtractMutilate;
use MMTests::SummariseMultiops;
use MMTests::Stat;
our @ISA = qw(MMTests::SummariseMultiops);
use strict;

sub new() {
	my $class = shift;
	my $self = {
		_ModuleName  => "ExtractMutilate",
		_DataType    => DataTypes::DATA_ACTIONS_PER_SECOND,
		_PlotType    => "client-errorlines",
	};
	bless $self, $class;
	return $self;
}

sub extractReport() {
	my ($self, $reportDir) = @_;

	my @clients = $self->discover_scaling_parameters($reportDir, "mutilate-", "-1.log");

	foreach my $client (@clients) {
		my $iteration = 1;

		my @files = <$reportDir/mutilate-$client-*>;
		foreach my $file (@files) {
			open(INPUT, $file) || die("Failed to open $file\n");
			while (<INPUT>) {
				next if ($_ !~ /^Total QPS/);
				my @elements = split(/\s+/, $_);
				$self->addData($client, $iteration, $elements[3]);
			}
			close INPUT;
			$iteration++;
		}
	}
}

1;
