package OSM::API::OsmObjects::Global;
use Geo::Hash;
our $gh = Geo::Hash->new;
1;

package OSM::API::OsmObjects::ChangeSet;

my @fields = 
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

use File::Path qw(make_path remove_tree);
sub Hash
{
    my $self=shift;
    if ($self->{min_lat})
    {
#    warn "no bounds" unless $self->{min_lat};
	warn "no bounds" unless $self->{min_lon};
	warn "no bounds" unless $self->{max_lat};
	warn "no bounds" unless $self->{max_lon};

	my $min_hash = $OSM::API::OsmObjects::Global::gh->encode( $self->{min_lat}, $self->{min_lon} );
	my $max_hash = $OSM::API::OsmObjects::Global::gh->encode( $self->{max_lat}, $self->{max_lon} );

	my $min_hash2 = $OSM::API::OsmObjects::Global::gh->encode( $self->{min_lat}, $self->{max_lon} );
	my $max_hash2 = $OSM::API::OsmObjects::Global::gh->encode( $self->{max_lat}, $self->{min_lon} );

	# now we look for the common prefix
	my @min_path = split (//, $min_hash);
	my @max_path = split (//, $max_hash);

	my @min_path2 = split (//, $min_hash2);
	my @max_path2 = split (//, $max_hash2);
	$hash = "";

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
	$report .= 	    $self->{hash} . "\n";
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

use YAML;

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
    print RPT "$hash is split to $out and $out_file\n" ;
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

    print OUT $str;
    close OUT;
}

package OSM::API::OsmObjects::Node;

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
    my $hash = $OSM::API::OsmObjects::Global::gh->encode( $self->lat, $self->lon );
    $self->hash($hash);
#    warn $self->lat . ",".  $self->lon . " " . $self->hash;
}

sub ProcessHistory
{
    my $self=shift;
    $self->Hash();
}

#use YAML;
use File::Path qw(make_path remove_tree);
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
    my @dirs = @path[0 .. $split];
    my @name = @path[$split+1 .. scalar(@path) -1];
#    my $test= join ("/",@path);
    my $out= "output/" . join ("/",@dirs);
    my $out_file= join ("",@name);
    make_path($out);
    print RPT "$hash is split to $out and $out_file\n" ;
    my $file = $out. "/nodes_" . ${out_file} . "_p" . $self->partno . ".osm";
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

package OSM::API::OsmObjects::Relation;
sub new 
{
    my $class=shift;
    my $self =shift;
    $self->{tags}=    $self->{tags} ||{}; # create an empty hash of the tags
    $self->{nodes}=    $self->{nodes} ||[]; # create an empty array of the nodes
    return bless $self,$class;
}


package OSM::API::OsmObjects::Way;
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

use YAML;
use File::Path qw(make_path remove_tree);
sub Split
{
    my $self =shift;

    warn Dump($self);

    
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
			warn Dump($self);
		    }
		} 
		(keys %{$self->{tags}
		 }
		))	;


    $str .= join (" ", map {
	"<nd ref='$k' />"
		  } ( @{$self->{nodes}}))	
	; 

    $str .= "</way>\n";
#    warn $str;
#    my $str =
    
    print OUT $str;
    close OUT;
}

1;
