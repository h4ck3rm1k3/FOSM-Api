use XML::RSS;
#$XML::RSS::AUTO_ADD=1;
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

my %rename = (
  'http://search.yahoo.com/mrss/' => 'mrss',
  'http://www.georss.org/georss' => 'georss',
  
);

# take 
sub filtertags
{
    my $prefix=shift;
    my $entry=shift;
    my $tags; # create an array
    foreach my $tag (keys %{$entry->{entry}})
    {
	my $v =$entry->{entry}{$tag};
#	warn "looking at $tag";
	if ($rename{$tag})
	{
	    $tag =$rename{$tag};
	}
	$tag= "${prefix}:${tag}";
	push @{$tags},OSM::API::Tag->new("k" => $tag, "v"=>$v);
    }   

    return OSM::API::Tags->new("Tags" => $tags)
}

my $example_url="http://earthquakescanada.nrcan.gc.ca/recent/maps-cartes/index-fra.php?tpl_region=nb&tpl_output=rss";
#my $example_url="http://earthquakescanada.nrcan.gc.ca/index-fra.php?tpl_output=rss&tpl_region=nb";
#my $example_url="http://www.fao.org/geonetwork/srv/en/rss.latest?georss=simple";
#my $example_url="http://feeds.feedburner.com/allpointsblog-directions-magazine?format=xml";

#<?xml version="1.0" encoding="UTF-8"?>
#<rss xmlns:media="http://search.yahoo.com/mrss/" xmlns:georss="http://www.georss.org/georss" xmlns:gml="http://www.opengis.net/gml" version="2.0">
#<channel><title>GeoNetwork opensource portal to spatial data and information</title>

my $feed;
my $name =$example_url;
$name =~ s/[\/\\\?\.:&=]/_/g;
my $file = "./feeds/" . $name;

warn "$file";
my $rss=	XML::RSS->new();
if (!-f $file)
{
    my $res = URI::Fetch->fetch($example_url)
        or die URI::Fetch->errstr;
    warn $res;

    open OUT ,">$file" or die "cannot open $file";
    print OUT $res;
    close OUT;
}
else
{
    warn "processing file $file";

    $feed = $rss->parsefile($file)
	or die "error";
}
	
print Dump($rss->{channel}{title}), "\n";
my @entries=@{$rss->{items}};
warn "found in $example_url entries :" . scalar(@entries);
for my $entry (@entries) {
    warn Dump($entry);
  my $box=$entry->{entry}{'http://www.georss.org/georss'}{box};
#  delete $entry->{entry}{'http://www.georss.org/georss'}; # processed
  if($box)
    {

#A bounding box is a rectangular region, often used to define the extents of a map or a rough area of interest. A box contains two space seperate latitude-longitude pairs, with each pair separated by whitespace. The first pair is the lower corner, the second is the upper corner.

      my ($lowerlat,$lowerlon,$upperlat,$upperlon )= split / /,$box;
#      warn join "|",($lowerlat,$lowerlon,$upperlat,$upperlon );

      #create four points and one way to connect them

      my $way=box($lowerlat,$lowerlon,$upperlat,$upperlon);
      #$way->tags();
      my $tags =filtertags("fao.org",$entry);
      $way->set_tags($tags);

      print Dump($way);
    }

# entry:
#   category: Geographic metadata catalog
#   description: '<p><a href="http://www.fao.org:80/geonetwork?uuid=d9094de0-88fd-11da-a88f-000d939bc5d8"><img src="/geonetwork/srv/en/resources.get?id=6799&amp;fname=colombia-812-mapa_del_estudio_general_de_suelos-soils-1-100000_800px_s.png&amp;access=public" align="left" alt="" border="0" width="100" style="padding:15px;"/></a>Mapa del Estudio general de suelos<br/><a href="mailto:?subject=Mapa del Estudio general de suelos de la cuenca hidrografica alta del Rio Bogota (Colombia)&amp;body=%0ALink:%0Ahttp://www.fao.org:80/geonetwork?uuid=d9094de0-88fd-11da-a88f-000d939bc5d8%0A%0AAbstract:%0AMapa del Estudio general de suelos"><img src="http://www.fao.org:80/geonetwork/images/mail.png" alt="Send a reference to this record by email" title="Send a reference to this record by email" style="border: 0px solid;padding:2px;padding-right:10px;"/></a><a href="http://www.fao.org:80/geonetwork?uuid=d9094de0-88fd-11da-a88f-000d939bc5d8"><img src="http://www.fao.org:80/geonetwork/images/bookmark.png" alt="Permanent link to this description" title="Permanent link to this description" style="border: 0px solid;padding:2px;"/></a><a href="http://del.icio.us/post?url=http://www.fao.org:80/geonetwork?uuid=d9094de0-88fd-11da-a88f-000d939bc5d8&amp;title=Mapa del Estudio general de suelos de la cuenca hidrografica alta del Rio Bogota (Colombia)&amp;notes=. " target="_blank"><img src="http://www.fao.org:80/geonetwork/images/delicious.gif" alt="Bookmark on Delicious" title="Bookmark on Delicious" style="border: 0px solid;padding:2px;"/></a><a href="http://digg.com/submit?url=http://www.fao.org:80/geonetwork?uuid=d9094de0-88fd-11da-a88f-000d939bc5d8&amp;title=Mapa del Estudio general de suelos de la cuenca hidrografica alta del Rio &amp;bodytext=.&amp;topic=environment" target="_blank"><img src="http://www.fao.org:80/geonetwork/images/digg.gif" alt="Bookmark on Digg" title="Bookmark on Digg" style="border: 0px solid;padding:2px;"/></a><a href="http://www.facebook.com/sharer.php?u=http://www.fao.org:80/geonetwork?uuid=d9094de0-88fd-11da-a88f-000d939bc5d8" target="_blank"><img src="http://www.fao.org:80/geonetwork/images/facebook.gif" alt="Bookmark on Facebook" title="Bookmark on Facebook" style="border: 0px solid;padding:2px;"/></a><a href="http://www.stumbleupon.com/submit?url=http://www.fao.org:80/geonetwork?uuid=d9094de0-88fd-11da-a88f-000d939bc5d8&amp;title=Mapa del Estudio general de suelos de la cuenca hidrografica alta del Rio Bogota (Colombia)" target="_blank"><img src="http://www.fao.org:80/geonetwork/images/stumbleupon.gif" alt="Bookmark on StumbleUpon" title="Bookmark on StumbleUpon" style="border: 0px solid;padding:2px;"/></a></p><br clear="all"/>'
#   guid: http://www.fao.org:80/geonetwork?uuid=d9094de0-88fd-11da-a88f-000d939bc5d8
#   http://search.yahoo.com/mrss/:
#     text: Mapa del Estudio general de suelos
#   http://www.georss.org/georss:
#     box: -4.23 -81.72 12.59 -66.87
#   isPermaLink: ''
#   link: http://www.fao.org:80/geonetwork?uuid=d9094de0-88fd-11da-a88f-000d939bc5d8
#   pubDate: 26 Nov 2011 15:52:50 EST
#   title: Mapa del Estudio general de suelos de la cuenca hidrografica alta del Rio Bogota (Colombia)

}
