#!/usr/bin/perl
use strict;
use warnings;
use blib;  

# Math::Random::OO  

use Test::More 'no_plan';

my @classes = qw(Uniform UniformInt Normal); 
my @seeds = qw/ 0 1 -1 2 /;

for my $c (@classes) {
  $c = "Math::Random::OO::$c";
  require_ok( $c );
  my $rng = $c->new();
  my @rands;
  for my $s ( @seeds ) {
    $rng->seed($s);
    push @rands, [ map { $rng->next } 1 .. 5 ];
  }
  while ( my $first = shift @rands ) {
    for my $r ( @rands ) {
      ok( ! eq_array( $first, $r ), "$c\: $first contents differ from $r" );
    }
  }
}
