# ExtractSqlite.pm
package MMTests::ExtractSqlite;
use MMTests::SummariseMultiops;
our @ISA = qw(MMTests::SummariseMultiops);

use strict;

sub initialise() {
	my ($self, $subHeading) = @_;
	$self->{_ModuleName} = "ExtractSqlite";
	$self->{_DataType} = DataTypes::DATA_TRANS_PER_SECOND,
	$self->{_PlotType} = "simple";
	$self->SUPER::initialise($subHeading);
}

sub extractReport() {
	my ($self, $reportDir) = @_;
	my $exclude_warmup = 0;
	my $file = "$reportDir/sqlite.log";

	open(INPUT, $file) || die("Failed to open $file\n");
	while (<INPUT>) {
		my @elements = split(/\s+/);
		next if $elements[0] eq "warmup";

		$exclude_warmup = 1;
		last;
	}
	seek(INPUT, 0, 0);

	my $nr_sample = 0;
	while (<INPUT>) {
		my @elements = split(/\s+/);
		next if $exclude_warmup && $elements[0] eq "warmup";
		$self->addData("Trans", $nr_sample++, $elements[1]);
	}
	close INPUT;
}
1;
