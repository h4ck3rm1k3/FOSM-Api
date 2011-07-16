package OSM::API::RemoteServerAgent;
use OSM::API::User;
use Moose;
use Moose::Util::TypeConstraints;
use LWP::UserAgent;
use LWP::Debug qw(+);
BEGIN { $LWP::DebugFile::outpath = '/tmp/crunk/' }
use LWP::DebugFile;
use Carp qw[confess croak];

has 'ua' => (
    is=>'rw',
    isa=>"LWP::UserAgent"
);

has 'user' => (
    is=>'rw',
    isa=>"OSM::API::User"
);
has 'apiurl' => (
    is=>'rw',
    isa=>"Str"
    );

has 'realm' => (
    is=>'rw',
    isa=>"Str"
    ); # FOSM for the fosm.org

sub readdefaults
{
    my $self=shift;
    my $prefs={};
    open (PREFS, $ENV{HOME}."/.fosmapi") or die "cannot open ". $ENV{HOME}."/.fosmapi";
    while(<PREFS>)
    {
        if (/^(\S+)\s*=\s*(\S*)/)
        {
            $prefs->{$1} = $2;
        }
    }
    close (PREFS);

    foreach my $required("username","password","apiurl")
    {
        die $ENV{HOME}."/.fosmapi does not have $required" unless defined($prefs->{$required});
    }
    $self->user->name($prefs->{username});
    $self->user->password($prefs->{password});
    $self->realm($prefs->{realm});
    $self->apiurl($prefs->{apiurl});
}

sub create
{
    my $self=shift;
#    my $host=shift;
    if ($self->apiurl)
    {
	$self->apiurl =~ m!https?://([^/]+)/!;
	my $host = $1;
	if ($host)
	{
	    $host .= ":80" unless ($host =~ /:/);
	}	
	$self->ua(LWP::UserAgent->new);
	$self->ua->credentials($host,$self->realm(), $self->{user}->name(), $self->{user}->password);
	$self->ua->agent("fosm.org/api/0.6");	
	$self->ua->timeout(600);
    }
    else
    {
	confess "Need apiurl";
    }
}

sub get
{
    my $self = shift;
    my $url = shift;
    my $req = HTTP::Request->new(GET => $self->{apiurl}.$url);
    my $resp = $self->ua->request($req);
#    debuglog($req, $resp) if ($self->{"debug"});
    return($resp);
}

sub put
{
    my $self = shift;
    my $url = shift;
    my $body = shift;
#    return $dummy if ($self->{dryrun});
    my $req = HTTP::Request->new(PUT => $self->{apiurl}."0.6/".$url);
    $req->content($body) if defined($body);
    my $resp = $self->ua->request($req);
 #   debuglog($req, $resp) if ($self->{"debug"});
    return $resp;
}

sub post
{
    my $self = shift;
    my $url = shift;
    my $body = shift;
#    return $dummy if ($self->{dryrun});
    my $req = HTTP::Request->new(POST => $self->{apiurl}.$url);
    $req->content($body) if defined($body);
    my $resp = $self->ua->request($req);
#    debuglog($req, $resp) if ($self->{"debug"});
    return $resp;
}

sub delete
{
    my $self = shift;
    my $url = shift;
    my $body = shift;
#    return $dummy if ($self->{dryrun});
    my $req = HTTP::Request->new(DELETE => $self->{apiurl}.$url);
    $req->content($body) if defined($body);
    my $resp = $self->ua->request($req);
#    debuglog($req, $resp) if ($self->{"debug"});
    return $resp;
}

1;
