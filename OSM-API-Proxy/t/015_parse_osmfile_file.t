use Test::More tests => 3;
use strict;
use warnings;
use YAML;
use_ok("OSM::API::OsmFile");
my $p = OSM::API::OsmFile->new();

open IN,"./views/test.osm" or die ;
my $xml="";
while (<IN>)
{
	$xml .=		$_;
}
close IN;
my $c2 = $p->parse($xml);
ok($p);
ok($c2);

