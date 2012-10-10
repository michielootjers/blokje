package Blokje::Schema::Result::QuizAnswer;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(
  "InflateColumn::DateTime",
  "InflateColumn::DateTime",
  "TimeStamp",
  "Core",
);
__PACKAGE__->table("quiz_answer");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "integer",
    default_value => "nextval('quiz_answer_id_seq'::regclass)",
    is_nullable => 0,
    size => 4,
  },
  "question_id",
  { data_type => "integer", default_value => undef, is_nullable => 1, size => 4 },
  "option_id",
  { data_type => "integer", default_value => undef, is_nullable => 1, size => 4 },
  "order_by",
  { data_type => "integer", default_value => undef, is_nullable => 1, size => 4 },
  "team",
  {
    data_type => "text",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("quiz_answer_pkey", ["id"]);
__PACKAGE__->belongs_to(
  "question_id",
  "Blokje::Schema::Result::QuizQuestion",
  { id => "question_id" },
);
__PACKAGE__->belongs_to(
  "option_id",
  "Blokje::Schema::Result::QuizOption",
  { id => "option_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2012-10-08 21:18:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:K2JFeeswPEpxqqbtF5/oBg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
