use 5.006;
use strict;
use warnings;

package Math::Random::OO::UniformInt;
# ABSTRACT: Generates random integers with uniform probability
# VERSION

# Required modules
use Carp;
use Params::Validate ':all';

# ISA
use base qw( Class::Accessor::Fast );

=method C<new>

 $prng1 = Math::Random::OO::UniformInt->new();
 $prng2 = Math::Random::OO::UniformInt->new($high);
 $prng3 = Math::Random::OO::UniformInt->new($low,$high);

C<new> takes up to two optional parameters and returns a new
C<Math::Random::OO::UniformInt> object.  Unlike Uniform, it returns integers
inclusive of specified endpoints. With no parameters, the object generates
random integers in the range of zero (inclusive) to one (inclusive).  With a
single parameter, the object generates random numbers from zero (inclusive) to
the value of the parameter (inclusive).  Note, the object does this with
multiplication, so if the parameter is negative, the function will return
negative numbers.  This is a feature or bug, depending on your point of view.
With two parameters, the object generates random integers from the first
parameter (inclusive) to the second parameter (inclusive).  (Actually, as long
as you have two parameters, C<new> will put them in the right order).  If
parameters are non-integers, they will be truncated to integers before the
range is calculated.  I.e., C<new(-1.2, 3.6)> is equivalent to C<new(-1,3)>.

=cut

{
    my $param_spec = {
        low  => { type => SCALAR },
        high => { type => SCALAR }
    };

    __PACKAGE__->mk_accessors( keys %$param_spec );
    #__PACKAGE__->mk_ro_accessors( keys %$param_spec );

    sub new {
        my $class = shift;
        my $self = bless {}, ref($class) ? ref($class) : $class;
        if ( @_ > 1 ) {
            my ( $low, $high ) = sort { $a <=> $b } @_[ 0, 1 ]; # DWIM
            $self->low( int($low) );
            $self->high( int($high) );
        }
        elsif ( @_ == 1 ) {
            $self->low(0);
            $self->high( int( $_[0] ) );
        }
        else {
            $self->low(0);
            $self->high(1);
        }
        return $self;
    }
}

=method C<seed>

 $rv = $prng->seed( @seeds );

This method seeds the random number generator.  At the moment, only the
first seed value matters.  It should be a positive integer.

=cut

sub seed {
    my $self = shift;
    srand( $_[0] );
}

=method C<next>

 $rnd = $prng->next();

This method returns the next random number from the random number generator.
It does not take any parameters.

=cut

sub next {
    my ($self) = @_;
    my $rnd = int( rand( $self->high - $self->low + 1 ) ) + $self->low;
    return $rnd;
}

1;

__END__

=head1 SYNOPSIS

  use Math::Random::OO::UniformInt;
  push @prngs,
      Math::Random::OO::UniformInt->new(),     # 0 or 1
      Math::Random::OO::UniformInt->new(5),    # 0, 1, 2, 3, 4, or 5
      Math::Random::OO::UniformInt->new(-1,1); # -1, 0, or 1
  $_->seed(42) for @prngs;
  print( $_->next() . "\n" ) for @prngs;
  
=head1 DESCRIPTION

This subclass of L<Math::Random::OO> generates random integers with uniform
probability.

=cut
