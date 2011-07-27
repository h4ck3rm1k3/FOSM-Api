package OSM::API::OsmFile::Language;
use Moose::Role;
#sub xmlns { "http://osmopenlayers.blogspot.com/2011/07/fosm-fake-osm-api.html" }
sub xmlns {   }
sub root_element { "osm" }
with 'PRANG::Graph';
#$class->meta->does_role("PRANG::Graph::Meta::Class");

1;

package OSM::API::OsmFile::Bounds;
use Moose;
use PRANG::Graph;
use PRANG::XMLSchema::Types;

sub root_element { "bounds" };

has_attr 'minlat' =>
    is => "rw",
    isa => "Num",
    ;

has_attr 'maxlat' =>
    is => "rw",
    isa => "Num",
    ;

has_attr 'origin' =>
    is => "rw",
    isa => "Str",
    ;

has_attr 'minlon' =>
    is => "rw",
    isa => "Num",
    ;

has_attr 'maxlon' =>
    is => "rw",
    isa => "Num",
    ;

1;


package OSM::API::OsmFile;
use Moose;
use PRANG::Graph;
use YAML;
use Data::Dumper;
sub root_element {
    'osm'
};

has_attr 'version' =>
    is => "rw",
    isa => "Str",
    ;

has_attr 'generator' =>
    is => "rw",
    isa => "Str",
    ;

has_element 'bounds' =>
    is => "ro",
    required=> 0,
    isa => "OSM::API::OsmFile::Bounds";

has_element 'node' =>
    is => "ro",
    required=> 0,
    isa => "ArrayRef[OSM::API::OsmFile::Node]",
    xml_nodeName => {
	'node' => 'OSM::API::OsmFile::Node',
	'way' => 'OSM::API::OsmFile::Way',
	'relation' => 'OSM::API::OsmFile::Relation',
};

has_element 'way' =>
    is => "ro",
    required=> 0,
    isa => "ArrayRef[OSM::API::OsmFile::Way]",
    xml_nodeName => {
	'way' => 'OSM::API::OsmFile::Way',

};

has_element 'relation' =>
    is => "ro",
    required=> 0,
    isa => "ArrayRef[OSM::API::OsmFile::Relation]",
    xml_nodeName => {
	'relation' => 'OSM::API::OsmFile::Relation',
};


sub ProcessUsersUpload
{
    my $self=shift;
    warn "In OSM::API::OsmFile";
#    warn Dump($self);
	$Data::Dumper::Maxdepth=2;

    # process the actions
    $self->{"actions"}->[0]->ProcessUsersUpload();

    # version
    # generator at the root of the changeset.

}

with 'PRANG::Graph', 'OSM::API::OsmFile::Language';

1;


package OSM::API::OsmFile::Create;
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
    isa => "ArrayRef[OSM::API::OsmFile::Node|OSM::API::OsmFile::Way|OSM::API::OsmFile::Relation]",
    xml_nodeName => {
	'node' => 'OSM::API::OsmFile::Node',
	'way' => 'OSM::API::OsmFile::Way',
	'relation' => 'OSM::API::OsmFile::Relation',
};


1;

package OSM::API::OsmFile::Modify;
use Moose;
use PRANG::Graph;
use PRANG::XMLSchema::Types;
use Data::Dumper;
use YAML;
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
    isa => "ArrayRef[OSM::API::OsmFile::Node|OSM::API::OsmFile::Way|OSM::API::OsmFile::Relation]",
    xml_nodeName => {
	'node' => 'OSM::API::OsmFile::Node',
	'way' => 'OSM::API::OsmFile::Way',
	'relation' => 'OSM::API::OsmFile::Relation',
};


sub ProcessUsersUpload
{
    my $self=shift;
    warn "In OSM::API::OsmFile::Modify";
#    warn Dump($self);
	$Data::Dumper::Maxdepth=2;
    foreach my $c (keys %$self)
    {
#	warn $c;

#	warn Dumper($self->{$c});
	$self->{$c}->[0]->ProcessUsersUploadModify(); # call a different method
    }

  #   nodes:
  #     - !!perl/hash:OSM::API::OsmFile::Way
  #       changeset: 2524642
  #       id: 11175590
  #       nd:
  #         - !!perl/hash:OSM::API::OsmFile::NodeRef
  #           ref: 99463527

}

#with 'OSM::API::OsmFile::Root';

1;

package OSM::API::OsmFile::Node;
use Moose;
use PRANG::Graph;
use PRANG::XMLSchema::Types;
#with 'OSM::API::OsmFile::Modify';
use MooseX::Types::DateTimeX qw( DateTime );
use Geo::Hash;
my $gh = Geo::Hash->new;

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

 has_attr 'hash' =>
     is => "rw",
     isa => "Str", #true
#     expected =>0,
     xml_required => 0,
    ;

has_element 'tags' =>
    is => "ro",
    xml_required => 0,
    isa => "ArrayRef[OSM::API::OsmFile::Tag]",
    xml_nodeName => {
	'tag' => 'OSM::API::OsmFile::Tag',

};

sub Hash
{
    my $self=shift;
    my $hash = $gh->encode( $self->lat, $self->lon );
    $self->hash($hash);
    warn $self->lat . ",".  $self->lon . " " . $self->hash;
}
sub ProcessUsersUpload
{
    my $self=shift;
    $self->Hash();
}
sub ProcessUsersUploadModify
{
    my $self=shift;
    $self->Hash();
}

1;

package OSM::API::OsmFile::Tag;
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

package OSM::API::OsmFile::NodeRef;
use Moose;
use PRANG::Graph;
use PRANG::XMLSchema::Types;

has_attr 'ref' =>
    is => "rw",
    isa => "Str",
    ;

#$node->ProcessUsersUploadModify();

1;

package OSM::API::OsmFile::Way;
use Moose;
use PRANG::Graph;
use PRANG::XMLSchema::Types;
use Data::Dumper;
use YAML;
use Dancer::Plugin::DBIC qw(schema);
#with 'OSM::API::OsmFile::Modify';
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

has_attr 'visible' =>
    is => "rw",
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
    isa => "ArrayRef[OSM::API::OsmFile::NodeRef]",
    xml_nodeName => {
	'nd' => 'OSM::API::OsmFile::NodeRef'};

has_element 'tags' =>
    is => "ro",
    xml_required => 0,
    isa => "ArrayRef[OSM::API::OsmFile::Tag]",
    xml_nodeName => {
	'tag' => 'OSM::API::OsmFile::Tag'};


sub ProcessUsersUploadModify
{
    my $self=shift;
    warn "In osmchange modify way";
#    warn Dump($self);
    $Data::Dumper::Maxdepth=2;

# nodes at lib//OSM/API/OsmChange.pm line 181.
# $VAR1 = [
#           bless( {
#                    'changeset' => '2524642',
#                    'timestamp' => '2009-09-18T14:49:39Z',
#                    'uid' => '174494',
#                    'version' => '2',
#                    'nd' => 'ARRAY(0xa686040)',
#                    'user' => 'dimenso',
#                    'id' => '11175590',
#                    'tags' => 'ARRAY(0xa685a80)'
#                  }, 'OSM::API::OsmFile::Way' ),

    if ($self->{"nd"})
    {
	my $nodeslist = $self->{"nd"};
	my @nodes = @$nodeslist;
#	warn Dumper(\@nodes);
	foreach my $node (@nodes)
	{
#\	    $node->ProcessUsersUploadModify();
	    my $id = $node->ref();
	    # lets lookup the node in the database
	    my $node = schema("osm")->resultset('Node')->find( { id => $id });

	    # look up the node in the XML memory ?

	}
    }


    if ($self->{"tags"})
    {
	my $nodeslist = $self->{"tags"};
	my @nodes = @$nodeslist;
#	warn Dumper(\@nodes);
	foreach my $tag (@nodes)
	{
#	    $node->ProcessUsersUploadModify();
#	    warn Dump($tag);
	}
    }
# changeset at lib//OSM/API/OsmChange.pm line 406.
# timestamp at lib//OSM/API/OsmChange.pm line 406.
# uid at lib//OSM/API/OsmChange.pm line 406.
# version at lib//OSM/API/OsmChange.pm line 406.
# nd at lib//OSM/API/OsmChange.pm line 406.
# user at lib//OSM/API/OsmChange.pm line 406.
# id at lib//OSM/API/OsmChange.pm line 406.
# tags at lib//OSM/API/OsmChange.pm line 406.

#    foreach my $c (keys %$self)
 #   {
#	warn $c;
#	warn Dump($self->{$c});
#	warn Dumper($self->{$c});
	#$self->{$c}->[0]->ProcessUsersUploadModify();
#    }
}


1;

package OSM::API::OsmFile::Relation;
use Moose;
use PRANG::Graph;
use PRANG::XMLSchema::Types;
#with 'OSM::API::OsmFile::Modify';
# version="1" timestamp="2009-09-18T14:49:32Z" uid="71261" user="David Paleino" changeset="2524643"
has_attr 'id' =>
    is => "rw",
    isa => "Str",
    ;


has_attr 'visible' =>
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
    isa => "ArrayRef[OSM::API::OsmFile::Relation::Member]",
    xml_nodeName => {
	'member' => 'OSM::API::OsmFile::Relation::Member'};

has_element 'tags' =>
    is => "ro",
    xml_required => 0,
    isa => "ArrayRef[OSM::API::OsmFile::Tag]",
    xml_nodeName => {
	'tag' => 'OSM::API::OsmFile::Tag'};

1;

package OSM::API::OsmFile::Relation::Member;
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
    my $obj = OSM::API::OsmFile->parse($content);

#    warn Dump($obj);
#    warn "as xml" . Dump($obj->to_xml(1));
    $obj;
}


sub ProcessUsersUpload
{
    my $self=shift;
#    warn "In osmchange base";
#    warn Dump($self);
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
