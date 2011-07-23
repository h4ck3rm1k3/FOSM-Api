package OSM::API::OSMRailsPort::Schema::Result::Country;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

OSM::API::OSMRailsPort::Schema::Result::Country

=cut

__PACKAGE__->table("countries");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'countries_id_seq'

=head2 code

  data_type: 'varchar'
  is_nullable: 0
  size: 2

=head2 min_lat

  data_type: 'double precision'
  is_nullable: 0

=head2 max_lat

  data_type: 'double precision'
  is_nullable: 0

=head2 min_lon

  data_type: 'double precision'
  is_nullable: 0

=head2 max_lon

  data_type: 'double precision'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "countries_id_seq",
  },
  "code",
  { data_type => "varchar", is_nullable => 0, size => 2 },
  "min_lat",
  { data_type => "double precision", is_nullable => 0 },
  "max_lat",
  { data_type => "double precision", is_nullable => 0 },
  "min_lon",
  { data_type => "double precision", is_nullable => 0 },
  "max_lon",
  { data_type => "double precision", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("countries_code_idx", ["code"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-07-23 17:08:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:k3iRAeivSk9q1Esse4bgwQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
