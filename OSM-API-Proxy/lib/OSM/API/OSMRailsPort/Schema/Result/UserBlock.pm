package OSM::API::OSMRailsPort::Schema::Result::UserBlock;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

OSM::API::OSMRailsPort::Schema::Result::UserBlock

=cut

__PACKAGE__->table("user_blocks");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'user_blocks_id_seq'

=head2 user_id

  data_type: 'bigint'
  is_foreign_key: 1
  is_nullable: 0

=head2 creator_id

  data_type: 'bigint'
  is_foreign_key: 1
  is_nullable: 0

=head2 reason

  data_type: 'text'
  is_nullable: 0

=head2 ends_at

  data_type: 'timestamp'
  is_nullable: 0

=head2 needs_view

  data_type: 'boolean'
  default_value: false
  is_nullable: 0

=head2 revoker_id

  data_type: 'bigint'
  is_foreign_key: 1
  is_nullable: 1

=head2 created_at

  data_type: 'timestamp'
  is_nullable: 1

=head2 updated_at

  data_type: 'timestamp'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "user_blocks_id_seq",
  },
  "user_id",
  { data_type => "bigint", is_foreign_key => 1, is_nullable => 0 },
  "creator_id",
  { data_type => "bigint", is_foreign_key => 1, is_nullable => 0 },
  "reason",
  { data_type => "text", is_nullable => 0 },
  "ends_at",
  { data_type => "timestamp", is_nullable => 0 },
  "needs_view",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
  "revoker_id",
  { data_type => "bigint", is_foreign_key => 1, is_nullable => 1 },
  "created_at",
  { data_type => "timestamp", is_nullable => 1 },
  "updated_at",
  { data_type => "timestamp", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

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

=head2 creator

Type: belongs_to

Related object: L<OSM::API::OSMRailsPort::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "creator",
  "OSM::API::OSMRailsPort::Schema::Result::User",
  { id => "creator_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 revoker

Type: belongs_to

Related object: L<OSM::API::OSMRailsPort::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "revoker",
  "OSM::API::OSMRailsPort::Schema::Result::User",
  { id => "revoker_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-07-23 17:08:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:mX5ZcmfiSjFSl4ddd03mlg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
