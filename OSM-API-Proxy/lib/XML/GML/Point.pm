package XML::GML::Point;
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
    warn "check :\"$chars\"";
}

sub set_pos
{
    my $self=shift;
    my $pos=shift;
    $self->{pos}=$pos;
}
1;
