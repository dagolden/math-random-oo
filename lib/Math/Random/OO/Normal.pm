package Math::Random::OO::Normal;
use 5.006;
use strict;
use warnings;
our $VERSION = '0.21';

# Required modules
use Carp;
use Params::Validate ':all';

# ISA
use base qw( Class::Accessor::Fast );
#--------------------------------------------------------------------------#
# main pod documentation #####
#--------------------------------------------------------------------------#

=head1 NAME

Math::Random::OO::Normal - Generates random numbers from the normal (Gaussian)
distribution

=head1 SYNOPSIS

  use Math::Random::OO::Normal;
  push @prngs,
      Math::Random::OO::Normal->new(),     # mean 0, stdev 1
      Math::Random::OO::Normal->new(5),    # mean 5, stdev 1
      Math::Random::OO::Normal->new(1,3);  # mean 1, stdev 3
  $_->seed(42) for @prngs;
  print( $_->next() . "\n" ) for @prngs;

=head1 DESCRIPTION

This subclass of L<Math::Random::OO> generates random reals from the normal 
probability distribution, also called the Gaussian or bell-curve distribution.

The module generates random normals from the inverse of the cumulative 
normal distribution using an approximation algorithm developed by Peter J. 
Acklam and released into the public domain.  This algorithm claims a
relative error of less than 1.15e-9 over the entire region.

See http://home.online.no/~pjacklam/notes/invnorm/ for details and discussion.

=head1 USAGE

=cut

#--------------------------------------------------------------------------#
# new()
#--------------------------------------------------------------------------#

=head2 C<new>

 $prng1 = Math::Random::OO::Normal->new();
 $prng2 = Math::Random::OO::Normal->new($mean);
 $prng3 = Math::Random::OO::Normal->new($mean,$stdev);

C<new> takes up to two optional parameters and returns a new
C<Math::Random::OO::Normal> object.  With no parameters, the object generates
random numbers from the standard normal distribution (mean zero, standard
deviation one).  With a single parameter, the object generates random numbers
with mean equal to the parameter and standard deviation of one.  With two
parameters, the object generates random numbers with mean equal to the first
parameter and standard deviation equal to the second parameter.  (Standard
deviation should be positive, but this module takes the absolute value of the
parameter just in case.)

=cut

{
    my $param_spec = {
        mean => { type => SCALAR },
        stdev => { type => SCALAR }
    };

    __PACKAGE__->mk_accessors( keys %$param_spec );
    #__PACKAGE__->mk_ro_accessors( keys %$param_spec );

    sub new {
        my $class = shift;
        my $self = bless {}, ref($class) ? ref($class) : $class;
        if ( @_ > 1 ) {
            $self->mean($_[0]);
            $self->stdev(abs($_[1]));
        }
        elsif (@_ == 1) {
            $self->mean($_[0]);
            $self->stdev(1);
        }
        else {
            $self->mean(0);
            $self->stdev(1);
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
    srand($_[0]);
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
    my $rnd = rand() || 1e-254; # can't have zero for normals
    # _ltqnorm on (0,1) ranges from about -38 to 8, so we'll use
    # the bottom half and invert it for the top half
    my $norm = ( $rnd <= 0.5 ) ? _ltqnorm($rnd) : -( _ltqnorm(1-$rnd) );
    return $norm * $self->stdev + $self->mean;
}

#--------------------------------------------------------------------------#
# Function for inverse cumulative normal
# Used with permission
# http://home.online.no/~pjacklam/notes/invnorm/impl/acklam/perl/
#
# Input checking removed by DAGOLDEN as the input will be prechecked
#--------------------------------------------------------------------------#

sub _ltqnorm ($) {
    # Lower tail quantile for standard normal distribution function.
    #
    # This function returns an approximation of the inverse cumulative
    # standard normal distribution function.  I.e., given P, it returns
    # an approximation to the X satisfying P = Pr{Z <= X} where Z is a
    # random variable from the standard normal distribution.
    #
    # The algorithm uses a minimax approximation by rational functions
    # and the result has a relative error whose absolute value is less
    # than 1.15e-9.
    #
    # Author:      Peter J. Acklam
    # Time-stamp:  2000-07-19 18:26:14
    # E-mail:      pjacklam@online.no
    # WWW URL:     http://home.online.no/~pjacklam

    my $p = shift;
    # DAGOLDEN: arg checking will be done earlier
#    die "input argument must be in (0,1)\n" unless 0 < $p && $p < 1;

    # Coefficients in rational approximations.
    my @a = (-3.969683028665376e+01,  2.209460984245205e+02,
             -2.759285104469687e+02,  1.383577518672690e+02,
             -3.066479806614716e+01,  2.506628277459239e+00);
    my @b = (-5.447609879822406e+01,  1.615858368580409e+02,
             -1.556989798598866e+02,  6.680131188771972e+01,
             -1.328068155288572e+01 );
    my @c = (-7.784894002430293e-03, -3.223964580411365e-01,
             -2.400758277161838e+00, -2.549732539343734e+00,
              4.374664141464968e+00,  2.938163982698783e+00);
    my @d = ( 7.784695709041462e-03,  3.224671290700398e-01,
              2.445134137142996e+00,  3.754408661907416e+00);

    # Define break-points.
    my $plow  = 0.02425;
    my $phigh = 1 - $plow;

    # Rational approximation for lower region:
    if ( $p < $plow ) {
       my $q  = sqrt(-2*log($p));
       return ((((($c[0]*$q+$c[1])*$q+$c[2])*$q+$c[3])*$q+$c[4])*$q+$c[5]) /
               (((($d[0]*$q+$d[1])*$q+$d[2])*$q+$d[3])*$q+1);
    }

    # Rational approximation for upper region:
    if ( $phigh < $p ) {
       my $q  = sqrt(-2*log(1-$p));
       return -((((($c[0]*$q+$c[1])*$q+$c[2])*$q+$c[3])*$q+$c[4])*$q+$c[5]) /
                (((($d[0]*$q+$d[1])*$q+$d[2])*$q+$d[3])*$q+1);
    }

    # Rational approximation for central region:
    my $q = $p - 0.5;
    my $r = $q*$q;
    return ((((($a[0]*$r+$a[1])*$r+$a[2])*$r+$a[3])*$r+$a[4])*$r+$a[5])*$q /
           ((((($b[0]*$r+$b[1])*$r+$b[2])*$r+$b[3])*$r+$b[4])*$r+1);
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
