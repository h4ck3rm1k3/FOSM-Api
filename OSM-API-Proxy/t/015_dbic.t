use Test::More tests => 1;
use strict;
use warnings;
use Dancer::Config;
 use Dancer::Test;
use_ok 'OSM::API::Proxy';

#use YAML;
use Data::Dumper;

$Data::Dumper::Maxdepth=2;

use Dancer::Plugin::DBIC qw(schema);
Dancer::Config::load();
#my $id =332459248;
my $id = 430705589;

#OK, this works my @nodes = schema("osm")->resultset('NodeTag')->all();	
#warn Dumper(\@nodes);
my $node = schema("osm")->resultset('Node')->find( { id => $id });
#warn Dumper(@node);
#warn $node->id();
warn Dumper($node->node_tags());
warn Dumper($node->changeset());
##my @node = schema("osm")->resultset('Node')->search_rs( { id => $id });

