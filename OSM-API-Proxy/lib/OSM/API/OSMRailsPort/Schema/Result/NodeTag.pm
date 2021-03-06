package OSM::API::OSMRailsPort::Schema::Result::NodeTag;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

OSM::API::OSMRailsPort::Schema::Result::NodeTag

=cut

__PACKAGE__->table("node_tags");

=head1 ACCESSORS

=head2 id

  data_type: 'bigint'
  is_foreign_key: 1
  is_nullable: 0

=head2 version

  data_type: 'bigint'
  is_foreign_key: 1
  is_nullable: 0

=head2 k

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 v

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "bigint", is_foreign_key => 1, is_nullable => 0 },
  "version",
  { data_type => "bigint", is_foreign_key => 1, is_nullable => 0 },
  "k",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "v",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
);
__PACKAGE__->set_primary_key("id", "version", "k");

=head1 RELATIONS

=head2 node

Type: belongs_to

Related object: L<OSM::API::OSMRailsPort::Schema::Result::Node>

=cut

__PACKAGE__->belongs_to(
  "node",
  "OSM::API::OSMRailsPort::Schema::Result::Node",
  { id => "id", version => "version" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-07-23 17:08:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:5qN6MksVkJM9tldz8Bok5w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
