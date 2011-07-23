package OSM::API::OSMRailsPort::Schema::Result::OauthNonce;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

OSM::API::OSMRailsPort::Schema::Result::OauthNonce

=cut

__PACKAGE__->table("oauth_nonces");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'oauth_nonces_id_seq'

=head2 nonce

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 timestamp

  data_type: 'integer'
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
    sequence          => "oauth_nonces_id_seq",
  },
  "nonce",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "timestamp",
  { data_type => "integer", is_nullable => 1 },
  "created_at",
  { data_type => "timestamp", is_nullable => 1 },
  "updated_at",
  { data_type => "timestamp", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint(
  "index_oauth_nonces_on_nonce_and_timestamp",
  ["nonce", "timestamp"],
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-07-23 17:08:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:QZqQR9zINeDySwRyt/jtGA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
