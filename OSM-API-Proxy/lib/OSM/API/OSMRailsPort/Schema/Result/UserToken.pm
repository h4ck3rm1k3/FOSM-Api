package OSM::API::OSMRailsPort::Schema::Result::UserToken;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

OSM::API::OSMRailsPort::Schema::Result::UserToken

=cut

__PACKAGE__->table("user_tokens");

=head1 ACCESSORS

=head2 id

  data_type: 'bigint'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'user_tokens_id_seq'

=head2 user_id

  data_type: 'bigint'
  is_foreign_key: 1
  is_nullable: 0

=head2 token

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 expiry

  data_type: 'timestamp'
  is_nullable: 0

=head2 referer

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "bigint",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "user_tokens_id_seq",
  },
  "user_id",
  { data_type => "bigint", is_foreign_key => 1, is_nullable => 0 },
  "token",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "expiry",
  { data_type => "timestamp", is_nullable => 0 },
  "referer",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("user_tokens_token_idx", ["token"]);

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
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:up/PkgcLc6ABmZ8COFtnPg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
