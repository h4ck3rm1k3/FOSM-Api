package OSM::API::Mapnik::Schema::Result::PlanetOsmWay;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

OSM::API::Mapnik::Schema::Result::PlanetOsmWay

=cut

__PACKAGE__->table("planet_osm_ways");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_nullable: 0

=head2 nodes

  data_type: 'integer[]'
  is_nullable: 0

=head2 tags

  data_type: 'text[]'
  is_nullable: 1

=head2 pending

  data_type: 'boolean'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_nullable => 0 },
  "nodes",
  { data_type => "integer[]", is_nullable => 0 },
  "tags",
  { data_type => "text[]", is_nullable => 1 },
  "pending",
  { data_type => "boolean", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-07-23 17:08:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:188e0AjJafFse1Bz5NE4og


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
