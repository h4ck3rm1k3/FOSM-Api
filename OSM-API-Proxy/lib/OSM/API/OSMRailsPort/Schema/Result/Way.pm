package OSM::API::OSMRailsPort::Schema::Result::Way;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

OSM::API::OSMRailsPort::Schema::Result::Way

=cut

__PACKAGE__->table("ways");

=head1 ACCESSORS

=head2 id

  data_type: 'bigint'
  default_value: 0
  is_nullable: 0

=head2 changeset_id

  data_type: 'bigint'
  is_foreign_key: 1
  is_nullable: 0

=head2 timestamp

  data_type: 'timestamp'
  is_nullable: 0

=head2 version

  data_type: 'bigint'
  is_nullable: 0

=head2 visible

  data_type: 'boolean'
  default_value: true
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "bigint", default_value => 0, is_nullable => 0 },
  "changeset_id",
  { data_type => "bigint", is_foreign_key => 1, is_nullable => 0 },
  "timestamp",
  { data_type => "timestamp", is_nullable => 0 },
  "version",
  { data_type => "bigint", is_nullable => 0 },
  "visible",
  { data_type => "boolean", default_value => \"true", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id", "version");

=head1 RELATIONS

=head2 way_nodes

Type: has_many

Related object: L<OSM::API::OSMRailsPort::Schema::Result::WayNode>

=cut

__PACKAGE__->has_many(
  "way_nodes",
  "OSM::API::OSMRailsPort::Schema::Result::WayNode",
  { "foreign.id" => "self.id", "foreign.version" => "self.version" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 way_tags

Type: has_many

Related object: L<OSM::API::OSMRailsPort::Schema::Result::WayTag>

=cut

__PACKAGE__->has_many(
  "way_tags",
  "OSM::API::OSMRailsPort::Schema::Result::WayTag",
  { "foreign.id" => "self.id", "foreign.version" => "self.version" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 changeset

Type: belongs_to

Related object: L<OSM::API::OSMRailsPort::Schema::Result::Changeset>

=cut

__PACKAGE__->belongs_to(
  "changeset",
  "OSM::API::OSMRailsPort::Schema::Result::Changeset",
  { id => "changeset_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-07-23 17:08:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:/8TOwNyvSjfP+A7jNnOWcw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
