package PlanetIndex;
use Dancer ':syntax';
use YAML;
use Dancer::Plugin::DBIC qw(schema);
use Data::Dumper;
use DBD::Spatialite;
use DBI;

my $dbfile = "/pine02/planet/earthindex.sqlite";
my @params = ( "dbi:Spatialite:dbname=$dbfile", '', '' );
my $dbh = DBI->connect( @params );

our $VERSION = '0.01';

get '/' => sub {
    "Hello world";
};

get '/index/:page' => sub {
    my $page = params->{page};

    my $sth = $dbh->prepare("SELECT * FROM earthindex limit 100 ");
    $sth->execute;


    my $html = "<h1>List of blocks in planet on page $page</h1>";
    $html .= "<table>";


    while (my $cols = $sth->fetch)
    {
	$html .= "<tr>";	
	for my $col (@$cols) {
	    
	    $html .= "<td>";
	    $html .= $col;
	    $html .= "</td>";
	}
	$html .= "</tr>";
    }
	
    $html .= "</table>";
    $html;
};


get '/contains/:lat/:lon' => sub {
    my $lat = params->{lat};
    my $lon = params->{lon};

    my $sth = $dbh->prepare("SELECT * FROM earthindex where (first_lat <= $lat and last_lat  >= $lat and first_lon <= $lon and last_lon >= $lon) or 
                                                            (last_lat  <= $lat and first_lat >= $lat and last_lon  <= $lon and first_lon >= $lon) order by bytepos limit 100 ");
    $sth->execute;
# CREATE TABLE earthindex (bytepos integer, bitpos integer, blocksize integer, blocktotal integer, first_lat double, last_lat double, first_lon double, last_lon double, "upper_left" POINT, "lower_right" POINT, "bbox" POLYGON, area double, "cpoint" POINT);


    my $html = "<h1>List of blocks in planet around lat :$lat and lon :$lon </h1>";


    $html .= "<table>";
    $html .=  '<tr>
<th>bytepos integer</th>
<th>bitpos integer</th>
<th>blocksize integer</th>
<th>blocktotal integer</th>
<th>first_lat double</th>
<th>last_lat double</th>
<th>first_lon double</th>
<th>last_lon double</th>
<th>upper_left POINT</th>
<th>lower_right POINT</th>
<th>bbox POLYGON</th>
<th>area double</th>
<th>cpoint POINT</th>
</tr>';


    while (my $cols = $sth->fetch)
    {
	$html .= "<tr>";	
	for my $col (@$cols) {
	    
	    $html .= "<td>";
	    $html .= $col;
	    $html .= "</td>";
	}
	$html .= "</tr>";
    }
	
    $html .= "</table>";
    $html;
};

get '/position/:min/:max/map' => sub {
    my $min = params->{min};
    my $max = params->{max};
    my $sth = $dbh->prepare("SELECT first_lon,first_lat,last_lon,last_lat FROM earthindex where bytepos <= $max and bytepos >= $min limit 100 ");
    $sth->execute;
# CREATE TABLE earthindex (bytepos integer, bitpos integer, blocksize integer, blocktotal integer, first_lat double, last_lat double, first_lon double, last_lon double, "upper_left" POINT, "lower_right" POINT, "bbox" POLYGON, area double, "cpoint" POINT);

    my @boxes;
    
    while (my $cols = $sth->fetch)
    {
	push @boxes, "[" . join (",",@{$cols}) . "]" ;
    }

    #
    my $boxtext= join (",",@boxes) ;
#    warn $boxtext;
    template 'openlayers2', { boxes => $boxtext}, { layout => undef }; #, { boxes => \@boxes };

};


get '/test/map' => sub {
    template 'openlayers', {}, { layout => undef }; #, { boxes => \@boxes };
};

get '/test/map2' => sub {
    template 'openlayers2', { boxes => " [-10, 50, 5, 60], "}, { layout => undef }; #, { boxes => \@boxes };
};


get '/test/tpl' => sub {
    template 'index', {}, { layout => undef };
};


1;
