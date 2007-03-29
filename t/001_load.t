# -*- perl -*-

# t/001_load.t - check module loading and create testing directory

use Test::More tests => 2;

BEGIN { use_ok( 'WebService::Images::IMGSpot' ); }

my $object = WebService::Images::IMGSpot->new ();
isa_ok ($object, 'WebService::Images::IMGSpot');


