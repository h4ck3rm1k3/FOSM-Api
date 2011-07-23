package OSM::API::OSMRailsPort::Schema::Result::GpsPoint;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

OSM::API::OSMRailsPort::Schema::Result::GpsPoint

=cut

__PACKAGE__->table("gps_points");

=head1 ACCESSORS

=head2 altitude

  data_type: 'double precision'
  is_nullable: 1

=head2 trackid

  data_type: 'integer'
  is_nullable: 0

=head2 latitude

  data_type: 'integer'
  is_nullable: 0

=head2 longitude

  data_type: 'integer'
  is_nullable: 0

=head2 gpx_id

  data_type: 'bigint'
  is_foreign_key: 1
  is_nullable: 0

=head2 timestamp

  data_type: 'timestamp'
  is_nullable: 0

=head2 tile

  data_type: 'bigint'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "altitude",
  { data_type => "double precision", is_nullable => 1 },
  "trackid",
  { data_type => "integer", is_nullable => 0 },
  "latitude",
  { data_type => "integer", is_nullable => 0 },
  "longitude",
  { data_type => "integer", is_nullable => 0 },
  "gpx_id",
  { data_type => "bigint", is_foreign_key => 1, is_nullable => 0 },
  "timestamp",
  { data_type => "timestamp", is_nullable => 0 },
  "tile",
  { data_type => "bigint", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("trackid", "gpx_id", "timestamp");

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


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-07-23 17:32:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Vp7+WAplrOAsYqyXUYel8Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
