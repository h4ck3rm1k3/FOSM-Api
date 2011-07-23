package OSM::API::Mapnik::Schema::Result::PlanetOsmRel;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

OSM::API::Mapnik::Schema::Result::PlanetOsmRel

=cut

__PACKAGE__->table("planet_osm_rels");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_nullable: 0

=head2 way_off

  data_type: 'smallint'
  is_nullable: 1

=head2 rel_off

  data_type: 'smallint'
  is_nullable: 1

=head2 parts

  data_type: 'integer[]'
  is_nullable: 1

=head2 members

  data_type: 'text[]'
  is_nullable: 1

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
  "way_off",
  { data_type => "smallint", is_nullable => 1 },
  "rel_off",
  { data_type => "smallint", is_nullable => 1 },
  "parts",
  { data_type => "integer[]", is_nullable => 1 },
  "members",
  { data_type => "text[]", is_nullable => 1 },
  "tags",
  { data_type => "text[]", is_nullable => 1 },
  "pending",
  { data_type => "boolean", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-07-23 17:08:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:XcMiqiKnU7MhgVtSWaEY4Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
