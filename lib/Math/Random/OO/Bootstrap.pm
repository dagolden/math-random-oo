package Math::Random::OO::Bootstrap;
use 5.006;
use strict;
use warnings;
our $VERSION = "0.19";

# Required modules
use Carp;
use Params::Validate ':all';

# ISA
use base qw( Class::Accessor::Fast );
#--------------------------------------------------------------------------#
# main pod documentation #####
#--------------------------------------------------------------------------#

=head1 NAME

Math::Random::OO::Bootstrap - Generate random numbers with bootstrap 
resampling from a non-parametric distibution

=head1 SYNOPSIS

  use Math::Random::OO::Bootstrap;
  @sample = qw( 2 3 3 4 4 5 5 6 6 7 );
  $prng = Math::Random::OO::Bootstrap->new(@sample);
  $prng->seed(0.42);
  $prng->next() # draws randomly from the sample
  
=head1 DESCRIPTION

This subclass of L<Math::Random::OO> generates random numbers with bootstrap
resampling (i.e. resampling with replacement) from a given set of observations.
Each item in the sample array is drawn with equal probability.

=head1 USAGE

=cut

#--------------------------------------------------------------------------#
# new()
#--------------------------------------------------------------------------#

=head2 C<new>

 $prng = Math::Random::OO::Bootstrap->new(@sample);
 $prng = Math::Random::OO::Bootstrap->new(\@sample);

C<new> takes either a list or a reference to an array containing a
set of observations and returns a new C<Math::Random::OO::Bootstrap> object.
If a reference is provided, the object will make an internal copy
of the array to avoid unexpected results if the source reference
is modified. 

If the desired sample is an array of array references, the list
must be enclosed in an anonymous array reference to avoid ambiguity.

 @sample = ( [ 1, 2, 3], [2, 3, 4] );

 # Correct way
 $prng = Math::Random::OO::Bootstrap->new( [ @sample ] );
 
 # Incorrect -- will only use [1, 2, 3] as the desired sample
 $prng = Math::Random::OO::Bootstrap->new( @sample );

It is an error to call C<new> with no arguments.

=cut


{
    my $param_spec = {
        data => { type => ARRAYREF },
        size => { type => SCALAR }
    };

    __PACKAGE__->mk_accessors( keys %$param_spec );
    #__PACKAGE__->mk_ro_accessors( keys %$param_spec );

    sub new {
        my $class = shift;
        my $self = bless {}, ref($class) ? ref($class) : $class;
        if ( @_ == 0 ) {
            croak 'Math::Random::OO::Bootstrap->new() requires an argument';
        }
        $self->data( ref $_[0] eq 'ARRAY' ? [ @{$_[0]} ] : [ @_ ] );
        $self->size( scalar @{$self->data} );
        return $self;
    }
}


#--------------------------------------------------------------------------#
# seed()
#--------------------------------------------------------------------------#

=head2 C<seed>

 $rv = $prng->seed( @seeds );

This method seeds the random number generator.  At the moment, only the
first seed value matters.

=cut

sub seed {
	my $self = shift;
    srand(@_);
}


#--------------------------------------------------------------------------#
# next()
#--------------------------------------------------------------------------#

=head2 C<next>

 $rnd = $prng->next();

This method returns the next random number from the random number generator
by resampling with replacement from the provided data. It does not take any
parameters.

=cut

sub next {
	my ($self) = @_;
    my $rnd = int(rand($self->size)); # index 0 to (size-1)
    return $self->data->[$rnd];	
}

1; #this line is important and will help the module return a true value
__END__

=head1 BUGS

Please report bugs using the CPAN Request Tracker at 

http://rt.cpan.org/NoAuth/Bugs.html?Dist=Math-Random-OO

=head1 AUTHOR

David A. Golden (DAGOLDEN)

dagolden@dagolden.com

http://dagolden.com/

=head1 COPYRIGHT

Copyright (c) 2004 by David A. Golden

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.


=head1 SEE ALSO

L<Math::Random::OO>

=cut
