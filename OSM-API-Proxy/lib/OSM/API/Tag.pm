package OSM::API::Tag;

use Moose;
use Moose::Util::TypeConstraints;
#use MooseX::SemiAffordanceAccessor;

has 'k' => (is=>'rw', isa=>'Str');
has 'v' => (is=>'rw', isa=>'Str');


1;
