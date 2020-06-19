# PrintHtml.pm
package MMTests::PrintHtml;

my $_colspan;

sub new($) {
	my $class = shift;
	if ($_[0] == 1) {
		$_colspan = "colspan=\"2\"";
	} else {
		$_colspan = "colspan=\"1\"";
	}
	my $self = {};
	bless $self, $class;
}

sub printTop($)
{
	print "<table class=\"resultsTable\">\n";
}

sub printBottom($)
{
	print "</table>\n";
}

sub printHeaders($$$) {
	my $self = shift;
	my $fieldLength = shift;
	my @fieldHeaders = @{ $_[0] };
	my @formatList = @{ $_[1] };
	my $header;

	print "<tr>";
	my $headerIndex = 0;
	foreach $header (@fieldHeaders) {
		if (defined $formatList[$headerIndex]) {
			my $format = "<th $_colspan>$formatList[$headerIndex]</th>";
			printf($formatList[$headerIndex], $header);
		} else {
			printf("<th $_colspan>%${fieldLength}s</th>", $header);
		}
		$headerIndex++;
	}
	print "</tr>\n";
}

sub _printRow($$@) {
	my ($self, $dataRef, $fieldLength, $elementOpen, $elementClose, $formatColumnRef) = @_;
	my (@formatColumnList, @formatRowList);
	my $rowIndex = 1;
	@formatColumnList = @{$formatColumnRef};

	foreach my $row (@{$dataRef}) {
		my $columnIndex = 0;

		print "<tr>";
		foreach my $column (@$row) {
			if (defined $formatColumnList[$columnIndex]) {
				my $format = $formatColumnList[$columnIndex];
				my $cellcolor = "";

				if ($column =~ /:SIG:$/) {
					$column =~ s/:SIG:$//;
					if ($column > 0) {
						$cellcolor = "bgcolor=\"#A0FFA0\"";
					} else {
						$cellcolor = "bgcolor=\"#FFA0A0\"";
					}
				}
				$column =~ s/:NSIG:$//;

				$format = "<$elementOpen $cellcolor>$format</$elementClose>";
				printf($format, $column);
			} else {
				printf("<$elementOpen>%${fieldLength}.2f</$elementClose>", $column);
			}
			$columnIndex++;
		}
		print "</tr>\n";
		$rowIndex++;
	}
}

sub printHeaderRow($$@) {
	my ($self, $dataRef, $fieldLength, $formatColumnRef) = @_;
	$self->_printRow($dataRef, $fieldLength, "th $_colspan", "th", $formatColumnRef);
}

sub printRow($$@) {
	my ($self, $dataRef, $fieldLength, $formatColumnRef) = @_;
	$self->_printRow($dataRef, $fieldLength, "td", "td", $formatColumnRef);
}

sub printRowFineFormat($$@) {
	my ($self, $dataRef, $fieldLength, $formatRef, $prefixFormat, $prefixData) = @_;
	my @formatList;
	if (defined $formatRef) {
		@formatList = @{$formatRef};
	}

	foreach my $row (@{$dataRef}) {
		my $columnIndex = 0;
		if (defined $prefixFormat) {
			printf($prefixFormat, $prefixData);
			$columnIndex++;
		}
		foreach my $column (@$row) {
			if (defined $formatList[$columnIndex]) {
				printf("$formatList[$columnIndex]", $column);
			} else {
				printf("%${fieldLength}.2f", $column);
			}
			$columnIndex++;
		}
		print "\n";
	}
}

sub printFooters() {
}

1;
