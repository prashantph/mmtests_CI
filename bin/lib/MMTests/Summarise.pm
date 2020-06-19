# Summarise.pm
package MMTests::Summarise;
use MMTests::Extract;
use MMTests::DataTypes;
use MMTests::Stat;
our @ISA = qw(MMTests::Extract);
use strict;

sub new() {
	my $class = shift;
	my $self = {
		_ModuleName  => "Summarise",
	};
	bless $self, $class;
	return $self;
}

sub initialise() {
	my ($self, $subHeading) = @_;
	my $plotType = "candlesticks";
	my $opName = "Ops";
	my @sumheaders;

	if (defined $self->{_Opname}) {
		$opName = $self->{_Opname};
	} else {
		$self->{_Opname} = $opName;
	}
	if (defined $self->{_PlotType}) {
		$plotType = $self->{_PlotType};
	} else {
		$self->{_PlotType} = $plotType;
	}

	$self->SUPER::initialise($subHeading);
	$self->{_FieldLength} = 12 if ($self->{_FieldLength} == 0);
	my $fieldLength = $self->{_FieldLength};
	$self->{_FieldFormat} = [ "%${fieldLength}d", "%${fieldLength}.2f" ];
	$self->{_FieldHeaders} = [ "Sample", $opName ];
	for (my $header = 0; $header < scalar @{$self->{_SummaryStats}};
	     $header++) {
		push @sumheaders, $self->getStatName($header);
	}
	$self->{_SummaryHeaders} = \@sumheaders;
}

sub typeToPreferredVal() {
	my ($self, $type) = @_;

	if ($type == DataTypes::DATA_TIME_SECONDS ||
	    $type == DataTypes::DATA_TIME_NSECONDS ||
	    $type == DataTypes::DATA_TIME_MSECONDS ||
	    $type == DataTypes::DATA_TIME_USECONDS ||
	    $type == DataTypes::DATA_TIME_CYCLES ||
	    $type == DataTypes::DATA_BAD_ACTIONS ||
	    $type == DataTypes::DATA_SIZE_QUEUED ||
	    $type == DataTypes::DATA_CONSUMPTION_WATT ||
	    $type == DataTypes::DATA_USAGE_PERCENT ||
	    $type == DataTypes::DATA_SIZE_BYTES ||
	    $type == DataTypes::DATA_SIZE_KBYTES ||
	    $type == DataTypes::DATA_SIZE_MBYTES ||
	    $type == DataTypes::DATA_SIZE_PAGES ||
	    $type == DataTypes::DATA_BALANCE) {
		return "Lower";
	}
	return "Higher";
}

sub getPreferredValue() {
	my ($self, $op) = @_;
	return $self->typeToPreferredVal($self->getDataType($op));
}

# If there's single data type for the module, use its direction even for
# ratio comparisons. Otherwise create ratios so that lower values are always
# preferred.
sub getRatioPreferredValue() {
	my ($self) = @_;

	if (defined($self->{_DataType})) {
		return $self->typeToPreferredVal($self->{_DataType});
	}
	return "Lower";
}

sub summaryOps() {
	my ($self, $subHeading) = @_;

	return $self->getOperations($subHeading);
}

sub getStatCompareFunc() {
	my ($self, $operation, $sumop) = @_;
	my $value;

	($sumop, $value) = split("-", $sumop);
	# We don't bother to convert _mean here to appropriate mean type as
	# that is always based on preferred value anyway
	if (!defined(MMTests::Stat::stat_compare->{$sumop})) {
		if ($self->getPreferredValue($operation) eq "Higher") {
			return "pdiff";
		}
		return "pndiff";
	}
	return MMTests::Stat::stat_compare->{$sumop};
}

sub getStatName() {
	my ($self, $operation, $sumop) = @_;
	my ($opname, $value, $mean);

	if ($self->getPreferredValue($operation) eq "Higher") {
		$mean = "hmean";
	} else {
		$mean = "amean";
	}
	$sumop =~ s/^_mean/$mean/;
	$sumop =~ s/^_value/$self->{_Opname}/;

	if (defined(MMTests::Stat::stat_names->{$sumop})) {
		return MMTests::Stat::stat_names->{$sumop};
	}
	($opname, $value) = split("-", $sumop);
	$opname .= "-";
	if (!defined(MMTests::Stat::stat_names->{$opname})) {
		return $sumop;
	}
	return sprintf(MMTests::Stat::stat_names->{$opname}, $value);
}

sub ratioSummaryOps() {
	my ($self, $subHeading) = @_;

	if (!defined($self->{_RatioOperations})) {
		return $self->getOperations($subHeading);
	}
	return $self->filterSubheading($subHeading, $self->{_RatioOperations});
}

sub printPlot() {
	my ($self, $subHeading) = @_;
	my %data = %{$self->{_ResultData}};
	my @_operations;
	my $fieldLength = $self->{_FieldLength};
	my $column = 1;

	if ($subHeading eq "") {
		$subHeading = $self->{_DefaultPlot}
	}
	@_operations = $self->getOperations($subHeading);

	if ($subHeading ne "" && $self->{_ExactSubheading} == 1) {
		if (defined $self->{_ExactPlottype}) {
			$self->{_PlotType} = $self->{_ExactPlottype};
		}
	}

	$self->sortResults();

	my $nr_headings = 0;
	foreach my $heading (@_operations) {
		my @index;
		my @units;
		my @row;
		my $samples;
		my $niceheading = $heading;

		if ($self->{_PlotStripSubheading}) {
			if ($self->{_ClientSubheading} == 1) {
				$niceheading =~ s/-$subHeading$//;
			} else {
				$niceheading =~ s/^$subHeading-//;
			}
		}
		if ($self->{_PlotType} =~ /client-.*/) {
			if ($self->{_ClientSubheading} == 1) {
				$niceheading =~ s/-.*//;
			} else {
				$niceheading =~ s/.*-//;
			}
		}

		@units = map { @{$_->{Values}} } @{$data{$heading}};
		my $iteroff = 0;
		for (my $iter = 0; $iter < scalar(@{$data{$heading}}); $iter++) {
			push @index, map {$iteroff + $_}
				@{$data{$heading}->[$iter]->{SampleNrs}};
			$iteroff = $index[$#index] + 1;
		}

		$nr_headings++;
		if ($self->{_PlotType} =~ /simple.*/) {
			my $fake_samples = 0;

			if ($self->{_PlotType} =~ /simple-samples/) {
				$fake_samples = 1;
			}

			for ($samples = 0; $samples <= $#index; $samples++) {
				my $stamp = $index[$samples] - $index[0];
				if ($fake_samples) {
					$stamp = $samples;
				}

				# Use %d for integers to avoid strangely looking graphs
				if (int $index[$samples] != $index[$samples]) {
					printf("%-${fieldLength}.3f %${fieldLength}.3f\n", $stamp, $units[$samples]);
				} else {
					printf("%-${fieldLength}d %${fieldLength}.3f\n", $stamp, $units[$samples]);
				}
			}
		} elsif ($self->{_PlotType} eq "candlesticks") {
			printf "%-${fieldLength}s ", $niceheading;
			$self->_printCandlePlotData($fieldLength, @units);
		} elsif ($self->{_PlotType} eq "operation-candlesticks") {
			printf "%d %-${fieldLength}s ", $nr_headings, $niceheading;
			$self->_printCandlePlotData($fieldLength, @units);
		} elsif ($self->{_PlotType} eq "client-candlesticks") {
			printf "%-${fieldLength}s ", $niceheading;
			$self->_printCandlePlotData($fieldLength, @units);
		} elsif ($self->{_PlotType} eq "single-candlesticks") {
			$self->_printCandlePlotData($fieldLength, @units);
		} elsif ($self->{_PlotType} eq "client-errorbars") {
			printf "%-${fieldLength}s ", $niceheading;
			$self->_printErrorBarData($fieldLength, @units);
		} elsif ($self->{_PlotType} eq "client-errorlines") {
			printf "%-${fieldLength}s ", $niceheading;
			$self->_printErrorBarData($fieldLength, @units);
		} elsif ($self->{_PlotType} =~ "histogram") {
			for ($samples = 0; $samples <= $#units; $samples++) {
				printf("%-${fieldLength}s %${fieldLength}.3f\n",
					$niceheading, $units[$samples]);
			}
		}
	}
}

sub runStatFunc
{
	my ($self, $operation, $func, $dataref) = @_;
	my ($mean, $arg);

	# $dataref is expected to be already sorted in appropriate order
	if ($self->getPreferredValue($operation) eq "Higher") {
		$mean = "hmean";
	} else {
		$mean = "amean";
	}
	# Subselection means are special. They take mean name as an argument
	# and they also need 2-dimensional array with data to know which sample
	# comes from which iteration.
	if ($func eq "_mean-sub") {
		my @data = map {$_->{Values}} @{$self->{_ResultData}->{$operation}};
		return calc_submean_ci($mean, \@data);
	}
	# calc_submean_ci returns two element list, thus following 'submeanci'
	# has nothing to do and must return empty list. This is because
	# calculating submean is relatively expensive and we get CI with it
	# as well so it would be stupid to recompute it again.
	if ($func eq "submeanci") {
		return ();
	}
	if ($func eq "_value") {
		return $dataref->[0];
	}
	$func =~ s/^_mean/$mean/;

	($func, $arg) = split("-", $func);
	# Percentiles are trivial, no need to copy the whole data array for them
	if ($func eq "percentile") {
		my $nr_elements = scalar(@{$dataref});
		my $count = int ($nr_elements * $arg / 100);

		$count = $count < 1 ? 1 : $count;
		return $dataref->[$count-1];
	}
	if ($func eq "samples") {
		return calc_samples($dataref, $arg);
	} elsif ($func eq "samplespct") {
		return calc_samplespct($dataref, $arg);
	}
	$func = "calc_$func";
	# Another argument to statistics function?
	if ($arg > 0) {
		# All other numeric arguments are just a percentage of data to
		# compute function from.
		my $nr_elements = scalar(@{$dataref});
		my $count = int ($nr_elements * $arg / 100);
		$count = $count < 1 ? 1 : $count;
		my @data = @{$dataref}[0..($count-1)];

		no strict "refs";
		return &$func(\@data);
	}
	no strict "refs";
	return &$func($dataref);
}

sub extractSummary() {
	my ($self, $subHeading) = @_;
	my @_operations = $self->summaryOps($subHeading);
	my %data = %{$self->{_ResultData}};

	my %summary;
	my %significance;
	foreach my $operation (@_operations) {
		my @units;

		@units = map { @{$_->{Values}} } @{$data{$operation}};
		if ($self->getPreferredValue($operation) eq "Lower") {
			@units = sort { $a <=> $b} @units;
		} else {
			@units = sort { $b <=> $a} @units;
		}

		$summary{$operation} = [];
		foreach my $func (@{$self->{_SummaryStats}}) {
			my @values = $self->runStatFunc($operation, $func,
							\@units);
			foreach my $value (@values) {
				if (($value ne "NaN" && $value ne "nan") || $self->{_FilterNaN} != 1) {
					push @{$summary{$operation}}, $value;
				}
			}
		}

		$significance{$operation} = [];

		my $mean = $self->runStatFunc($operation, "_mean", \@units);
		push @{$significance{$operation}}, $mean;

		my $stderr = calc_stddev(\@units);
		push @{$significance{$operation}}, $stderr ne "NaN" ? $stderr : 0;

		push @{$significance{$operation}}, $#units+1;

		if ($self->{_SignificanceLevel}) {
			push @{$significance{$operation}}, $self->{_SignificanceLevel};
		} else {
			push @{$significance{$operation}}, 0.10;
		}
	}
	$self->{_SummaryData} = \%summary;
	$self->{_SignificanceData} = \%significance;

	return 1;
}

sub extractRatioSummary() {
	my ($self, $subHeading) = @_;
	my @_operations = $self->ratioSummaryOps($subHeading);
	my %data = %{$self->{_ResultData}};
	my %summary;
	my %summaryCILen;
	foreach my $operation (@_operations) {
		my @units;
		my @values;

		@units = map { @{$_->{Values}} } @{$data{$operation}};
		if ($self->getPreferredValue($operation) eq "Lower") {
			@units = sort { $a <=> $b} @units;
		} else {
			@units = sort { $b <=> $a} @units;
		}

		foreach my $func (@{$self->{_RatioSummaryStat}}) {
			no strict "refs";
			push @values, $self->runStatFunc($operation, $func,
				\@units);
		}

		if (($values[0] ne "NaN" && $values[0] ne "nan") ||
		    $self->{_FilterNaN} != 1) {
			$summary{$operation} = [$values[0]];
			if ($#values == 1 && $values[1] ne "NaN") {
				$summaryCILen{$operation} = $values[1];
			}
		}
	}
	$self->{_SummaryData} = \%summary;
	$self->{_SummaryCILen} = \%summaryCILen if %summaryCILen;

	return 1;
}

1;
