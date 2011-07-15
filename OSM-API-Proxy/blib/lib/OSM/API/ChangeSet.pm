package OSM::API::ChangeSet;
use OSM::API::Box;
use OSM::API::User;
use OSM::API::Tags;
use Moose;
use Moose::Util::TypeConstraints;
use OSM::API::RemoteServerAgent;
use MooseX::Types::DateTimeX qw( DateTime );


has 'bbox' => (is=>'rw', isa=>'OSM::API::Box');
has 'open' => (is=>'rw', isa=>'Bool');
has 'created_at' => (is=>'rw', isa=>'String');
#"2008-11-08T19:07:39+01:00"

has 'userObj' => (is=>'rw', isa=>'OSM::API::User');
has 'id' => (is=>'rw', isa=>'Int');

#has 'connection' => (is=>'rw', isa=>'OSM::API::RemoteServerAgent');

sub uid
{
    my $self=shift;
    return $self->userObj()->uid();
}

sub user
{
    my $self=shift;
    return $self->userObj()->name();
}

sub right
{
    my $self=shift;
    return $self->get_max()->get_lon();
}

sub bottom
{
    return get_min->get_lat();
}
sub top
{
    return get_max->get_lat();
}

sub create
{
    my $self=shift;
    my $connection=shift;
    my $comment = shift;

    $comment = (defined($comment)) ? "<tag k=\"comment\" v=\"$comment\" />" : "";
    my $resp = $connection->put("changeset/create", "<osm version='0.6'><changeset>$comment</changeset></osm>");
    if (!$resp->is_success)
    {
        print STDERR "cannot create changeset: ".$resp->status_line."\n";
        return undef;
    }
    return $resp->content();
}

1;
