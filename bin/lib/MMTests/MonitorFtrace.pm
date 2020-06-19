# MonitorFtrace.pm
package MMTests::MonitorFtrace;
use MMTests::Summarise;
our @ISA = qw(MMTests::Summarise);
use strict;

sub new() {
	my $class = shift;
	my $self = {
		_ModuleName  => "MonitorFtrace",
	};
	bless $self, $class;
	return $self;
}

sub initialise() {
	my ($self, $subHeading) = @_;

	$self->{_FieldLength} = 16;
	$self->{_Opname} = "Ops";
	if (!defined($self->{_SummaryStats})) {
		$self->{_SummaryStats} = [ "_value" ];
	}
	if (!defined($self->{_RatioSummaryStat})) {
		$self->{_RatioSummaryStat} = [ "_value" ];
	}
	if (!defined($self->{_DataType}) && !defined($self->{_DataTypes})) {
		$self->{_DataType} = DataTypes::DATA_ACTIONS;
	}
	$self->SUPER::initialise($subHeading);

	$self->{_FieldFormat} = [ "", "%12d" ];
}

sub ftraceCallback {
	die("Base ftrace class cannot analyse anything.\n");
}

# Static regex used. Specified like this for readability and for use with /o
#		      (process_pid)     (cpus      )   ( time  )   (tpoint    ) (details)
#my $regex_traceevent = '\s*([a-zA-Z0-9-]*)\s*(\[[0-9]*\])\s*([0-9.]*):\s*([a-zA-Z_]*):\s*(.*)';
my $regex_traceevent = '\s*([a-zA-Z0-9-]*)\s*(\[[0-9]*\])\s*[.0-9a-zA-Z]*\s*([0-9.]*):\s*([a-zA-Z_]*):\s*(.*)';
my $regex_statname = '[-0-9]*\s\((.*)\).*';
my $regex_statppid = '[-0-9]*\s\(.*\)\s[A-Za-z]\s([0-9]*).*';

sub generate_traceevent_regex {
	my ($self, $event, $default) = @_;
	my $regex;

	# Read the event format or use the default
	if (!open (FORMAT, "/sys/kernel/debug/tracing/events/$event/format")) {
		return $default;
	} else {
		my $line;
		while (!eof(FORMAT)) {
			$line = <FORMAT>;
			$line =~ s/, REC->.*//;
			if ($line =~ /^print fmt:\s"(.*)".*/) {
				$regex = $1;
				$regex =~ s/%s/\([0-9a-zA-Z|_]*\)/g;
				$regex =~ s/%p/\([0-9a-f]*\)/g;
				$regex =~ s/%d/\([-0-9]*\)/g;
				$regex =~ s/%u/\([0-9]*\)/g;
				$regex =~ s/%ld/\([-0-9]*\)/g;
				$regex =~ s/%lu/\([0-9]*\)/g;
			}
		}
	}

	# Can't handle the print_flags stuff but in the context of this
	# script, it really doesn't matter
	$regex =~ s/\(REC.*\) \? __print_flags.*//;
	my @expected_list = split(/\s/, $default);

	# Verify fields are in the right order
	my $tuple;
	foreach $tuple (split /\s/, $regex) {
		my ($key, $value) = split(/=/, $tuple);
		my $expected = shift @expected_list;
		$expected =~ s/=.*//;
		if ($key ne $expected) {
			print("WARNING: Format not as expected for event $event '$key' != '$expected'\n");
			$regex =~ s/$key=\((.*)\)/$key=$1/;
		}
	}

	if (defined shift @expected_list) {
		die("Fewer fields than expected in format for $event");
	}

	return $regex;
}

# Convert sec.usec timestamp format
sub timestamp_to_ms($) {
	my $timestamp = $_[0];

	my ($sec, $usec) = split (/\./, $timestamp);
	return ($sec * 1000) + ($usec / 1000);
}

my %processMap;

sub extractReport($$$) {
	my ($self, $reportDir, $testBenchmark, $subHeading, $rowOrientated) = @_;
	my %last_procmap;
	my $input;

	$self->{_SubHeading} = $subHeading;

	my $file = "$reportDir/ftrace-$testBenchmark";

	if (-e "$file.start") {
		if (open($input, $file)) {
			<$input>;
			my ($start, $idle) = split(/ /, <INPUT>);
			$self->{_StartTimestampMs} = $start * 1000;
		}
		close $input;
	}

	$input = $self->SUPER::open_log($file);
	$self->ftraceInit($reportDir, $testBenchmark, $subHeading);

	while (!eof($input)) {
		my $traceevent = <$input>;
		if ($traceevent !~ /$regex_traceevent/o) {
			if ($traceevent !~ /^CPU.*LOST.*EVENTS/) {
				print("WARNING: $traceevent");
			}
			next;
		}

		my $process_pid = $1;
		my $timestamp = timestamp_to_ms($3);;
		my $tracepoint = $4;
		my $details = $5;

		$process_pid =~ /(.*)-([0-9]*)$/;
		my $process = $1;
		my $pid = $2;

		if ($process ne "") {
			$processMap{$pid} = $process;
		} else {
			$process = $processMap{$pid};
			if ($process eq "") {
				$process = "UNKNOWN";
			}
		}

		if ($process eq "") {
			$process = $last_procmap{$pid};
			$process_pid = "$process-$pid";
		}
		$last_procmap{$pid} = $process;
		$self->ftraceCallback($timestamp, $pid, $process, $tracepoint, $details);
	}
	close($input);

	$self->ftraceReport($rowOrientated);
}

1;
