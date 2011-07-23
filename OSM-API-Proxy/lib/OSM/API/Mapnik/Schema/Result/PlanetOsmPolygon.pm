package OSM::API::Mapnik::Schema::Result::PlanetOsmPolygon;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

OSM::API::Mapnik::Schema::Result::PlanetOsmPolygon

=cut

__PACKAGE__->table("planet_osm_polygon");

=head1 ACCESSORS

=head2 osm_id

  data_type: 'integer'
  is_nullable: 1

=head2 access

  data_type: 'text'
  is_nullable: 1

=head2 addr:housename

  accessor: 'addr_housename'
  data_type: 'text'
  is_nullable: 1

=head2 addr:housenumber

  accessor: 'addr_housenumber'
  data_type: 'text'
  is_nullable: 1

=head2 addr:interpolation

  accessor: 'addr_interpolation'
  data_type: 'text'
  is_nullable: 1

=head2 admin_level

  data_type: 'text'
  is_nullable: 1

=head2 aerialway

  data_type: 'text'
  is_nullable: 1

=head2 aeroway

  data_type: 'text'
  is_nullable: 1

=head2 amenity

  data_type: 'text'
  is_nullable: 1

=head2 area

  data_type: 'text'
  is_nullable: 1

=head2 barrier

  data_type: 'text'
  is_nullable: 1

=head2 bicycle

  data_type: 'text'
  is_nullable: 1

=head2 brand

  data_type: 'text'
  is_nullable: 1

=head2 bridge

  data_type: 'text'
  is_nullable: 1

=head2 boundary

  data_type: 'text'
  is_nullable: 1

=head2 building

  data_type: 'text'
  is_nullable: 1

=head2 construction

  data_type: 'text'
  is_nullable: 1

=head2 covered

  data_type: 'text'
  is_nullable: 1

=head2 culvert

  data_type: 'text'
  is_nullable: 1

=head2 cutting

  data_type: 'text'
  is_nullable: 1

=head2 denomination

  data_type: 'text'
  is_nullable: 1

=head2 disused

  data_type: 'text'
  is_nullable: 1

=head2 embankment

  data_type: 'text'
  is_nullable: 1

=head2 foot

  data_type: 'text'
  is_nullable: 1

=head2 generator:source

  accessor: 'generator_source'
  data_type: 'text'
  is_nullable: 1

=head2 harbour

  data_type: 'text'
  is_nullable: 1

=head2 highway

  data_type: 'text'
  is_nullable: 1

=head2 historic

  data_type: 'text'
  is_nullable: 1

=head2 horse

  data_type: 'text'
  is_nullable: 1

=head2 intermittent

  data_type: 'text'
  is_nullable: 1

=head2 junction

  data_type: 'text'
  is_nullable: 1

=head2 landuse

  data_type: 'text'
  is_nullable: 1

=head2 layer

  data_type: 'text'
  is_nullable: 1

=head2 leisure

  data_type: 'text'
  is_nullable: 1

=head2 lock

  data_type: 'text'
  is_nullable: 1

=head2 man_made

  data_type: 'text'
  is_nullable: 1

=head2 military

  data_type: 'text'
  is_nullable: 1

=head2 motorcar

  data_type: 'text'
  is_nullable: 1

=head2 name

  data_type: 'text'
  is_nullable: 1

=head2 natural

  data_type: 'text'
  is_nullable: 1

=head2 oneway

  data_type: 'text'
  is_nullable: 1

=head2 operator

  data_type: 'text'
  is_nullable: 1

=head2 population

  data_type: 'text'
  is_nullable: 1

=head2 power

  data_type: 'text'
  is_nullable: 1

=head2 power_source

  data_type: 'text'
  is_nullable: 1

=head2 place

  data_type: 'text'
  is_nullable: 1

=head2 railway

  data_type: 'text'
  is_nullable: 1

=head2 ref

  data_type: 'text'
  is_nullable: 1

=head2 religion

  data_type: 'text'
  is_nullable: 1

=head2 route

  data_type: 'text'
  is_nullable: 1

=head2 service

  data_type: 'text'
  is_nullable: 1

=head2 shop

  data_type: 'text'
  is_nullable: 1

=head2 sport

  data_type: 'text'
  is_nullable: 1

=head2 surface

  data_type: 'text'
  is_nullable: 1

=head2 toll

  data_type: 'text'
  is_nullable: 1

=head2 tourism

  data_type: 'text'
  is_nullable: 1

=head2 tower:type

  accessor: 'tower_type'
  data_type: 'text'
  is_nullable: 1

=head2 tracktype

  data_type: 'text'
  is_nullable: 1

=head2 tunnel

  data_type: 'text'
  is_nullable: 1

=head2 water

  data_type: 'text'
  is_nullable: 1

=head2 waterway

  data_type: 'text'
  is_nullable: 1

=head2 wetland

  data_type: 'text'
  is_nullable: 1

=head2 width

  data_type: 'text'
  is_nullable: 1

=head2 wood

  data_type: 'text'
  is_nullable: 1

=head2 z_order

  data_type: 'integer'
  is_nullable: 1

=head2 way_area

  data_type: 'real'
  is_nullable: 1

=head2 way

  data_type: 'geometry'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "osm_id",
  { data_type => "integer", is_nullable => 1 },
  "access",
  { data_type => "text", is_nullable => 1 },
  "addr:housename",
  { accessor => "addr_housename", data_type => "text", is_nullable => 1 },
  "addr:housenumber",
  { accessor => "addr_housenumber", data_type => "text", is_nullable => 1 },
  "addr:interpolation",
  { accessor => "addr_interpolation", data_type => "text", is_nullable => 1 },
  "admin_level",
  { data_type => "text", is_nullable => 1 },
  "aerialway",
  { data_type => "text", is_nullable => 1 },
  "aeroway",
  { data_type => "text", is_nullable => 1 },
  "amenity",
  { data_type => "text", is_nullable => 1 },
  "area",
  { data_type => "text", is_nullable => 1 },
  "barrier",
  { data_type => "text", is_nullable => 1 },
  "bicycle",
  { data_type => "text", is_nullable => 1 },
  "brand",
  { data_type => "text", is_nullable => 1 },
  "bridge",
  { data_type => "text", is_nullable => 1 },
  "boundary",
  { data_type => "text", is_nullable => 1 },
  "building",
  { data_type => "text", is_nullable => 1 },
  "construction",
  { data_type => "text", is_nullable => 1 },
  "covered",
  { data_type => "text", is_nullable => 1 },
  "culvert",
  { data_type => "text", is_nullable => 1 },
  "cutting",
  { data_type => "text", is_nullable => 1 },
  "denomination",
  { data_type => "text", is_nullable => 1 },
  "disused",
  { data_type => "text", is_nullable => 1 },
  "embankment",
  { data_type => "text", is_nullable => 1 },
  "foot",
  { data_type => "text", is_nullable => 1 },
  "generator:source",
  { accessor => "generator_source", data_type => "text", is_nullable => 1 },
  "harbour",
  { data_type => "text", is_nullable => 1 },
  "highway",
  { data_type => "text", is_nullable => 1 },
  "historic",
  { data_type => "text", is_nullable => 1 },
  "horse",
  { data_type => "text", is_nullable => 1 },
  "intermittent",
  { data_type => "text", is_nullable => 1 },
  "junction",
  { data_type => "text", is_nullable => 1 },
  "landuse",
  { data_type => "text", is_nullable => 1 },
  "layer",
  { data_type => "text", is_nullable => 1 },
  "leisure",
  { data_type => "text", is_nullable => 1 },
  "lock",
  { data_type => "text", is_nullable => 1 },
  "man_made",
  { data_type => "text", is_nullable => 1 },
  "military",
  { data_type => "text", is_nullable => 1 },
  "motorcar",
  { data_type => "text", is_nullable => 1 },
  "name",
  { data_type => "text", is_nullable => 1 },
  "natural",
  { data_type => "text", is_nullable => 1 },
  "oneway",
  { data_type => "text", is_nullable => 1 },
  "operator",
  { data_type => "text", is_nullable => 1 },
  "population",
  { data_type => "text", is_nullable => 1 },
  "power",
  { data_type => "text", is_nullable => 1 },
  "power_source",
  { data_type => "text", is_nullable => 1 },
  "place",
  { data_type => "text", is_nullable => 1 },
  "railway",
  { data_type => "text", is_nullable => 1 },
  "ref",
  { data_type => "text", is_nullable => 1 },
  "religion",
  { data_type => "text", is_nullable => 1 },
  "route",
  { data_type => "text", is_nullable => 1 },
  "service",
  { data_type => "text", is_nullable => 1 },
  "shop",
  { data_type => "text", is_nullable => 1 },
  "sport",
  { data_type => "text", is_nullable => 1 },
  "surface",
  { data_type => "text", is_nullable => 1 },
  "toll",
  { data_type => "text", is_nullable => 1 },
  "tourism",
  { data_type => "text", is_nullable => 1 },
  "tower:type",
  { accessor => "tower_type", data_type => "text", is_nullable => 1 },
  "tracktype",
  { data_type => "text", is_nullable => 1 },
  "tunnel",
  { data_type => "text", is_nullable => 1 },
  "water",
  { data_type => "text", is_nullable => 1 },
  "waterway",
  { data_type => "text", is_nullable => 1 },
  "wetland",
  { data_type => "text", is_nullable => 1 },
  "width",
  { data_type => "text", is_nullable => 1 },
  "wood",
  { data_type => "text", is_nullable => 1 },
  "z_order",
  { data_type => "integer", is_nullable => 1 },
  "way_area",
  { data_type => "real", is_nullable => 1 },
  "way",
  { data_type => "geometry", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-07-23 17:08:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Ynpl/pKPEHBJXkss00oLnQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
