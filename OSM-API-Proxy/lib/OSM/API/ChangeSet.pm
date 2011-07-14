package OSM::API::ChangeSet;
use OSM::API::Box;
use OSM::API::User;
use OSM::API::Tags;
use Moose;
use Moose::Util::TypeConstraints;
has 'bbox' => (is=>'rw', isa=>'OSM::API::Box');
has 'open' => (is=>'rw', isa=>'Bool');

#use MooseX::Types::DateTime qw(TimeZone);
use MooseX::Types::DateTimeX qw( DateTime );


has 'created_at' => (is=>'rw', isa=>'String');
#"2008-11-08T19:07:39+01:00"

has 'userObj' => (is=>'rw', isa=>'OSM::API::User');
has 'id' => (is=>'rw', isa=>'Int');

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

1;
