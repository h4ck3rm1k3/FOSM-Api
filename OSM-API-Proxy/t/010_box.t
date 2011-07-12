use Test::More tests => 3;
use strict;
use warnings;

use_ok 'OSM::API::Box';
use_ok 'OSM::API::Point';

my $p=OSM::API::Box->new(OSM::API::Point->new(1,1),OSM::API::Point->new(180,180));
use YAML;
print Dump($p);
print Dump($p->min());
print Dump($p->max());
ok($p);