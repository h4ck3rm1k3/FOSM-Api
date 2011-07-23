use DBIx::Class::Schema::Loader qw(make_schema_at);


make_schema_at(
OSM::API::Mapnik::Schema,  
{ 
    debug => 1,
    dump_directory => './lib',
    db_schema => 'public', 
    components => [InflateColumn::DateTime] 
}, 
    [ 'dbi:Pg:dbname=gisdb', 'mdupont', 'mdupont' ],

);

make_schema_at(
OSM::API::OSMRailsPort::Schema,  
{ 
    debug => 1,
    dump_directory => './lib',
    db_schema => 'public', 
    components => [InflateColumn::DateTime] 
}, 
    [ 'dbi:Pg:dbname=openstreetmap', 'mdupont', 'mdupont' ]
);

