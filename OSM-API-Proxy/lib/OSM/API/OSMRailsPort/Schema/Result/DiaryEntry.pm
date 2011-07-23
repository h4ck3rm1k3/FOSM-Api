package OSM::API::OSMRailsPort::Schema::Result::DiaryEntry;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

OSM::API::OSMRailsPort::Schema::Result::DiaryEntry

=cut

__PACKAGE__->table("diary_entries");

=head1 ACCESSORS

=head2 id

  data_type: 'bigint'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'diary_entries_id_seq'

=head2 user_id

  data_type: 'bigint'
  is_foreign_key: 1
  is_nullable: 0

=head2 title

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 body

  data_type: 'text'
  is_nullable: 0

=head2 created_at

  data_type: 'timestamp'
  is_nullable: 0

=head2 updated_at

  data_type: 'timestamp'
  is_nullable: 0

=head2 latitude

  data_type: 'double precision'
  is_nullable: 1

=head2 longitude

  data_type: 'double precision'
  is_nullable: 1

=head2 language_code

  data_type: 'varchar'
  default_value: 'en'
  is_foreign_key: 1
  is_nullable: 0
  size: 255

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
    sequence          => "diary_entries_id_seq",
  },
  "user_id",
  { data_type => "bigint", is_foreign_key => 1, is_nullable => 0 },
  "title",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "body",
  { data_type => "text", is_nullable => 0 },
  "created_at",
  { data_type => "timestamp", is_nullable => 0 },
  "updated_at",
  { data_type => "timestamp", is_nullable => 0 },
  "latitude",
  { data_type => "double precision", is_nullable => 1 },
  "longitude",
  { data_type => "double precision", is_nullable => 1 },
  "language_code",
  {
    data_type => "varchar",
    default_value => "en",
    is_foreign_key => 1,
    is_nullable => 0,
    size => 255,
  },
  "visible",
  { data_type => "boolean", default_value => \"true", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 diary_comments

Type: has_many

Related object: L<OSM::API::OSMRailsPort::Schema::Result::DiaryComment>

=cut

__PACKAGE__->has_many(
  "diary_comments",
  "OSM::API::OSMRailsPort::Schema::Result::DiaryComment",
  { "foreign.diary_entry_id" => "self.id" },
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

=head2 language_code

Type: belongs_to

Related object: L<OSM::API::OSMRailsPort::Schema::Result::Language>

=cut

__PACKAGE__->belongs_to(
  "language_code",
  "OSM::API::OSMRailsPort::Schema::Result::Language",
  { code => "language_code" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-07-23 17:08:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:iZwda9fnjbQugzj2O3lj+g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
