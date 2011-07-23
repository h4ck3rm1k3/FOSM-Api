use Test::More tests => 1;
use strict;
use warnings;
use Dancer::Config;
 use Dancer::Test;
use_ok 'OSM::API::Proxy';

use Dancer::Plugin::DBIC qw(schema);
Dancer::Config::load();
my $user = schema("osm")->resultset('User')->find("1");	