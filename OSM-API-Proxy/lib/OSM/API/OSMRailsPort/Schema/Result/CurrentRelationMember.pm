package OSM::API::OSMRailsPort::Schema::Result::CurrentRelationMember;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

OSM::API::OSMRailsPort::Schema::Result::CurrentRelationMember

=cut

__PACKAGE__->table("current_relation_members");

=head1 ACCESSORS

=head2 id

  data_type: 'bigint'
  is_foreign_key: 1
  is_nullable: 0

=head2 member_type

  data_type: 'enum'
  extra: {custom_type_name => "nwr_enum",list => ["Node","Way","Relation"]}
  is_nullable: 0

=head2 member_id

  data_type: 'bigint'
  is_nullable: 0

=head2 member_role

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 sequence_id

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "bigint", is_foreign_key => 1, is_nullable => 0 },
  "member_type",
  {
    data_type => "enum",
    extra => { custom_type_name => "nwr_enum", list => ["Node", "Way", "Relation"] },
    is_nullable => 0,
  },
  "member_id",
  { data_type => "bigint", is_nullable => 0 },
  "member_role",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "sequence_id",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id", "member_type", "member_id", "member_role", "sequence_id");

=head1 RELATIONS

=head2 id

Type: belongs_to

Related object: L<OSM::API::OSMRailsPort::Schema::Result::CurrentRelation>

=cut

__PACKAGE__->belongs_to(
  "id",
  "OSM::API::OSMRailsPort::Schema::Result::CurrentRelation",
  { id => "id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-07-23 17:08:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:z0k333wAX0D1OJlAbrOkbw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
