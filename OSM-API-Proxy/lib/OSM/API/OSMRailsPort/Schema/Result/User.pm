package OSM::API::OSMRailsPort::Schema::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

OSM::API::OSMRailsPort::Schema::Result::User

=cut

__PACKAGE__->table("users");

=head1 ACCESSORS

=head2 email

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 id

  data_type: 'bigint'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'users_id_seq'

=head2 pass_crypt

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 creation_time

  data_type: 'timestamp'
  is_nullable: 0

=head2 display_name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 data_public

  data_type: 'boolean'
  default_value: false
  is_nullable: 0

=head2 description

  data_type: 'text'
  default_value: (empty string)
  is_nullable: 0

=head2 home_lat

  data_type: 'double precision'
  is_nullable: 1

=head2 home_lon

  data_type: 'double precision'
  is_nullable: 1

=head2 home_zoom

  data_type: 'smallint'
  default_value: 3
  is_nullable: 1

=head2 nearby

  data_type: 'integer'
  default_value: 50
  is_nullable: 1

=head2 pass_salt

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 image

  data_type: 'text'
  is_nullable: 1

=head2 email_valid

  data_type: 'boolean'
  default_value: false
  is_nullable: 0

=head2 new_email

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 creation_ip

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 languages

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 status

  data_type: 'enum'
  default_value: 'pending'
  extra: {custom_type_name => "user_status_enum",list => ["pending","active","confirmed","suspended","deleted"]}
  is_nullable: 0

=head2 terms_agreed

  data_type: 'timestamp'
  is_nullable: 1

=head2 consider_pd

  data_type: 'boolean'
  default_value: false
  is_nullable: 0

=head2 openid_url

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 preferred_editor

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 terms_seen

  data_type: 'boolean'
  default_value: false
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "email",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "id",
  {
    data_type         => "bigint",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "users_id_seq",
  },
  "pass_crypt",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "creation_time",
  { data_type => "timestamp", is_nullable => 0 },
  "display_name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "data_public",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
  "description",
  { data_type => "text", default_value => "", is_nullable => 0 },
  "home_lat",
  { data_type => "double precision", is_nullable => 1 },
  "home_lon",
  { data_type => "double precision", is_nullable => 1 },
  "home_zoom",
  { data_type => "smallint", default_value => 3, is_nullable => 1 },
  "nearby",
  { data_type => "integer", default_value => 50, is_nullable => 1 },
  "pass_salt",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "image",
  { data_type => "text", is_nullable => 1 },
  "email_valid",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
  "new_email",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "creation_ip",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "languages",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "status",
  {
    data_type => "enum",
    default_value => "pending",
    extra => {
      custom_type_name => "user_status_enum",
      list => ["pending", "active", "confirmed", "suspended", "deleted"],
    },
    is_nullable => 0,
  },
  "terms_agreed",
  { data_type => "timestamp", is_nullable => 1 },
  "consider_pd",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
  "openid_url",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "preferred_editor",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "terms_seen",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("user_openid_url_idx", ["openid_url"]);
__PACKAGE__->add_unique_constraint("users_display_name_idx", ["display_name"]);
__PACKAGE__->add_unique_constraint("users_email_idx", ["email"]);

=head1 RELATIONS

=head2 changesets

Type: has_many

Related object: L<OSM::API::OSMRailsPort::Schema::Result::Changeset>

=cut

__PACKAGE__->has_many(
  "changesets",
  "OSM::API::OSMRailsPort::Schema::Result::Changeset",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 client_applications

Type: has_many

Related object: L<OSM::API::OSMRailsPort::Schema::Result::ClientApplication>

=cut

__PACKAGE__->has_many(
  "client_applications",
  "OSM::API::OSMRailsPort::Schema::Result::ClientApplication",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 diary_comments

Type: has_many

Related object: L<OSM::API::OSMRailsPort::Schema::Result::DiaryComment>

=cut

__PACKAGE__->has_many(
  "diary_comments",
  "OSM::API::OSMRailsPort::Schema::Result::DiaryComment",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 diary_entries

Type: has_many

Related object: L<OSM::API::OSMRailsPort::Schema::Result::DiaryEntry>

=cut

__PACKAGE__->has_many(
  "diary_entries",
  "OSM::API::OSMRailsPort::Schema::Result::DiaryEntry",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 friends_users

Type: has_many

Related object: L<OSM::API::OSMRailsPort::Schema::Result::Friend>

=cut

__PACKAGE__->has_many(
  "friends_users",
  "OSM::API::OSMRailsPort::Schema::Result::Friend",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 friends_friend_users

Type: has_many

Related object: L<OSM::API::OSMRailsPort::Schema::Result::Friend>

=cut

__PACKAGE__->has_many(
  "friends_friend_users",
  "OSM::API::OSMRailsPort::Schema::Result::Friend",
  { "foreign.friend_user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 gpx_files

Type: has_many

Related object: L<OSM::API::OSMRailsPort::Schema::Result::GpxFile>

=cut

__PACKAGE__->has_many(
  "gpx_files",
  "OSM::API::OSMRailsPort::Schema::Result::GpxFile",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 messages_to_users

Type: has_many

Related object: L<OSM::API::OSMRailsPort::Schema::Result::Message>

=cut

__PACKAGE__->has_many(
  "messages_to_users",
  "OSM::API::OSMRailsPort::Schema::Result::Message",
  { "foreign.to_user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 messages_from_user

Type: has_many

Related object: L<OSM::API::OSMRailsPort::Schema::Result::Message>

=cut

__PACKAGE__->has_many(
  "messages_from_user",
  "OSM::API::OSMRailsPort::Schema::Result::Message",
  { "foreign.from_user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 oauth_tokens

Type: has_many

Related object: L<OSM::API::OSMRailsPort::Schema::Result::OauthToken>

=cut

__PACKAGE__->has_many(
  "oauth_tokens",
  "OSM::API::OSMRailsPort::Schema::Result::OauthToken",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user_blocks_users

Type: has_many

Related object: L<OSM::API::OSMRailsPort::Schema::Result::UserBlock>

=cut

__PACKAGE__->has_many(
  "user_blocks_users",
  "OSM::API::OSMRailsPort::Schema::Result::UserBlock",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user_blocks_creators

Type: has_many

Related object: L<OSM::API::OSMRailsPort::Schema::Result::UserBlock>

=cut

__PACKAGE__->has_many(
  "user_blocks_creators",
  "OSM::API::OSMRailsPort::Schema::Result::UserBlock",
  { "foreign.creator_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user_blocks_revokers

Type: has_many

Related object: L<OSM::API::OSMRailsPort::Schema::Result::UserBlock>

=cut

__PACKAGE__->has_many(
  "user_blocks_revokers",
  "OSM::API::OSMRailsPort::Schema::Result::UserBlock",
  { "foreign.revoker_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user_preferences

Type: has_many

Related object: L<OSM::API::OSMRailsPort::Schema::Result::UserPreference>

=cut

__PACKAGE__->has_many(
  "user_preferences",
  "OSM::API::OSMRailsPort::Schema::Result::UserPreference",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user_roles_granters

Type: has_many

Related object: L<OSM::API::OSMRailsPort::Schema::Result::UserRole>

=cut

__PACKAGE__->has_many(
  "user_roles_granters",
  "OSM::API::OSMRailsPort::Schema::Result::UserRole",
  { "foreign.granter_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user_roles_users

Type: has_many

Related object: L<OSM::API::OSMRailsPort::Schema::Result::UserRole>

=cut

__PACKAGE__->has_many(
  "user_roles_users",
  "OSM::API::OSMRailsPort::Schema::Result::UserRole",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user_tokens

Type: has_many

Related object: L<OSM::API::OSMRailsPort::Schema::Result::UserToken>

=cut

__PACKAGE__->has_many(
  "user_tokens",
  "OSM::API::OSMRailsPort::Schema::Result::UserToken",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-07-23 17:08:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:L0Be0KU457kpdojF6bLCkA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
