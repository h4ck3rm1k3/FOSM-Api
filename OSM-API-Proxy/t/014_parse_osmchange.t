use Test::More tests => 1;
use strict;
use warnings;
use YAML;
use_ok("OSM::API::OsmChange");
my $p = OSM::API::OsmChange->new();
my $c1= $p->parse(q[<osmChange version="0.6" generator="JOSM">
<modify>
  <node id='1287731165' action='modify' timestamp='2011-05-16T14:56:18Z' uid='355102' user='BesfortGuri/Besfort Guri/BesfortGuri/Besfort Guri/Besfort Guri/BesfortGuri' visible='true' version='2' changeset='1000001384' lat='42.61893168122738' lon='20.57614856619908' />
</modify>
</osmChange>]);
#warn Dump($p);
ok($p);
ok($c1);


my $c2 = $p->parse(q[<osmChange version="0.3" generator="Osmosis">
    <modify version="0.3" generator="Osmosis">
        <node id="12050350" timestamp="2007-01-02T00:00:00.0+11:00" lat="-33.9133118622908" lon="151.117335519304">
            <tag k="created_by" v="JOSM"/>
        </node>
    </modify>
</osmChange>]);
#warn Dump($p);
ok($p);
ok($c2);


#####
 $c2 = $p->parse(q[<osmChange version="0.3" generator="Osmosis">
    <create version="0.3" generator="Osmosis">
        <node id="-1" timestamp="2007-01-02T00:00:00.0+11:00" lat="-33.9133118622908" lon="151.117335519304">
            <tag k="created_by" v="JOSM"/>
        </node>
        <node id="-2" timestamp="2007-01-02T00:00:00.0+11:00" lat="-33.9233118622908" lon="151.117335519304">
            <tag k="created_by" v="JOSM"/>
        </node>
        <way id="-3" timestamp="2007-01-02T00:00:00.0+11:00">
            <nd ref="-1"/>
            <nd ref="-2"/>
            <tag k="created_by" v="JOSM"/>
        </way>
    </create>
</osmChange>]);
ok($p);
ok($c2);

#######################################################################

 $c2 = $p->parse(q[<osmChange version="0.3" generator="Osmosis">
   <create>
       <node id="-1" timestamp="2007-01-02T00:00:00.0+11:00" lat="-33.9133118622908" lon="151.117335519304" changeset="1234" version="12"/>
       <way id="-3" timestamp="2007-01-02T00:00:00.0+11:00" changeset="1234" version="32">
           <nd ref="-1"/>
           <nd ref="-2"/>
       </way>
   </create>
</osmChange>]);
ok($p);
ok($c2);

#######################################################################