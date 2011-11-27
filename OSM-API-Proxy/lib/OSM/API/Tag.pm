package OSM::API::Tag;

use Moose;
use Moose::Util::TypeConstraints;
#use MooseX::SemiAffordanceAccessor;

has 'k' => (is=>'rw', isa=>'String');
has 'v' => (is=>'rw', isa=>'String');


1;
