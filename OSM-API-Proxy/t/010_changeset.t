use Test::More tests => 2;
use strict;
use warnings;

use_ok 'OSM::API::ChangeSet';

my $p=OSM::API::ChangeSet->new();
use YAML;
print Dump($p);
ok($p);