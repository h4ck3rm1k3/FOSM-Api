package OSM::API::OSMRailsPort::Schema::Result::Changeset;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

OSM::API::OSMRailsPort::Schema::Result::Changeset

=cut

__PACKAGE__->table("changesets");

=head1 ACCESSORS

=head2 id

  data_type: 'bigint'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'changesets_id_seq'

=head2 user_id

  data_type: 'bigint'
  is_foreign_key: 1
  is_nullable: 0

=head2 created_at

  data_type: 'timestamp'
  is_nullable: 0

=head2 min_lat

  data_type: 'integer'
  is_nullable: 1

=head2 max_lat

  data_type: 'integer'
  is_nullable: 1

=head2 min_lon

  data_type: 'integer'
  is_nullable: 1

=head2 max_lon

  data_type: 'integer'
  is_nullable: 1

=head2 closed_at

  data_type: 'timestamp'
  is_nullable: 0

=head2 num_changes

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "bigint",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "changesets_id_seq",
  },
  "user_id",
  { data_type => "bigint", is_foreign_key => 1, is_nullable => 0 },
  "created_at",
  { data_type => "timestamp", is_nullable => 0 },
  "min_lat",
  { data_type => "integer", is_nullable => 1 },
  "max_lat",
  { data_type => "integer", is_nullable => 1 },
  "min_lon",
  { data_type => "integer", is_nullable => 1 },
  "max_lon",
  { data_type => "integer", is_nullable => 1 },
  "closed_at",
  { data_type => "timestamp", is_nullable => 0 },
  "num_changes",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 changeset_tags

Type: has_many

Related object: L<OSM::API::OSMRailsPort::Schema::Result::ChangesetTag>

=cut

__PACKAGE__->has_many(
  "changeset_tags",
  "OSM::API::OSMRailsPort::Schema::Result::ChangesetTag",
  { "foreign.id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user

Type: belongs_to

Related object: L<OSM::API::OSMRailsPort::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "user",
  "OSM::API::OSMRailsPort::Schema::Result::User",
  { id => "user_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 current_nodes

Type: has_many

Related object: L<OSM::API::OSMRailsPort::Schema::Result::CurrentNode>

=cut

__PACKAGE__->has_many(
  "current_nodes",
  "OSM::API::OSMRailsPort::Schema::Result::CurrentNode",
  { "foreign.changeset_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 current_relations

Type: has_many

Related object: L<OSM::API::OSMRailsPort::Schema::Result::CurrentRelation>

=cut

__PACKAGE__->has_many(
  "current_relations",
  "OSM::API::OSMRailsPort::Schema::Result::CurrentRelation",
  { "foreign.changeset_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 current_ways

Type: has_many

Related object: L<OSM::API::OSMRailsPort::Schema::Result::CurrentWay>

=cut

__PACKAGE__->has_many(
  "current_ways",
  "OSM::API::OSMRailsPort::Schema::Result::CurrentWay",
  { "foreign.changeset_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 nodes

Type: has_many

Related object: L<OSM::API::OSMRailsPort::Schema::Result::Node>

=cut

__PACKAGE__->has_many(
  "nodes",
  "OSM::API::OSMRailsPort::Schema::Result::Node",
  { "foreign.changeset_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 relations

Type: has_many

Related object: L<OSM::API::OSMRailsPort::Schema::Result::Relation>

=cut

__PACKAGE__->has_many(
  "relations",
  "OSM::API::OSMRailsPort::Schema::Result::Relation",
  { "foreign.changeset_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 ways

Type: has_many

Related object: L<OSM::API::OSMRailsPort::Schema::Result::Way>

=cut

__PACKAGE__->has_many(
  "ways",
  "OSM::API::OSMRailsPort::Schema::Result::Way",
  { "foreign.changeset_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-07-23 17:08:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Ic1VSb6RrLkLaojDMWbohQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
