package OSM::API::Point;
use Moose;
use Moose::Util::TypeConstraints;
use namespace::clean; # see http://www.perlmonks.org/?node_id=882225
use MooseX::Types::Moose qw( Num Int Str );
# TODO inherit from the base class to assign ids etc...

has 'lat' => (is=>'rw', isa=>'Num', default=>'0.0');
has 'lon' => (is=>'rw', isa=>'Num', default=>'0.0');
has 'tags' => (is=>'rw', isa=>'OSM::API::Tags'); # TODO pull up into base class

sub emit_OSM
{
    # TODO 
}

1;
