package OSM::API::OSMRailsPort::Schema::Result::DiaryComment;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

OSM::API::OSMRailsPort::Schema::Result::DiaryComment

=cut

__PACKAGE__->table("diary_comments");

=head1 ACCESSORS

=head2 id

  data_type: 'bigint'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'diary_comments_id_seq'

=head2 diary_entry_id

  data_type: 'bigint'
  is_foreign_key: 1
  is_nullable: 0

=head2 user_id

  data_type: 'bigint'
  is_foreign_key: 1
  is_nullable: 0

=head2 body

  data_type: 'text'
  is_nullable: 0

=head2 created_at

  data_type: 'timestamp'
  is_nullable: 0

=head2 updated_at

  data_type: 'timestamp'
  is_nullable: 0

=head2 visible

  data_type: 'boolean'
  default_value: true
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "bigint",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "diary_comments_id_seq",
  },
  "diary_entry_id",
  { data_type => "bigint", is_foreign_key => 1, is_nullable => 0 },
  "user_id",
  { data_type => "bigint", is_foreign_key => 1, is_nullable => 0 },
  "body",
  { data_type => "text", is_nullable => 0 },
  "created_at",
  { data_type => "timestamp", is_nullable => 0 },
  "updated_at",
  { data_type => "timestamp", is_nullable => 0 },
  "visible",
  { data_type => "boolean", default_value => \"true", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("diary_comments_entry_id_idx", ["diary_entry_id", "id"]);

=head1 RELATIONS

=head2 diary_entry

Type: belongs_to

Related object: L<OSM::API::OSMRailsPort::Schema::Result::DiaryEntry>

=cut

__PACKAGE__->belongs_to(
  "diary_entry",
  "OSM::API::OSMRailsPort::Schema::Result::DiaryEntry",
  { id => "diary_entry_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
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


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-07-23 17:08:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:YcJKz9JLwKZz8DH121eZhw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
