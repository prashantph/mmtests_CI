# ExtractSchbench.pm
package MMTests::ExtractSchbench;
use MMTests::SummariseSingleops;
use MMTests::Stat;
our @ISA = qw(MMTests::SummariseSingleops);

use strict;

sub initialise() {
	my ($self, $subHeading) = @_;
	$self->{_ModuleName} = "ExtractSchbench";
	$self->{_DataType}   = DataTypes::DATA_TIME_USECONDS;
	$self->{_PlotXaxis}  = "Threads";
	$self->{_Opname} = "Lat";
	$self->{_FieldLength} = 12;
	$self->{_ExactSubheading} = 1;
	$self->{_ExactPlottype} = "simple";
	$self->{_DefaultPlot} = "1";
	$self->SUPER::initialise($subHeading);
}

sub extractReport() {
	my ($self, $reportDir) = @_;
	my @ratioops;

	my @groups = $self->discover_scaling_parameters($reportDir, "schbench-", ".log");
	foreach my $group (@groups) {
		open(INPUT, "$reportDir/schbench-$group.log") || die("Failed to open $group\n");
		while (<INPUT>) {
			if ($_ =~ /[ \t\*]+([0-9]+\.[0-9]+)th: ([0-9]+)/) {
				my $quartile = $1;
				my $lat = $2;
				$quartile =~ s/00$//;
				$self->addData("${quartile}th-qrtle-$group", 0, $lat);
				if ($quartile == 99) {
					push @ratioops, "${quartile}th-qrtle-$group";
				}
			}
		}
		close INPUT;
	}

	$self->{_RatioOperations} = \@ratioops;
}
