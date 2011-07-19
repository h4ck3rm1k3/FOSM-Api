use Test::More tests => 1;
use strict;
use warnings;
use YAML;
use_ok("OSM::API::OsmChange");
my $p = OSM::API::OsmChange->new();

open IN,"./t/005_1.osc" or die ;
my $xml="";
while (<IN>)
{
	$xml .=		$_;
}
close IN;
my $c2 = $p->parse($xml);
#warn Dump($p);
ok($p);
ok($c2);

#####################################################
open IN,"./t/005_2.osc" or die ;
$xml="";
while (<IN>)
{
	$xml .=		$_;
}
close IN;
$c2 = $p->parse($xml);
#warn Dump($p);
ok($p);
ok($c2);

####################################################
open IN,"./t/420.osc" or die ;
$xml="";
while (<IN>)
{
	$xml .=		$_;
}
close IN;
$c2 = $p->parse($xml);
#warn Dump($p);
ok($p);
ok($c2);
####################################################

open IN,"./t/681.osc" or die ;
$xml="";
while (<IN>)
{
	$xml .=		$_;
}
close IN;
$c2 = $p->parse($xml);
#warn Dump($p);
ok($p);
ok($c2);

####################################################
open IN,"./t/005.osc" or die ;
$xml="";
while (<IN>)
{
	$xml .=		$_;
}
close IN;
$c2 = $p->parse($xml);
#warn Dump($p);
ok($p);
ok($c2);
####################################################