package OSM::API::OSMRailsPort::Schema::Result::OauthToken;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

OSM::API::OSMRailsPort::Schema::Result::OauthToken

=cut

__PACKAGE__->table("oauth_tokens");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'oauth_tokens_id_seq'

=head2 user_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 type

  data_type: 'varchar'
  is_nullable: 1
  size: 20

=head2 client_application_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 token

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 secret

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 authorized_at

  data_type: 'timestamp'
  is_nullable: 1

=head2 invalidated_at

  data_type: 'timestamp'
  is_nullable: 1

=head2 created_at

  data_type: 'timestamp'
  is_nullable: 1

=head2 updated_at

  data_type: 'timestamp'
  is_nullable: 1

=head2 allow_read_prefs

  data_type: 'boolean'
  default_value: false
  is_nullable: 0

=head2 allow_write_prefs

  data_type: 'boolean'
  default_value: false
  is_nullable: 0

=head2 allow_write_diary

  data_type: 'boolean'
  default_value: false
  is_nullable: 0

=head2 allow_write_api

  data_type: 'boolean'
  default_value: false
  is_nullable: 0

=head2 allow_read_gpx

  data_type: 'boolean'
  default_value: false
  is_nullable: 0

=head2 allow_write_gpx

  data_type: 'boolean'
  default_value: false
  is_nullable: 0

=head2 callback_url

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 verifier

  data_type: 'varchar'
  is_nullable: 1
  size: 20

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "oauth_tokens_id_seq",
  },
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "type",
  { data_type => "varchar", is_nullable => 1, size => 20 },
  "client_application_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "token",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "secret",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "authorized_at",
  { data_type => "timestamp", is_nullable => 1 },
  "invalidated_at",
  { data_type => "timestamp", is_nullable => 1 },
  "created_at",
  { data_type => "timestamp", is_nullable => 1 },
  "updated_at",
  { data_type => "timestamp", is_nullable => 1 },
  "allow_read_prefs",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
  "allow_write_prefs",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
  "allow_write_diary",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
  "allow_write_api",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
  "allow_read_gpx",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
  "allow_write_gpx",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
  "callback_url",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "verifier",
  { data_type => "varchar", is_nullable => 1, size => 20 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("index_oauth_tokens_on_token", ["token"]);

=head1 RELATIONS

=head2 client_application

Type: belongs_to

Related object: L<OSM::API::OSMRailsPort::Schema::Result::ClientApplication>

=cut

__PACKAGE__->belongs_to(
  "client_application",
  "OSM::API::OSMRailsPort::Schema::Result::ClientApplication",
  { id => "client_application_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 user

Type: belongs_to

Related object: L<OSM::API::OSMRailsPort::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "user",
  "OSM::API::OSMRailsPort::Schema::Result::User",
  { id => "user_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-07-23 17:08:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:uyo2aQRJWHeozF3fnDBq9Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
