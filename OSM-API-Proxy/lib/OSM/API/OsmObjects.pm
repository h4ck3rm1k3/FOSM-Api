package OSM::API::OsmObjects::Global;
use Geo::HashInline;
use Geo::Hash;
use strict;
use warnings;
use File::Path qw(make_path remove_tree);
use YAML;
#global instance of the geohash to be reused
our $gh = Geo::Hash->new; # used only for decode for now
#_Geo__HashInline_encodestr

sub encode
{
    #OSM::API::OsmObjects::Global::gh->encode
    my $x=shift;
    my $y=shift;
    return Geo::HashInline::encodestr($x,$y);
}
1;

package OSM::API::OsmObjects::Base;
use strict;
use warnings;
use File::Path qw(make_path remove_tree);
use YAML;

our @fields =     qw[
id
uid
user
];
#my $report = $self->{id} . " v".  $self->{version} . " c". $self->{changeset} . ": " .

sub BasicInfoStr
{
    my $self=shift;
    my $object_report=shift;
    my $partno = $self->{partno};
    return "p:$partno " . $object_report . "\n";
}

1;

package OSM::API::OsmObjects::BaseGeo;
use strict;
use warnings;
use File::Path qw(make_path remove_tree);
use YAML;

our @fields = 
    qw[
changeset
version
hash
];

sub BasicInfoStr
{
    my $self=shift;
    my $object_report=shift;
    my $id =$self->{id} || -9999999;
    my $changeset =$self->{changeset} || -9999998;
    my $version =$self->{version} || -9999998;
    my  $report = " id:$id version:$version cs:$changeset : " . $object_report;
    
    $self->SUPER::BasicInfoStr($report);
}

our @ISA = qw[OSM::API::OsmObjects::Base];

#my $report = $self->{id} . " v".  $self->{version} . " c". $self->{changeset} . ": " .

1;

package OSM::API::OsmObjects::ChangeSet;
use strict;
use warnings;
use YAML;
use File::Path qw(make_path remove_tree);

our @ISA = qw[OSM::API::OsmObjects::Base];
our @fields = 
    qw[
closed_at
created_at
id
max_lat
max_lon
min_lat
min_lon
open
uid
user];
sub new 
{
    my $class=shift;
    my $self =shift;
#    $self->{tags}=    $self->{tags}={} ||{}; # create an empty hash of the tags
    return bless $self,$class;
}

# report fiel
BEGIN
{
    open RPT, ">data/debugreport.txt";
}

END
{
    close RPT;
}


sub Hash
{
    my $self=shift;
    if ($self->{min_lat})
    {
#    warn "no bounds" unless $self->{min_lat};
	warn "no bounds" unless $self->{min_lon};
	warn "no bounds" unless $self->{max_lat};
	warn "no bounds" unless $self->{max_lon};

	my $min_hash = OSM::API::OsmObjects::Global::encode( $self->{min_lat}, $self->{min_lon} );
	my $max_hash = OSM::API::OsmObjects::Global::encode( $self->{max_lat}, $self->{max_lon} );

	my $min_hash2 = OSM::API::OsmObjects::Global::encode( $self->{min_lat}, $self->{max_lon} );
	my $max_hash2 = OSM::API::OsmObjects::Global::encode( $self->{max_lat}, $self->{min_lon} );

	# now we look for the common prefix
	my @min_path = split (//, $min_hash);
	my @max_path = split (//, $max_hash);

	my @min_path2 = split (//, $min_hash2);
	my @max_path2 = split (//, $max_hash2);
	my $hash = "";

	my $minlen = scalar(@min_path) -1;
	my $maxlen = scalar(@max_path) -1;

	my $minlen2 = scalar(@min_path2) -1;
	my $maxlen2 = scalar(@max_path2) -1;

	if ($minlen < $maxlen)    {	$minlen = $maxlen ;    }
	if ($minlen < $maxlen2)    {	$minlen = $maxlen2 ;    }
	if ($minlen < $minlen2)    {	$minlen = $minlen2;    }

	for my $x (0 .. $minlen)
	{
	    if ($min_path[$x] eq $max_path[$x])
	    {
		if ($min_path[$x] eq $max_path2[$x])
		{
		    if ($min_path[$x] eq $min_path2[$x])
		    {
			$hash .= $min_path[$x];
		    }
		}
	    }
	}

	
	$self->{hash} = $hash;
	my ( $newlat, $newlon ) = $gh->decode( $hash );

	my $report = $self->{min_lat} . ",".  $self->{min_lon} . " $min_hash - ";
	$report .= $self->{max_lat} . ",".  $self->{max_lon}  . " $max_hash - ";
	$report .= $self->{min_lat} . ",".  $self->{max_lon}  . " $max_hash2 - ";
	$report .= $self->{max_lat} . ",".  $self->{min_lon}  . " $min_hash2 - ";
	$report .= 	    $newlat . ",".  $newlon . " -> " ;
	$report .= 	    $self->{hash} . "". "\n";

	$report = $self->SUPER::BasicInfoStr($report);
	print RPT $report;

    } # if it contains coords
    else
    {
	$self->{hash} = "NULL";
    }
}

sub ProcessHistory
{
    my $self=shift;
    $self->Hash();
}



sub Split
{
    my $self =shift;
    #write this node to the right file
    my $hash = $self->{hash};
    warn "hash is $hash";
    my @path = split (//, $hash);    
    my $split = 5;
    my $len = scalar(@path);
    if ($len <= $split)
    {
	$split = $len -2; # 1   
    }	
    my @dirs = @path[0 .. $split];
    my @name = ();
    my $out= "output/" . join ("/",@dirs);
    my $out_file= join ("",@name);
    make_path($out);

    print RPT $self->SUPER::BasicInfoStr("$hash is split to $out and $out_file"); 
    my $file = $out. "/changeset_" . ${out_file} . "_p" . $self->{partno} . ".osm";
    open OUT,">>$file";
    binmode OUT, ":utf8";
    my $str = "<changeset " .  join (" ", 
				map { 
				    if ($self->{$_})
				    {
					$_ . "='"  . $self->{$_} . "'"
				    }
				    else
				    {
					""	
				    }
				     } @fields
	) 
	. "/>\n";

#    print OUT   SUPER::BasicInfoStr($self,$str);
    print OUT   $str;

    close OUT;
}

package OSM::API::OsmObjects::Node;
use strict;
use warnings;
use File::Path qw(make_path remove_tree);
use YAML;

our @ISA = qw[OSM::API::OsmObjects::BaseGeo];
sub new 
{
    my $class=shift;
    my $self =shift;
    $self->{tags}=    $self->{tags}={} ||{}; # create an empty hash of the tags
    return bless $self,$class;
}

sub lat
{
    my $self=shift;
    return $self->{lat};
}

sub hash
{
    my $self=shift;
    my $val =shift;
    if ($val)
    {
	$self->{hash}=$val;
    }
    else
    {
	return $self->{hash};
    }
}

sub lon
{
    my $self=shift;
    return $self->{lon};
}

sub partno
{
    my $self=shift;
    return $self->{partno};
}

sub tags
{
    my $self=shift;
    return $self->{tags};
}

sub Hash
{
    my $self=shift;
    my $hash = OSM::API::OsmObjects::Global::encode( $self->lat, $self->lon );
    $self->hash($hash);
#    warn $self->lat . ",".  $self->lon . " " . $self->hash;
}

sub ProcessHistory
{
    my $self=shift;
    $self->Hash();
}



BEGIN
{
    open RPT, ">data/debugreport_node.txt";
}

END
{
    close RPT;
}

sub Split
{
    my $self =shift;
    #write this node to the right file
    my $hash = $self->hash();
    my @path = split (//, $hash);
    
    my $split = 5;
    my $len = scalar(@path);
    if ($len <= $split)
    {
	$split = $len -2; # 1    
    }	

    my @dirs = @path[0 .. $split];
    my @name = @path[$split+1 .. scalar(@path) -1];
#    my $test= join ("/",@path);
    
    my $out= "output/" . join ("/",@dirs);
    my $out_file= join ("",@name);
    make_path($out);

    print RPT $self->SUPER::BasicInfoStr("$hash is split to $out and $out_file"); 
    my $file = $out. "/nodes_" . ${out_file} . "_p" . $self->{partno} . ".osm";
    open OUT,">>$file";
    binmode OUT, ":utf8";
    my $str = "<node " .  join (" ", 
				map { 
				    if ($self->{$_})
				    {
					$_ . "='"  . $self->{$_} . "'"
				    }
				    else
				    {
					""	
				    }
				} ('id' , 'timestamp',  'user',  'visible',  'version',  'changeset',  'lat', 'lon')
	) 
	. ">". # end of node start	
	# emit the tags, very cheap
	join (" ", map {
	    my $k = $_;
	    my $v = $self->{tags}{$k};
	    "<tag k='$k' v='$v' />"
	      } (keys %{$self->{tags}}))	
	. "</node>\n";
#    warn $str;
    
    print OUT $str;

    close OUT;
}



package OSM::API::OsmObjects::Way;
use strict;
use warnings;
use File::Path qw(make_path remove_tree);
use YAML;

our @ISA = qw[OSM::API::OsmObjects::BaseGeo];

sub hash
{
    my $self=shift;
    $self->{hash}="waytodo";
}

sub new 
{
    my $class=shift;
    my $self =shift;
    $self->{tags}=    $self->{tags} ||{}; # create an empty hash of the tags
    $self->{nodes}=    $self->{nodes} ||[]; # create an empty array of the nodes
    return bless $self,$class;
}

sub partno
{
    my $self=shift;
    return $self->{partno};
}

sub tags
{
    my $self=shift;
    return $self->{tags};
}


BEGIN
{
    open RPT, ">data/debugreportway.txt";
}

END
{
    close RPT;
}

sub Split
{
    my $self =shift;

#    warn Dump($self);
    my $hash = $self->hash();
    my @path = split (//, $hash);    
    my $split = 5;
    my $len = scalar(@path);
    if ($len <= $split)
    {
	$split = $len -2; # 1    
    }	
    my @dirs = @path[0 .. $split];
    my @name = @path[$split+1 .. scalar(@path) -1];
    my $out= "output/" . join ("/",@dirs);
    my $out_file= join ("",@name);
    make_path($out);

    print RPT $self->SUPER::BasicInfoStr("$hash is split to $out and $out_file"); 
    my $file = $out. "/relations_" . ${out_file} . "_p" . $self->{partno} . ".osm";
    open OUT,">>$file";
    binmode OUT, ":utf8";

    my $str = "<way " .  join (" ", 
				map { 
				    if ($self->{$_})
				    {
					$_ . "='"  . $self->{$_} . "'"
				    }
				    else
				    {
					""	
				    }
				} ('id' , 'timestamp',  'user',  'visible',  'version',  'changeset')
	) 
	. ">"; # end of way start	

    $str .=  join (" ", map 
		{
		    my $k = $_;
		    my $v = $self->{tags}{$k};
		    if ($v)
		    {
			"<tag k='$k' v='$v' />"
		    }
		    else
		    {
			warn " problem " . Dump($self);
		    }
		} 
		(keys %{$self->{tags}
		 }
		))	;


#    $str .= join (" ", map {	"<nd ref='$k' />"  } ( @{$self->{nodes}}))	
#    $str .= Dump($self->{nodes});
	; 

    $str .= "</way>\n";
#    warn $str;
#    my $str =
    
    print OUT $str;
    close OUT;
}

1;
