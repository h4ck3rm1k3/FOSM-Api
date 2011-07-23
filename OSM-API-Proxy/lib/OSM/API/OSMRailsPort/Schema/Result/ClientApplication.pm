package OSM::API::OSMRailsPort::Schema::Result::ClientApplication;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

OSM::API::OSMRailsPort::Schema::Result::ClientApplication

=cut

__PACKAGE__->table("client_applications");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'client_applications_id_seq'

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 url

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 support_url

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 callback_url

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 key

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 secret

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 user_id

  data_type: 'integer'
  is_foreign_key: 1
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

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "client_applications_id_seq",
  },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "url",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "support_url",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "callback_url",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "key",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "secret",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
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
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("index_client_applications_on_key", ["key"]);

=head1 RELATIONS

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

=head2 oauth_tokens

Type: has_many

Related object: L<OSM::API::OSMRailsPort::Schema::Result::OauthToken>

=cut

__PACKAGE__->has_many(
  "oauth_tokens",
  "OSM::API::OSMRailsPort::Schema::Result::OauthToken",
  { "foreign.client_application_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-07-23 17:08:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:eyjwGOLj8+BfZgNilBXZ/w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
