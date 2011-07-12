package OSM::API::Point;
use Moose;
use Moose::Util::TypeConstraints;
use namespace::clean; # see http://www.perlmonks.org/?node_id=882225
use MooseX::Types::Moose qw( Num Int Str );


has 'lat' => (is=>'rw', isa=>'Num', default=>'0.0');
has 'lon' => (is=>'rw', isa=>'Num', default=>'0.0');

1;
