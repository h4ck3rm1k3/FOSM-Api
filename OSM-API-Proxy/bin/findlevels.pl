use YAML;
use Dancer::Plugin::DBIC qw(schema);
use Data::Dumper;
use DBD::Spatialite;
use DBI;

my $dbfile = "/pine02/planet/earthindex.sqlite";
my @params = ( "dbi:Spatialite:dbname=$dbfile", '', '' );
my $dbh = DBI->connect( @params );

# now we just create a new table to insert into
$dbh->do("create table idx_earthindex_bbox_node_expanded(parentnode int, childnode int, min_lon double, max_lon double, min_lat double, max_lat double)");
#$dbh->do("SELECT AddGeometryColumn('idx_earthindex_bbox_node_expanded', 'bbox', 4326, 'POLYGON', 2);");

# now we will fill this out.

my $sth = $dbh->prepare("select nodeno,rtreenode(2,data) from idx_earthindex_bbox_node");
$sth->execute;

my $sthi = $dbh->prepare("insert into idx_earthindex_bbox_node_expanded(parentnode , childnode , min_lon , max_lon , min_lat , max_lat) values (?,?,?,?,?,?)");

while (my $cols = $sth->fetch)
{
    my ($id,$data)= (@$cols);
    my @children = split "\{", $data;
    for my $c (@children)
    {
	if ($c =~ /(\d+) ([\d\.\-]+) ([\d\.\-]+) ([\d\.\-]+) ([\d\.\-]+)\}/)
	{
	    my $childid=$1;
	    my $minx=$2;
	    my $maxx=$3;
	    my $miny=$4;
	    my $maxy=$5;
	    #print join ("\t",		( $id, $childid,	  $minx,		$maxx,		 $miny,		$maxy) ). "\n";
	    $sthi->execute( $id, $childid,	  $minx,		$maxx,		 $miny,		$maxy);
	}
    }
};

1;
