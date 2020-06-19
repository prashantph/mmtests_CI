# SummariseSingleops.pm
package MMTests::SummariseSingleops;
use MMTests::Extract;
use MMTests::Summarise;
use MMTests::Stat;
our @ISA = qw(MMTests::Summarise);
use strict;

sub new() {
	my $class = shift;
	my $self = {
		_ModuleName  => "SummariseSingleops",
	};
	bless $self, $class;
	return $self;
}

sub initialise() {
	my ($self, $subHeading) = @_;
	my $fieldLength = 12;
	if (defined $self->{_FieldLength}) {
		$fieldLength = $self->{_FieldLength};
	}

	$self->{_SummaryStats} = [ "_value" ];
	$self->{_RatioSummaryStat} = [ "_value" ];

	$self->SUPER::initialise($subHeading);

	$self->{_FieldFormat} = [ "", "%${fieldLength}.2f" ];
	$self->{_FieldHeaders} = [ $self->{_Opname} ? $self->{_Opname} : "Ops" ];
}

1;
