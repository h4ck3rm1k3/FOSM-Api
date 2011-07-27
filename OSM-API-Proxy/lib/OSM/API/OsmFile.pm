package OSM::API::OsmFile;
#use Moose;
#use PRANG::Graph;
#use YAML;
#use Data::Dumper;
use Moose::Role; # this is a multiple root document, http://search.cpan.org/~mutant/PRANG-0.14/lib/PRANG/Graph.pm PRANG::Graph for multi-root document types
sub xmlns {   }

# has_attr 'version' =>
#     is => "rw",
#     isa => "Str",
#     ;
# has_attr 'generator' =>
#     is => "rw",
#     isa => "Str",
#     ;
# has_element 'bounds' =>
#     is => "ro",
# #    required=> 0,
#     isa => "OSM::API::OsmFile::Bounds";
# has_element 'node' =>
#     is => "ro",
#  #   required=> 1,
#     isa => "ArrayRef[OSM::API::OsmFile::Node|OSM::API::OsmFile::Way|OSM::API::OsmFile::Relation]",
#     xml_nodeName => {
# 	'node' => 'OSM::API::OsmFile::Node',
# 	'way' => 'OSM::API::OsmFile::Way',
# 	'relation' => 'OSM::API::OsmFile::Relation',
# };
# sub ProcessHistory
# {
#     my $self=shift;
#     warn "In OSM::API::OsmFile";
# #    warn Dump($self);
# 	$Data::Dumper::Maxdepth=2;
#     # process the actions
#     $self->{"actions"}->[0]->ProcessUsersUpload();
#     # version
#     # generator at the root of the changeset.
# }

with 'PRANG::Graph';

1;


package OSM::API::OsmFile::OSM;
use Moose;
use PRANG::Graph;
use YAML;
use Data::Dumper;

sub xmlns {   }
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
#    required=> 0,
    isa => "OSM::API::OsmFile::Bounds";

has_element 'node' =>
    is => "ro",
 #   required=> 1,
    isa => "ArrayRef[OSM::API::OsmFile::Node|OSM::API::OsmFile::Way|OSM::API::OsmFile::Relation]",
    xml_nodeName => {
	'node' => 'OSM::API::OsmFile::Node',
	'way' => 'OSM::API::OsmFile::Way',
	'relation' => 'OSM::API::OsmFile::Relation',
};


sub ProcessHistory
{
    my $self=shift;
    warn "In OSM::API::OsmFile";
#    warn Dump($self);
    $Data::Dumper::Maxdepth=2;
    warn Dumper($self);
    # process the actions
    $self->{"node"}->[0]->ProcessHistory();
    
    # version
    # generator at the root of the changeset.

}

with 'OSM::API::OsmFile';

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

package OSM::API::OsmFile::Node;
use Moose;
use PRANG::Graph;
use PRANG::XMLSchema::Types;
#with 'OSM::API::OsmFile::Modify';
sub root_element {
    'node'
};

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

sub ProcessHistory
{
    my $self=shift;
    $self->Hash();
}

with 'OSM::API::OsmFile';
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

sub root_element {
    'way'
};

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

sub root_element {
    'relation'
};

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




