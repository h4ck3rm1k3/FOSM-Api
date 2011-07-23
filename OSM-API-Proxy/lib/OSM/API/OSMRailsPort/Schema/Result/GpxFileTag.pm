package OSM::API::OSMRailsPort::Schema::Result::GpxFileTag;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

OSM::API::OSMRailsPort::Schema::Result::GpxFileTag

=cut

__PACKAGE__->table("gpx_file_tags");

=head1 ACCESSORS

=head2 gpx_id

  data_type: 'bigint'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 tag

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 id

  data_type: 'bigint'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'gpx_file_tags_id_seq'

=cut

__PACKAGE__->add_columns(
  "gpx_id",
  {
    data_type      => "bigint",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "tag",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "id",
  {
    data_type         => "bigint",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "gpx_file_tags_id_seq",
  },
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 gpx

Type: belongs_to

Related object: L<OSM::API::OSMRailsPort::Schema::Result::GpxFile>

=cut

__PACKAGE__->belongs_to(
  "gpx",
  "OSM::API::OSMRailsPort::Schema::Result::GpxFile",
  { id => "gpx_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-07-23 17:08:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:STcRcvRS6SujgO2eUXcshw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
