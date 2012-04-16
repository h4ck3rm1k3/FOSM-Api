use YAML;
use Dancer::Plugin::DBIC qw(schema);
use Data::Dumper;
use DBD::Spatialite;
use DBI;

#my $dbfile = "/pine02/planet/earthindex.sqlite";
#my @params = ( "dbi:Spatialite:dbname=$dbfile", '', '' );
#my $dbh = DBI->connect( @params , {    AutoCommit => 1,});
# now we just create a new table to insert into
#$dbh->do("alter table idx_earthindex_bbox_node_expanded add level int");
#$dbh->do("alter table idx_earthindex_bbox_node_expanded add area double");
#$dbh->do("create index idx_earthindex_bbox_node_expanded_level on idx_earthindex_bbox_node_expanded (level )");
#$dbh->do("create index idx_earthindex_bbox_node_expanded_parent on idx_earthindex_bbox_node_expanded (parentnode )");
#$dbh->do("create index idx_earthindex_bbox_node_expanded_childe on idx_earthindex_bbox_node_expanded (childnode )");
#this was not working $dbh->do("SELECT AddGeometryColumn('idx_earthindex_bbox_node_expanded','bbox', 4326, 'POLYGON', 2)");
#$dbh->do("update idx_earthindex_bbox_node_expanded set level=1 where parentnode in (1)");
#$dbh->do("update idx_earthindex_bbox_node_expanded set area =  ST_Area(bbox) ");
#$dbh->do("update idx_earthindex_bbox_node_expanded set bbox = BuildMBR( min_lon, min_lat, max_lon, max_lat, 4326)");
#start with this update idx_earthindex_bbox_node_expanded set level=1 where parentnode in (select nodeno from idx_earthindex_bbox_parent where parentnode=1);
# check the levels select count(*), level from idx_earthindex_bbox_node_expanded group by level;
#my $levelsth= $dbh->prepare("update idx_earthindex_bbox_node_expanded set level=? where parentnode in (select childnode from idx_earthindex_bbox_node_expanded where level =?)");

for (my $l=2; $l < 20; $l++)
{
# now we will fill this out.
#    $levelsth->execute($l, $l -1);
    printf("update idx_earthindex_bbox_node_expanded set level=%d where parentnode in (select childnode from idx_earthindex_bbox_node_expanded where level =%d);\n"
	   ,   $l, $l-1) ;
}

1;
