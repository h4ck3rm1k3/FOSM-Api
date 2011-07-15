use Test::More tests => 5;
use strict;
use warnings;

use_ok 'OSM::API::User';
use_ok 'OSM::API::Point';

my $p=OSM::API::User->new();
$p->name("h4ck3rm1k3");
$p->password("veritasberlinosm");

$p->home_location(OSM::API::Point->new(1,1));
use YAML;
print Dump($p);
print Dump($p->name());
ok($p,"user");

use_ok 'OSM::API::RemoteServerAgent';

my $a=OSM::API::RemoteServerAgent->new();
$a->user($p); # set the user
$a->create("api.fosm.org"); # create an agent
#$a->connect();
ok($a->ua,"user agent");
#$a->post