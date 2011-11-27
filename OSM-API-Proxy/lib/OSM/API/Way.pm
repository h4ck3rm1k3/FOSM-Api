package OSM::API::Way;
use Moose;
use Moose::Util::TypeConstraints;
use namespace::clean; # see http://www.perlmonks.org/?node_id=882225
use MooseX::Types::Moose qw( Num Int Str );

has 'points' => (is=>'rw', isa=>'ArrayRef[OSM::API::Point]');
has 'tags' => (is=>'rw', isa=>'OSM::API::Tags');


1;
