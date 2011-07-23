package OSM::API::OSMRailsPort::Schema::Result::UserPreference;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

OSM::API::OSMRailsPort::Schema::Result::UserPreference

=cut

__PACKAGE__->table("user_preferences");

=head1 ACCESSORS

=head2 user_id

  data_type: 'bigint'
  is_foreign_key: 1
  is_nullable: 0

=head2 k

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 v

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=cut

__PACKAGE__->add_columns(
  "user_id",
  { data_type => "bigint", is_foreign_key => 1, is_nullable => 0 },
  "k",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "v",
  { data_type => "varchar", is_nullable => 0, size => 255 },
);
__PACKAGE__->set_primary_key("user_id", "k");

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


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-07-23 17:08:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Py44ip/5ZOMS9sGxkQto5A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
