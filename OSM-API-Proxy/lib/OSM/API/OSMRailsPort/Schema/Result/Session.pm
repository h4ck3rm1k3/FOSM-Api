package OSM::API::OSMRailsPort::Schema::Result::Session;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

OSM::API::OSMRailsPort::Schema::Result::Session

=cut

__PACKAGE__->table("sessions");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'sessions_id_seq'

=head2 session_id

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 data

  data_type: 'text'
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
    sequence          => "sessions_id_seq",
  },
  "session_id",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "data",
  { data_type => "text", is_nullable => 1 },
  "created_at",
  { data_type => "timestamp", is_nullable => 1 },
  "updated_at",
  { data_type => "timestamp", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("sessions_session_id_idx", ["session_id"]);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-07-23 17:08:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:oeC2pLtuQSz2bXFX1WhEaQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
