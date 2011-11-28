use XML::RSS;
use strict;
use warnings;
use YAML;
use OSM::API::Point;
use OSM::API::Way;
use OSM::API::Tag;
use OSM::API::Tags;
use URI::Fetch;

sub way
{
    my @points=@_;	
    my $w=OSM::API::Way->new(points=>[@points]);    
    return $w;
}

sub point
{
    my ($lat,$lon)=@_;
    #warn "adding point $lat,$lon";
    my $p=OSM::API::Point->new(lat=>$lat,lon =>$lon);
    return $p;
}

sub box
{
    my ($lowerlat,$lowerlon,$upperlat,$upperlon)=@_;
    my $ll=    point($lowerlat,$lowerlon);      #1   LU(3)------------UU(2)
    my $uu=    point($upperlat,$upperlon);	#    |                |
    my $lu=    point($lowerlat,$upperlon);	#    |                |
    my $ul=    point($upperlat,$lowerlon);	#    LL(1)------------UL(4)
    
    my $way = way($lu,$uu,$ul,$ll);
    
    return $way;
}

# take 
sub filter_tags
{
    my $prefix=shift;
    my $entry=shift;
    my $tags=[]; # create an array
    foreach my $tag (keys %{$entry})
    {
	my $v =$entry->{$tag};
	next if $v =~ /^\s+$/; # skip whitespace
	$tag= "${prefix}:${tag}";
#	warn "value:" .Dump($v);
	my $ref= ref $v;
#	warn "looking at $tag with value $v of type $ref";
	
	push @{$tags},OSM::API::Tag->new("k" => $tag, "v"=>$v);
    }   

    return OSM::API::Tags->new("Tags" => $tags)
}

sub filter_osm
{
    my $where=shift;
    my $ref= ref $where;
 #   warn Dump($where);
    return $where->create_OSM();
}

sub process_feed
{
    my $prefix=shift;
    my $url   =shift;
    my $name =$url;
    $name =~ s/[\/\\\?\.:&=]/_/g;
    my $file = "./feeds/" . $name;
    my $rss=	XML::RSS->new();
    if (!-f $file)
    {
	my $res = URI::Fetch->fetch($url)
	    or die URI::Fetch->errstr;
	warn $res;
	open OUT ,">$file" or die "cannot open $file";
	print OUT $res;
	close OUT;
    }
    else
    {
	warn "processing file $file";
	$rss->parsefile($file)
	    or die "error";
    }
    print "<osm version='0.6'>\n";
    my @entries=@{$rss->{items}};
    for my $entry (@entries) {
#	warn Dump($entry);
	my $where=$entry->{where};
	delete $entry->{where}; # remove it from the tags
	if($where)
	{
	    my $geo = filter_osm($where);
	    if ($geo)
	    {
		my $tags =filter_tags($prefix,$entry);
		if ($tags)
		{
		    $geo->{tags}=$tags;
		}
		$geo->emit_OSM();
	    }
	    else
	    {
		warn "no data";
	    }
	}
	
    }
    print "</osm>\n";
}


process_feed 
    "earthquakescanada.nrcan.gc.ca",
    "http://earthquakescanada.nrcan.gc.ca/recent/maps-cartes/index-fra.php?tpl_region=nb&tpl_output=rss";
