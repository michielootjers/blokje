package Blokje::Schema::Result::QuizQuestion;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(
  "InflateColumn::DateTime",
  "InflateColumn::DateTime",
  "TimeStamp",
  "Core",
);
__PACKAGE__->table("quiz_question");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "integer",
    default_value => "nextval('quiz_question_id_seq'::regclass)",
    is_nullable => 0,
    size => 4,
  },
  "question",
  {
    data_type => "text",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "active",
  { data_type => "integer", default_value => undef, is_nullable => 1, size => 4 },
  "order_by",
  { data_type => "integer", default_value => undef, is_nullable => 1, size => 4 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("quiz_question_pkey", ["id"]);
__PACKAGE__->has_many(
  "quiz_answers",
  "Blokje::Schema::Result::QuizAnswer",
  { "foreign.question_id" => "self.id" },
);
__PACKAGE__->has_many(
  "quiz_options",
  "Blokje::Schema::Result::QuizOption",
  { "foreign.question_id" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2012-10-08 21:18:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:y/L5u8yxksUeDL3xiZa4+A


# You can replace this text with custom content, and it will be preserved on regeneration
1;
