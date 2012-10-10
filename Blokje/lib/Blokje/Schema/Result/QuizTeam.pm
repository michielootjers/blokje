package Blokje::Schema::Result::QuizTeam;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(
  "InflateColumn::DateTime",
  "InflateColumn::DateTime",
  "TimeStamp",
  "Core",
);
__PACKAGE__->table("quiz_team");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "integer",
    default_value => "nextval('quiz_team_id_seq'::regclass)",
    is_nullable => 0,
    size => 4,
  },
  "team",
  {
    data_type => "text",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("quiz_team_pkey", ["id"]);


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2012-10-08 21:18:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:b+OWxhYzoJb9/YNHELDXuQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
