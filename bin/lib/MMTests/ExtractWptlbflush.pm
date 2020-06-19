# ExtractWptlbflush.pm
package MMTests::ExtractWptlbflush;
use MMTests::SummariseMultiops;
use Math::Round;
our @ISA = qw(MMTests::SummariseMultiops);

sub printDataType() {
        print "Time,TestName,Time (usec),simple";
}

sub initialise() {
	my ($self, $subHeading) = @_;
	$self->{_ModuleName} = "ExtractWptlbflush";
	$self->{_DataType}   = DataTypes::DATA_TIME_USECONDS;
	$self->{_PlotType}   = "client-errorlines";
	$self->{_PlotXaxis}  = "Clients";
	$self->{_FieldLength} = 12;
	$self->{_ExactSubheading} = 1;
	$self->{_ExactPlottype} = "simple";
	$self->{_DefaultPlot} = "1";

	$self->SUPER::initialise($subHeading);
}

sub extractReport() {
	my ($self, $reportDir) = @_;

	my @clients = $self->discover_scaling_parameters($reportDir, "wp-tlbflush-", ".log");

	foreach my $client (@clients) {
		my $file = "$reportDir/wp-tlbflush-$client.log";

		open(INPUT, $file) || die("Failed to open $file\n");
		my $iteration = 0;
		my $last = 0;
		while (<INPUT>) {
			my @elements = split(/\s/);
			my $t = nearest(.5, $elements[0]);

			if ($last && $t > $last * 50) {
				next;
			}
			$last = $t;
			$self->addData("procs-$client", ++$iteration, $t);
		}
	}
	close INPUT;
}
1;
