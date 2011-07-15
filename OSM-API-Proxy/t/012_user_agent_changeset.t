use Test::More tests => 6;
use strict;
use warnings;

use_ok 'OSM::API::User';
use_ok 'OSM::API::Point';
use_ok 'OSM::API::ChangeSet';
use_ok 'OSM::API::RemoteServerAgent';

my $user=OSM::API::User->new();

#$user->name($prefs->{username});
#$user->password($prefs->{password});

$user->home_location(OSM::API::Point->new(1,1));
use YAML;
print Dump($user);
print Dump($user->name());
ok($user,"user");

my $a=OSM::API::RemoteServerAgent->new();
$a->user($user); # set the user
$a->readdefaults();

$a->create("http://api.fosm.org:80"); # create an agent
#$a->connect();
ok($a->ua,"user agent");
#$a->post


my $c=OSM::API::ChangeSet->new();
$c->userObj($user);
my $chid= $c->create($a,"first test fosm::api perl");
warn "GOT" . $chid;
ok($chid,$chid);