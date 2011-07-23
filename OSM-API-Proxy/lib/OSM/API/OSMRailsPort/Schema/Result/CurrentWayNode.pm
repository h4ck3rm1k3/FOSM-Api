package OSM::API::OSMRailsPort::Schema::Result::CurrentWayNode;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

OSM::API::OSMRailsPort::Schema::Result::CurrentWayNode

=cut

__PACKAGE__->table("current_way_nodes");

=head1 ACCESSORS

=head2 id

  data_type: 'bigint'
  is_foreign_key: 1
  is_nullable: 0

=head2 node_id

  data_type: 'bigint'
  is_foreign_key: 1
  is_nullable: 0

=head2 sequence_id

  data_type: 'bigint'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "bigint", is_foreign_key => 1, is_nullable => 0 },
  "node_id",
  { data_type => "bigint", is_foreign_key => 1, is_nullable => 0 },
  "sequence_id",
  { data_type => "bigint", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id", "sequence_id");

=head1 RELATIONS

=head2 node

Type: belongs_to

Related object: L<OSM::API::OSMRailsPort::Schema::Result::CurrentNode>

=cut

__PACKAGE__->belongs_to(
  "node",
  "OSM::API::OSMRailsPort::Schema::Result::CurrentNode",
  { id => "node_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 id

Type: belongs_to

Related object: L<OSM::API::OSMRailsPort::Schema::Result::CurrentWay>

=cut

__PACKAGE__->belongs_to(
  "id",
  "OSM::API::OSMRailsPort::Schema::Result::CurrentWay",
  { id => "id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-07-23 17:08:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Mh7mlVFw5c4BVbxJLY7N8A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
