package OSM::API::OSMRailsPort::Schema::Result::Node;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

OSM::API::OSMRailsPort::Schema::Result::Node

=cut

__PACKAGE__->table("nodes");

=head1 ACCESSORS

=head2 id

  data_type: 'bigint'
  is_nullable: 0

=head2 latitude

  data_type: 'integer'
  is_nullable: 0

=head2 longitude

  data_type: 'integer'
  is_nullable: 0

=head2 changeset_id

  data_type: 'bigint'
  is_foreign_key: 1
  is_nullable: 0

=head2 visible

  data_type: 'boolean'
  is_nullable: 0

=head2 timestamp

  data_type: 'timestamp'
  is_nullable: 0

=head2 tile

  data_type: 'bigint'
  is_nullable: 0

=head2 version

  data_type: 'bigint'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "bigint", is_nullable => 0 },
  "latitude",
  { data_type => "integer", is_nullable => 0 },
  "longitude",
  { data_type => "integer", is_nullable => 0 },
  "changeset_id",
  { data_type => "bigint", is_foreign_key => 1, is_nullable => 0 },
  "visible",
  { data_type => "boolean", is_nullable => 0 },
  "timestamp",
  { data_type => "timestamp", is_nullable => 0 },
  "tile",
  { data_type => "bigint", is_nullable => 0 },
  "version",
  { data_type => "bigint", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id", "version");

=head1 RELATIONS

=head2 node_tags

Type: has_many

Related object: L<OSM::API::OSMRailsPort::Schema::Result::NodeTag>

=cut

__PACKAGE__->has_many(
  "node_tags",
  "OSM::API::OSMRailsPort::Schema::Result::NodeTag",
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
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Bc+vWmSlzZB4h2UCqZ13zg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
