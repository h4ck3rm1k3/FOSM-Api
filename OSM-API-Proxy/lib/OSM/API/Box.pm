package OSM::API::Box;
use OSM::API::Point;
use Moose;
use Moose::Util::TypeConstraints;
has 'min' => (is=>'rw', isa=>'OSM::API::Proxy::Point');
has 'max' => (is=>'rw', isa=>'OSM::API::Proxy::Point');

sub left
{
    my $self=shift;
    return $self->get_min()->get_lon();
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
