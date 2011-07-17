package OSM::API::OsmChange::Language;
use Moose::Role;
sub xmlns { "http://osmopenlayers.blogspot.com/2011/07/fosm-fake-osm-api.html" }
#with 'PRANG::Graph::Class';
#$class->meta->does_role("PRANG::Graph::Meta::Class");

1;

# <osmChange version="0.6" generator="JOSM">
# <modify>
#   <node id='1287731165' action='modify' timestamp='2011-05-16T14:56:18Z' uid='355102' user='BesfortGuri/Besfort Guri/BesfortGuri/Besfort Guri/Besfort Guri/BesfortGuri' visible='true' version='2' changeset='1000001384' lat='42.61893168122738' lon='20.57614856619908' />
# </modify>
# </osmChange>

package OSM::API::OsmChange::Root;
use Moose;
use PRANG::Graph;
sub root_element {
    'osmChange'
};

has_attr 'version' =>
    is => "rw",
    isa => "Str",
    ;

has_attr 'generator' =>
    is => "rw",
    isa => "Str",
    ;

has_element 'modify' =>
    is => "ro",
    required=> 1,
    isa => "OSM::API::OsmChange::Modify", ;


with 'PRANG::Graph', 'OSM::API::OsmChange::Language';

1;

package OSM::API::OsmChange::Modify;
use Moose;
use PRANG::Graph;
use PRANG::XMLSchema::Types;

has_element 'nodes' =>
    is => "ro",
    required=> 1,
    isa => "ArrayRef[OSM::API::OsmChange::Modify::Node|OSM::API::OsmChange::Modify::Way|OSM::API::OsmChange::Modify::Relation]",
    xml_nodeName => {
	'node' => 'OSM::API::OsmChange::Modify::Node',
	'way' => 'OSM::API::OsmChange::Modify::Way',
	'relation' => 'OSM::API::OsmChange::Modify::Relation',
};

#with 'OSM::API::OsmChange::Root';

1;

package OSM::API::OsmChange::Modify::Node;
use Moose;
use PRANG::Graph;
use PRANG::XMLSchema::Types;
#with 'OSM::API::OsmChange::Modify';
use MooseX::Types::DateTimeX qw( DateTime );

has_attr 'id' =>
    is => "rw",
    isa => "Str",
    ;

has_attr 'action' =>
    is => "rw",
    isa => "Str",
    ;

has_attr 'timestamp' =>
    is => "rw",
#    isa => "DateTime",
    isa => "Str",
    ;
has_attr 'uid' =>
    is => "rw",
    isa => "Int",
    ;

has_attr 'user' =>
    is => "rw",
    isa => "Str",
    ;

has_attr 'visible' =>
    is => "rw",
    isa => "Str", #true
    ;

has_attr 'version' =>
    is => "rw",
    isa => "Int", #true
    ;

has_attr 'changeset' =>
    is => "rw",
    isa => "Int", #true
    ;

has_attr 'lat' =>
    is => "rw",
    isa => "Num", #true
    ;

has_attr 'lon' =>
    is => "rw",
    isa => "Num", #true
    ;

1;

package OSM::API::OsmChange::Modify::Way;
use Moose;
use PRANG::Graph;
use PRANG::XMLSchema::Types;
#with 'OSM::API::OsmChange::Modify';
1;

package OSM::API::OsmChange::Modify::Relation;
use Moose;
use PRANG::Graph;
use PRANG::XMLSchema::Types;
#with 'OSM::API::OsmChange::Modify';
1;

package OSM::API::OsmChange;
use YAML;
use OSM::API::Box;
use OSM::API::User;
use OSM::API::Tags;
use Moose;
use Moose::Util::TypeConstraints;
use OSM::API::RemoteServerAgent;

use Moose;
#use MooseX::DOM;


#
sub parse
{
    my $self=shift;
    my $content=shift;
    warn "going to parse $content";
    my $obj = OSM::API::OsmChange::Root->parse($content);

    warn Dump($obj);
    $obj;
}


=head2 Response

If a diff is successfully applied a XML (content type C<text/xml>) is
returned in the following format

 <diffResult generator="OpenStreetMap Server" version="0.6">
   <node|way|relation old_id="#" new_id="#" new_version="#"/>
   ...
 </diffResult>

with one element for every element in the upload. Note that this can be
counter-intuitive when the same element has appeared multiple times in
the input then it will appear multiple times in the output.
=cut

1;
