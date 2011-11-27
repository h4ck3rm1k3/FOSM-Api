package XML::GML::Point::pos;

#
sub new
{
    my $class=shift;
    my $attribs=$shift; # from xml parser..
    my $self = {};
    return bless $self,$class;
}

sub handle_char
{
    my $self=shift;
    my $chars =shift;
#    warn "check :\"$chars\"";
    my ($lat,$lon)= $chars=~ /([\-\.\d]+)\s([\-\.\d]+)/;
    $self->{lat}=$lat;
    $self->{lon}=$lon;
}

sub create_OSM
{
    my $self=shift;
    if ($self->{lat})
    {
	return OSM::API::Point->new(lat=>$self->{lat},lon=>$self->{lon} );
    }
    else
    {
	warn "no data";
	return undef;
    }
}


1;
