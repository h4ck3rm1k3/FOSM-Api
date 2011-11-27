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


1;
