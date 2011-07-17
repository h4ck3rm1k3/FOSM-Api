use Test::More tests => 1;
use strict;
use warnings;
use YAML;
use_ok("OSM::API::OsmChange");
my $p = OSM::API::OsmChange->new();
$p->parse(q[<osmChange version="0.6" generator="JOSM">
<modify>
  <node id='1287731165' action='modify' timestamp='2011-05-16T14:56:18Z' uid='355102' user='BesfortGuri/Besfort Guri/BesfortGuri/Besfort Guri/Besfort Guri/BesfortGuri' visible='true' version='2' changeset='1000001384' lat='42.61893168122738' lon='20.57614856619908' />
</modify>
</osmChange>]);
warn Dump($p);
ok($p);