# ExtractFutexbenchhash.pm
package MMTests::ExtractFutexbenchhash;
use MMTests::ExtractFutexbenchcommon;
our @ISA = qw(MMTests::ExtractFutexbenchcommon);

sub initialise() {
	my ($self, $subHeading) = @_;
	$self->{_ModuleName} = "ExtractFutexbenchhash";
	$self->{_DataType}   = DataTypes::DATA_OPS_PER_SECOND;
	$self->{_PlotType}   = "thread-errorlines";

	$self->SUPER::initialise($subHeading);
}

1;
