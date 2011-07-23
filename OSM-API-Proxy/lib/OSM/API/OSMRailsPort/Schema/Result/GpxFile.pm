package OSM::API::OSMRailsPort::Schema::Result::GpxFile;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

OSM::API::OSMRailsPort::Schema::Result::GpxFile

=cut

__PACKAGE__->table("gpx_files");

=head1 ACCESSORS

=head2 id

  data_type: 'bigint'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'gpx_files_id_seq'

=head2 user_id

  data_type: 'bigint'
  is_foreign_key: 1
  is_nullable: 0

=head2 visible

  data_type: 'boolean'
  default_value: true
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 size

  data_type: 'bigint'
  is_nullable: 1

=head2 latitude

  data_type: 'double precision'
  is_nullable: 1

=head2 longitude

  data_type: 'double precision'
  is_nullable: 1

=head2 timestamp

  data_type: 'timestamp'
  is_nullable: 0

=head2 description

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 inserted

  data_type: 'boolean'
  is_nullable: 0

=head2 visibility

  data_type: 'enum'
  default_value: 'public'
  extra: {custom_type_name => "gpx_visibility_enum",list => ["private","public","trackable","identifiable"]}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "bigint",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "gpx_files_id_seq",
  },
  "user_id",
  { data_type => "bigint", is_foreign_key => 1, is_nullable => 0 },
  "visible",
  { data_type => "boolean", default_value => \"true", is_nullable => 0 },
  "name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "size",
  { data_type => "bigint", is_nullable => 1 },
  "latitude",
  { data_type => "double precision", is_nullable => 1 },
  "longitude",
  { data_type => "double precision", is_nullable => 1 },
  "timestamp",
  { data_type => "timestamp", is_nullable => 0 },
  "description",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "inserted",
  { data_type => "boolean", is_nullable => 0 },
  "visibility",
  {
    data_type => "enum",
    default_value => "public",
    extra => {
      custom_type_name => "gpx_visibility_enum",
      list => ["private", "public", "trackable", "identifiable"],
    },
    is_nullable => 0,
  },
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 gps_points

Type: has_many

Related object: L<OSM::API::OSMRailsPort::Schema::Result::GpsPoint>

=cut

__PACKAGE__->has_many(
  "gps_points",
  "OSM::API::OSMRailsPort::Schema::Result::GpsPoint",
  { "foreign.gpx_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 gpx_file_tags

Type: has_many

Related object: L<OSM::API::OSMRailsPort::Schema::Result::GpxFileTag>

=cut

__PACKAGE__->has_many(
  "gpx_file_tags",
  "OSM::API::OSMRailsPort::Schema::Result::GpxFileTag",
  { "foreign.gpx_id" => "self.id" },
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


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-07-23 17:08:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:qHCeF7dTnzfU3rIE0DfEow


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
