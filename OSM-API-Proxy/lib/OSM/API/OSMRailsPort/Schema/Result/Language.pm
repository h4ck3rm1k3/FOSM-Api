package OSM::API::OSMRailsPort::Schema::Result::Language;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

OSM::API::OSMRailsPort::Schema::Result::Language

=cut

__PACKAGE__->table("languages");

=head1 ACCESSORS

=head2 code

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 english_name

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 native_name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "code",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "english_name",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "native_name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);
__PACKAGE__->set_primary_key("code");

=head1 RELATIONS

=head2 diary_entries

Type: has_many

Related object: L<OSM::API::OSMRailsPort::Schema::Result::DiaryEntry>

=cut

__PACKAGE__->has_many(
  "diary_entries",
  "OSM::API::OSMRailsPort::Schema::Result::DiaryEntry",
  { "foreign.language_code" => "self.code" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-07-23 17:08:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:W7PwjZIO3ZGMSXB/n45Vpw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
