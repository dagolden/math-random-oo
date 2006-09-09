package Math::Random::OO::Uniform;
use 5.006;
use strict;
use warnings;
our $VERSION = "0.16";

# Required modules
use Carp;
use Params::Validate ':all';

# ISA
use base qw( Class::Accessor::Fast );
#--------------------------------------------------------------------------#
# main pod documentation #####
#--------------------------------------------------------------------------#

=head1 NAME

Math::Random::OO::Uniform - Generates random numbers from the uniform
distribution

=head1 SYNOPSIS

  use Math::Random::OO::Uniform;
  push @prngs,
      Math::Random::OO::Uniform->new(),     # range [0,1)
      Math::Random::OO::Uniform->new(5),    # range [0,5)
      Math::Random::OO::Uniform->new(-1,1); # range [-1,1)
  $_->seed(0.42) for @prngs;
  print( $_->next() . "\n" ) for @prngs;
  
=head1 DESCRIPTION

This subclass of L<Math::Random::OO> generates random reals from a uniform
probability distribution.

=head1 USAGE

=cut

#--------------------------------------------------------------------------#
# new()
#--------------------------------------------------------------------------#

=head2 C<new>

 $prng1 = Math::Random::OO::Uniform->new();
 $prng2 = Math::Random::OO::Uniform->new($high);
 $prng3 = Math::Random::OO::Uniform->new($low,$high);

C<new> takes up to two optional parameters and returns a new
C<Math::Random::OO::Uniform> object.  With no parameters, the object generates
random numbers in the range of zero (inclusive) to one (exclusive).  With a
single parameter, the object generates random numbers from zero (inclusive) to
the value of the parameter (exclusive).  Note, the object does this with
multiplication, so if the parameter is negative, the function will return
negative numbers.  This is a feature or bug, depending on your point of view.
With two parameters, the object generates random numbers from the first
parameter (inclusive) to the second parameter (exclusive).  (Actually, as 
long as you have two parameters, C<new> will put them in the right order).

=cut

{
    my $param_spec = {
        low => { type => SCALAR },
        high => { type => SCALAR }
    };

    __PACKAGE__->mk_accessors( keys %$param_spec );
    #__PACKAGE__->mk_ro_accessors( keys %$param_spec );

    sub new {
        my $class = shift;
        my $self = bless {}, ref($class) ? ref($class) : $class;
        if ( @_ > 1 ) {
            my ($low, $high) = sort { $a <=> $b } @_[0,1]; # DWIM
            $self->low($low);
            $self->high($high);
        }
        elsif (@_ == 1) {
            $self->low(0);
            $self->high($_[0]);
        }
        else {
            $self->low(0);
            $self->high(0);
        }
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

This method returns the next random number from the random number generator.
It does not take any parameters.

=cut

sub next {
	my ($self) = @_;
    my $rnd = rand($self->high - $self->low) + $self->low;
    return $rnd;	
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
