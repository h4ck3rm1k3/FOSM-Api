package OSM::API::Point;
use Moose;
use Moose::Util::TypeConstraints;
use namespace::clean; # see http://www.perlmonks.org/?node_id=882225
use MooseX::Types::Moose qw( Num Int Str );
# TODO inherit from the base class to assign ids etc...

has 'id' => (is=>'rw', isa=>'Num', default=>'0');
has 'lat' => (is=>'rw', isa=>'Num', default=>'0.0');
has 'lon' => (is=>'rw', isa=>'Num', default=>'0.0');
has 'tags' => (is=>'rw', isa=>'OSM::API::Tags'); # TODO pull up into base class

my $next_id=-1;


sub emit_OSM
{
    my $self=shift;
    # TODO 
    if ($self->{id}==0)
    {
	$self->{id}=$next_id--;
    }

    print "<node " .
	" id='", $self->{id}   . "'" .
	" lat='", $self->{lat} . "'" .
	" lon='", $self->{lon} . "'" .
	" >";

    $self->{tags}->emit_OSM();

    print "</node>";
}

1;
