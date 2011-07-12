package OSM::API::Tags;
use OSM::API::Tag;

use Moose;
use Moose::Util::TypeConstraints;

has 'Tags' => (
    is=>'rw', 
    isa=>'ArrayRef'
);

# schema
has 'Ontology' => (
    is=>'rw', 
    isa=>'ArrayRef'
);

# ontology

1;
