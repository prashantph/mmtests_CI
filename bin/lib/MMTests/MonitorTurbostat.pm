# MonitorTurbostat.pm
package MMTests::MonitorTurbostat;
use MMTests::SummariseMonitor;
use MMTests::Stat;
our @ISA = qw(MMTests::SummariseMonitor);
use strict;

my %_colMap;
my @fieldHeaders;

my %datatypes = (
	"CorWatt" => DataTypes::DATA_SUCCESS_PERCENT,
	"PkgWatt" => DataTypes::DATA_SUCCESS_PERCENT,
	"CPU%c0"  => DataTypes::DATA_SUCCESS_PERCENT,
	"CPU%c1"  => DataTypes::DATA_SUCCESS_PERCENT,
	"CPU%c2"  => DataTypes::DATA_SUCCESS_PERCENT,
	"CPU%c3"  => DataTypes::DATA_SUCCESS_PERCENT,
	"CPU%c4"  => DataTypes::DATA_SUCCESS_PERCENT,
	"CPU%c5"  => DataTypes::DATA_SUCCESS_PERCENT,
	"CPU%c6"  => DataTypes::DATA_SUCCESS_PERCENT,
	"CPU%c7"  => DataTypes::DATA_SUCCESS_PERCENT,
	"CPU%c8"  => DataTypes::DATA_SUCCESS_PERCENT,
	"CPU%c9"  => DataTypes::DATA_SUCCESS_PERCENT,
	"Busy%"   => DataTypes::DATA_SUCCESS_PERCENT,
	"%Busy"   => DataTypes::DATA_SUCCESS_PERCENT,
	"Avg_MHz" => DataTypes::DATA_FREQUENCY_MHZ,
);

sub initialise() {
	my ($self, $subHeading) = @_;

	$self->{_ModuleName} = "MonitorTurbostat";
	$self->{_PlotType} = "simple";
	$self->{_DefaultPlot} = "Avg_Mhz";
	$self->{_ExactSubheading} = 1;
	$self->{_DataTypes} = \%datatypes;
	$self->SUPER::initialise($subHeading);
}

sub extractReport() {
	my ($self, $reportDir, $testBenchmark, $subHeading) = @_;
	my $timestamp;
	my $start_timestamp = 0;
	my $input;

	# Discover column header names
	if (scalar keys %_colMap == 0) {
		$input = $self->SUPER::open_log("$reportDir/turbostat-$testBenchmark");
		while (!eof($input)) {
			my $line = <$input>;
			next if ($line !~ /\s+Core\s+CPU/ && $line !~ /\s+CPU\s+Avg_MHz/);
			$line =~ s/^\s+//;
			my @elements = split(/\s+/, $line);

			my $index;
			foreach my $header (@elements) {
				if ($header =~ /CPU%c[0-9]/ ||
				    $header eq "CorWatt" ||
				    $header eq "PkgWatt" ||
				    $header eq "%Busy" ||
				    $header eq "Busy%" ||
				    $header eq "Avg_MHz") {
					$_colMap{$header} = $index;
				}

				$index++;
			}
			last;
		}
		close($input);
		@fieldHeaders = sort keys %_colMap;
	}

	# Fill in the headers
	if ($subHeading ne "") {
		if (!defined $_colMap{$subHeading}) {
			die("Unrecognised heading $subHeading");
		}
	}

	# Read all counters
	my $timestamp = 0;
	my $start_timestamp = 0;
	my $offset;
	$input = $self->SUPER::open_log("$reportDir/turbostat-$testBenchmark");
	while (!eof($input)) {
		my $line = <$input>;

		$line =~ s/^\s+//;
		my @elements = split(/\s+/, $line);

		# Monitor in with timestamps prepended?
		if ($elements[3] eq "--") {
			$offset = 4;
		} else {
			$offset = 0;
		}
		# We gather data only from the turbostat summary line
		next if $elements[$offset] ne "-";

		if ($elements[3] eq "--") {
			$timestamp = $elements[0];
		} else {
			$timestamp++;
		}
		if ($start_timestamp == 0) {
			$start_timestamp = $timestamp;
		}
		foreach my $header (@fieldHeaders) {
			if ($subHeading eq "" || $header eq $subHeading) {
				$self->addData($header,
					$timestamp - $start_timestamp,
					$elements[$_colMap{$header}]);
			}
		}
	}
	close($input);
}

1;
