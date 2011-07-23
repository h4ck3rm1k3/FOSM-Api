package OSM::API::OSMRailsPort::Schema::Result::Message;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

OSM::API::OSMRailsPort::Schema::Result::Message

=cut

__PACKAGE__->table("messages");

=head1 ACCESSORS

=head2 id

  data_type: 'bigint'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'messages_id_seq'

=head2 from_user_id

  data_type: 'bigint'
  is_foreign_key: 1
  is_nullable: 0

=head2 title

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 body

  data_type: 'text'
  is_nullable: 0

=head2 sent_on

  data_type: 'timestamp'
  is_nullable: 0

=head2 message_read

  data_type: 'boolean'
  default_value: false
  is_nullable: 0

=head2 to_user_id

  data_type: 'bigint'
  is_foreign_key: 1
  is_nullable: 0

=head2 to_user_visible

  data_type: 'boolean'
  default_value: true
  is_nullable: 0

=head2 from_user_visible

  data_type: 'boolean'
  default_value: true
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "bigint",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "messages_id_seq",
  },
  "from_user_id",
  { data_type => "bigint", is_foreign_key => 1, is_nullable => 0 },
  "title",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "body",
  { data_type => "text", is_nullable => 0 },
  "sent_on",
  { data_type => "timestamp", is_nullable => 0 },
  "message_read",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
  "to_user_id",
  { data_type => "bigint", is_foreign_key => 1, is_nullable => 0 },
  "to_user_visible",
  { data_type => "boolean", default_value => \"true", is_nullable => 0 },
  "from_user_visible",
  { data_type => "boolean", default_value => \"true", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 to_user

Type: belongs_to

Related object: L<OSM::API::OSMRailsPort::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "to_user",
  "OSM::API::OSMRailsPort::Schema::Result::User",
  { id => "to_user_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 from_user

Type: belongs_to

Related object: L<OSM::API::OSMRailsPort::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "from_user",
  "OSM::API::OSMRailsPort::Schema::Result::User",
  { id => "from_user_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-07-23 17:08:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Ak1btRgIfUzjB3olLBhQBg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
