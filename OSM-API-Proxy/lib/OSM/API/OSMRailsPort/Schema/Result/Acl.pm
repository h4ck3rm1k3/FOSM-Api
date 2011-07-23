package OSM::API::OSMRailsPort::Schema::Result::Acl;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

OSM::API::OSMRailsPort::Schema::Result::Acl

=cut

__PACKAGE__->table("acls");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'acls_id_seq'

=head2 address

  data_type: 'inet'
  is_nullable: 0

=head2 netmask

  data_type: 'inet'
  is_nullable: 0

=head2 k

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 v

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "acls_id_seq",
  },
  "address",
  { data_type => "inet", is_nullable => 0 },
  "netmask",
  { data_type => "inet", is_nullable => 0 },
  "k",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "v",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-07-23 17:08:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:XHAOtUIJ5ri5h9LTym843Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
