use Test::More tests => 2;
use strict;
use warnings;

use_ok 'OSM::API::Point';

my $p=OSM::API::Point->new(1,180);
use YAML;
print Dump($p);
ok($p);