use Test::More tests => 1;
use strict;
use warnings;
use YAML;
use Dancer::Config;
 use Dancer::Test;
use Dancer::Plugin::DBIC qw(schema);
Dancer::Config::load();

use_ok("OSM::API::OsmChange");
my $p = OSM::API::OsmChange->new();

open IN,"./t/005_1.osc" or die ;
my $xml="";
my $c2;
   
 while (<IN>)
 {
 	$xml .=		$_;
 }
 close IN;
 $c2 = $p->parse($xml);
 $c2->ProcessUsersUpload();
#warn Dump($c2);
# warn Dump($p);
 ok($p);
 ok($c2);

#####################################################
if (0)
{
open IN,"./t/005_2.osc" or die ;
$xml="";
while (<IN>)
{
	$xml .=		$_;
}
close IN;
$c2 = $p->parse($xml);

ok($p);
ok($c2);
$c2->ProcessUsersUpload;
#$p->ProcessUsersUpload;
warn $xml;
warn Dump($p);
warn Dump($c2);
}
# ####################################################
# open IN,"./t/420.osc" or die ;
# $xml="";
# while (<IN>)
# {
# 	$xml .=		$_;
# }
# close IN;
# $c2 = $p->parse($xml);
# #warn Dump($p);
# ok($p);
# ok($c2);
# ####################################################

# open IN,"./t/681.osc" or die ;
# $xml="";
# while (<IN>)
# {
# 	$xml .=		$_;
# }
# close IN;
# $c2 = $p->parse($xml);
# #warn Dump($p);
# ok($p);
# ok($c2);

# ####################################################
# open IN,"./t/005.osc" or die ;
# $xml="";
# while (<IN>)
# {
# 	$xml .=		$_;
# }
# close IN;
# $c2 = $p->parse($xml);
# ok($p);
# ok($c2);
# ####################################################