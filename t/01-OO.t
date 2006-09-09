#!/usr/bin/perl
use strict;
use warnings;
use blib;  

# Math::Random::OO  

use Test::More tests =>  6 ;
use Test::Exception;

BEGIN { use_ok( 'Math::Random::OO' ); }

my $obj = Math::Random::OO->new ();
isa_ok ($obj, 'Math::Random::OO');
isa_ok ($obj->new, 'Math::Random::OO');
can_ok ($obj, qw( seed next ) );
dies_ok {$obj->seed()} 'does seed abstract method die?';
dies_ok {$obj->next()} 'does next abstract method die?';
