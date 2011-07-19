package OSM::API::OsmChange::Language;
use Moose::Role;
#sub xmlns { "http://osmopenlayers.blogspot.com/2011/07/fosm-fake-osm-api.html" }
sub xmlns {   }
sub root_element { "osmChange" }
with 'PRANG::Graph';
#$class->meta->does_role("PRANG::Graph::Meta::Class");

1;

package OSM::API::OsmChange::Delete;
use Moose;
use PRANG::Graph;
use PRANG::XMLSchema::Types;

has_attr 'version' =>
    is => "rw",
    isa => "Str",
    ;

has_attr 'generator' =>
    is => "rw",
    isa => "Str",
    ;

has_element 'nodes' =>
    is => "ro",
    required=> 1,
    isa => "ArrayRef[OSM::API::OsmChange::Node|OSM::API::OsmChange::Way|OSM::API::OsmChange::Relation]",
    xml_nodeName => {
	'node' => 'OSM::API::OsmChange::Node',
	'way' => 'OSM::API::OsmChange::Way',
	'relation' => 'OSM::API::OsmChange::Relation',
};

1;


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

has_element 'actions' =>
    is => "ro",
    required=> 1,
    isa => "ArrayRef[OSM::API::OsmChange::Modify|OSM::API::OsmChange::Create|OSM::API::OsmChange::Delete]", 
    xml_nodeName => {
	'create' => 'OSM::API::OsmChange::Create',
	'delete' => 'OSM::API::OsmChange::Delete',
	'modify' => 'OSM::API::OsmChange::Modify',
};



with 'PRANG::Graph', 'OSM::API::OsmChange::Language';

1;


package OSM::API::OsmChange::Create;
use Moose;
use PRANG::Graph;
use PRANG::XMLSchema::Types;

has_attr 'version' =>
    is => "rw",
    isa => "Str",
    ;

has_attr 'generator' =>
    is => "rw",
    isa => "Str",
    ;

has_element 'nodes' =>
    is => "ro",
    required=> 1,
    isa => "ArrayRef[OSM::API::OsmChange::Node|OSM::API::OsmChange::Way|OSM::API::OsmChange::Relation]",
    xml_nodeName => {
	'node' => 'OSM::API::OsmChange::Node',
	'way' => 'OSM::API::OsmChange::Way',
	'relation' => 'OSM::API::OsmChange::Relation',
};


1;

package OSM::API::OsmChange::Modify;
use Moose;
use PRANG::Graph;
use PRANG::XMLSchema::Types;

has_attr 'version' =>
    is => "rw",
    isa => "Str",
    ;

has_attr 'generator' =>
    is => "rw",
    isa => "Str",
    ;

has_element 'nodes' =>
    is => "ro",
    required=> 1,
    isa => "ArrayRef[OSM::API::OsmChange::Node|OSM::API::OsmChange::Way|OSM::API::OsmChange::Relation]",
    xml_nodeName => {
	'node' => 'OSM::API::OsmChange::Node',
	'way' => 'OSM::API::OsmChange::Way',
	'relation' => 'OSM::API::OsmChange::Relation',
};

#with 'OSM::API::OsmChange::Root';

1;

package OSM::API::OsmChange::Node;
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

#Tag

has_element 'tags' =>
    is => "ro",
#    expected =>0,
#    required=> 0,
    xml_required => 0,
    isa => "ArrayRef[OSM::API::OsmChange::Tag]",
    xml_nodeName => {
	'tag' => 'OSM::API::OsmChange::Tag',

};

1;

package OSM::API::OsmChange::Tag;
use Moose;
use PRANG::Graph;
use PRANG::XMLSchema::Types;

has_attr 'k' =>
    is => "rw",
    isa => "Str",
    ;

has_attr 'v' =>
    is => "rw",
    isa => "Str",
    ;

1;

1;

package OSM::API::OsmChange::NodeRef;
use Moose;
use PRANG::Graph;
use PRANG::XMLSchema::Types;

has_attr 'ref' =>
    is => "rw",
    isa => "Str",
    ;

1;

package OSM::API::OsmChange::Way;
use Moose;
use PRANG::Graph;
use PRANG::XMLSchema::Types;
#with 'OSM::API::OsmChange::Modify';
has_attr 'id' =>
    is => "rw",
    isa => "Str",
    ;
#id="11205031"
# version="2"
# timestamp="2009-09-18T14:49:48Z"
# uid="174494"
# user="dimenso"
# changeset="2524642"


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

has_attr 'version' =>
    is => "rw",
    isa => "Int", #true
    ;

has_attr 'changeset' =>
    is => "rw",
    isa => "Int", #true
    ;

has_element 'nd' =>
    is => "ro",
    xml_required => 0,
    isa => "ArrayRef[OSM::API::OsmChange::NodeRef]",
    xml_nodeName => {
	'nd' => 'OSM::API::OsmChange::NodeRef'};

has_element 'tags' =>
    is => "ro",
    xml_required => 0,
    isa => "ArrayRef[OSM::API::OsmChange::Tag]",
    xml_nodeName => {
	'tag' => 'OSM::API::OsmChange::Tag'};

1;

package OSM::API::OsmChange::Relation;
use Moose;
use PRANG::Graph;
use PRANG::XMLSchema::Types;
#with 'OSM::API::OsmChange::Modify';
# version="1" timestamp="2009-09-18T14:49:32Z" uid="71261" user="David Paleino" changeset="2524643"
has_attr 'id' =>
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

has_attr 'version' =>
    is => "rw",
    isa => "Int", #true
    ;

has_attr 'changeset' =>
    is => "rw",
    isa => "Int", #true
    ;


has_element 'members' =>
    is => "ro",
    xml_required => 0,
    isa => "ArrayRef[OSM::API::OsmChange::Relation::Member]",
    xml_nodeName => {
	'member' => 'OSM::API::OsmChange::Relation::Member'};

has_element 'tags' =>
    is => "ro",
    xml_required => 0,
    isa => "ArrayRef[OSM::API::OsmChange::Tag]",
    xml_nodeName => {
	'tag' => 'OSM::API::OsmChange::Tag'};

1;

package OSM::API::OsmChange::Relation::Member;
use Moose;
use PRANG::Graph;
use PRANG::XMLSchema::Types;

has_attr 'type' =>
    is => "rw",
    isa => "Str",
    ;

has_attr 'role' =>
    is => "rw",
    isa => "Str",
    ;

has_attr 'ref' =>
    is => "rw",
    isa => "Int",
    ;

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
#    warn "going to parse $content";
    my $obj = OSM::API::OsmChange::Root->parse($content);

#    warn Dump($obj);
    warn "as xml" . Dump($obj->to_xml(1));
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
