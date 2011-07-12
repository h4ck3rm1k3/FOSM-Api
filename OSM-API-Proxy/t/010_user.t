use Test::More tests => 3;
use strict;
use warnings;

use_ok 'OSM::API::User';
use_ok 'OSM::API::Point';

my $p=OSM::API::User->new();

$p->home_location(OSM::API::Point->new(1,1));
use YAML;
print Dump($p);
print Dump($p->name());
ok($p);