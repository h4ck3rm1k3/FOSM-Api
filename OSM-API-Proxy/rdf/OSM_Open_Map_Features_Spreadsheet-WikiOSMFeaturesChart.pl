#"Text"	"Text"	"Text"	"Entity Attribute"	"Entity Attribute"	"Text"	"OSM ? Wiki"	"OSM ? Wiki"	"Geometry (element)"	"Text"	"Text"	"Text"	"Reference"	"TagInfo link"	"Rendering Sample"	"Rendering Sample"	"Rendering Sample"	"Rendering Sample"	"Sample"	"www.openstreetmap.org"	"GoogleDocs Spreadsheet" "Theme Code"	"Group"	"Sub-Group (from Map Features Chart)"	"Key"	"Value(s) (list)"	"Comment (from Map Features Chart)"	"Definition (1st paragraph of article)"	"Description (short sentence in green box on the right)"	"node"	"Way"	"Area"	"Relation"	"URL"		"node"	"way"	"area"	"relation"	"Photo"	"sample feature"	"User Notes"
#"Theme Code"	"Group"	"Sub-Group (from Map Features Chart)"	"Key"	"Value(s) (list)"	"Comment (from Map Features Chart)"	"Definition (1st paragraph of article)"	"Description (short sentence in green box on the right)"	"node"	"Way"	"Area"	"Relation"	"URL"		"node"	"way"	"area"	"relation"	"Photo"	"sample feature"	"User Notes"

use Text::CSV_XS;
use YAML;

use RDF::Helper;
use strict;
use warnings;
use YAML;
use RDF::Helper::Constants qw(RDF_TYPE RDFS_SUBCLASS_OF);
use constant OWL_NS => "http://www.w3.org/2002/07/owl#";
use constant OWL_CLASS =>  OWL_NS. "Class";

# owl:AllDifferent 	
# owl:allValuesFrom 	
# owl:AnnotationProperty 	
# owl:backwardCompatibleWith 	
# owl:cardinality 	
# owl:Class 	
# owl:complementOf 
# owl:DataRange 	
# owl:DatatypeProperty 	
# owl:DeprecatedClass 	
# owl:DeprecatedProperty 	
# owl:differentFrom 	
# owl:disjointWith 	
# owl:distinctMembers 	
# owl:equivalentClass 	
# owl:equivalentProperty 	
# owl:FunctionalProperty 	
# owl:hasValue 	
# owl:imports 	
# owl:incompatibleWith 	
# owl:intersectionOf 	
# owl:InverseFunctionalProperty
# owl:inverseOf 	
# owl:maxCardinality
# owl:minCardinality
# owl:Nothing 	
# owl:ObjectProperty
# owl:oneOf 	
# owl:onProperty 	
# owl:Ontology 	
# owl:OntologyProperty
# owl:priorVersion
# owl:Restriction 
# owl:sameAs 	
# owl:someValuesFrom 
# owl:SymmetricProperty
# owl:Thing 	
# owl:TransitiveProperty
# owl:unionOf 	
# owl:versionInfo


use constant LGD_NS => "http://linkedgeodata.org/vocabulary#";
use constant LGD_VAL_NS => "http://linkedgeodata.org/vocabulary/values#";
use constant OSM_NS => "http://osmopenlayers.blogspot.com/2011/08/osm-ontology.html#";

my $rdf = RDF::Helper->new(
    BaseInterface => 'RDF::Trine',
    ExpandQNames => 1,
    namespaces => {
	dct => 'http://purl.org/dc/terms/',
	rdf => "http://www.w3.org/1999/02/22-rdf-syntax-ns#",	
	owl => OWL_NS,
	lgd => LGD_NS,
	lgdv => LGD_VAL_NS,
	osm => OSM_NS,
	xsd =>  "http://www.w3.org/2001/XMLSchema#" ,
	rdfs => "http://www.w3.org/2000/01/rdf-schema#",
	'#default' => "http://purl.org/rss/1.0/",
     }
  );

my $uri = "";
#my $res = $rdf->new_resource($uri)




my @rows;
my $csv = Text::CSV_XS->new (
    { binary => 1 ,
      sep_char => "\t",
} 
    )  # should set binary attribute.
    or die "Cannot use CSV: ".Text::CSV->error_diag ();

open my $fh, "<", "OSM_Open_Map_Features_Spreadsheet-Wiki OSM Features Chart-1.csv" or die "cannot open: $!";

warn "open";


while ( my $row = $csv->getline( $fh ) ) {
    my $rowo = {
	 	"Theme Code" => $rdf->new_literal($row->[0]),
	 	"Group"	     => $rdf->new_literal($row->[1]),
	 	"Sub-Group"  => $rdf->new_literal($row->[2]),
	# 	"Key"	     => $rdf->new_literal($row->[3]),
	# 	"Values"      => $rdf->new_literal($row->[4]),
		"Comment "	 => $rdf->new_literal($row->[5]),
		"Definition"	 => $rdf->new_literal($row->[6]),
		"Description"	 => $rdf->new_literal($row->[7]),
	 	"node"	 => $rdf->new_literal($row->[8]),
	 	"Way"	 => $rdf->new_literal($row->[9]),
	 	"Area"	 => $rdf->new_literal($row->[10]),
		"Relation" => $rdf->new_literal($row->[11]),
		"URL"	 => $rdf->new_resource($row->[12]),
		"TagInfo"	 => $rdf->new_resource($row->[13]),
		"Rendering_node" => $rdf->new_resource($row->[14]),
		"Rendering_way" => $rdf->new_resource($row->[15]),
		"Rendering_area"	 => $rdf->new_resource($row->[16]),
		"Rendering_relation" => $rdf->new_resource($row->[17]),
		"Photo"  => $rdf->new_resource($row->[18]),
		"sample feature" => $rdf->new_resource($row->[19]),
		"UserNotes" => $rdf->new_literal($row->[20]),
    };

    next unless $row->[3];
    next unless $row->[4];

    my $subject = LGD_NS . $row->[3] ;
#    my $predicate = "rdfs:comment";
#    my $object = ;
 
# description
#   $rdf->assert_literal($subject, $predicate, $object);

    my $val_subject = LGD_VAL_NS . $row->[3]. "_".  $row->[4] ;
    my $val_predicate = RDFS_SUBCLASS_OF;


    my $rdf_type= RDF_TYPE;
    my $owl_class= OWL_CLASS;
    $rdf->assert_resource($subject    , $rdf_type, $owl_class );
    $rdf->assert_resource($val_subject, $rdf_type, $owl_class );
    $rdf->assert_resource($val_subject, $val_predicate, $subject);

#    my $subject = "lgd:" . $row->[3] ;
#    my $predicate = "rdfs:comment";
#    my $object = $rowo->{"Description"};
    foreach my $k (keys(%{$rowo}))
    {
	$rdf->assert_literal($val_subject, OSM_NS . $k , $rowo->{$k}); # description
    }
    
    # if ($row->[0])
    # {
    # 	$rdf->assert_literal($val_subject, OSM_NS . "ThemeCode",$row->[0]);
    # }

    # if ($row->[1])
    # {
    # 	$rdf->assert_literal($val_subject, OSM_NS .  "Group",$row->[1]);
    # }
    # if ($row->[2])
    # {
    # 	$rdf->assert_literal($val_subject, OSM_NS .  "SubGroup",$row->[2]);
    # }

#	"Theme Code" => $rdf->new_literal($row->[0]),
#	"Group"	     => $rdf->new_literal($row->[1]),
#	"Sub-Group"  => $rdf->new_literal($row->[2]),


 #   warn Dump(	$rowo	      )	;
    
#     $row->[2] =~ m/pattern/ or next; # 3rd field should match
#    exit 1;
#    push @rows, $rowo;
}
$csv->eof or $csv->error_diag();
close $fh;

#warn Dump(\@rows);

print $rdf->serialize();
