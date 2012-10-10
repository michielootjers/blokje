package Blokje::Controller::Quiz::Master;
use Moose;
use namespace::autoclean;

use Data::Dumper;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

Blokje::Controller::Quiz::Master - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut


sub base : Chained('/quiz/base') : PathPart('master') : CaptureArgs(0) {
    my ($self, $c) = @_;

    my $master  = {};
    $c->stash->{json}->{master} = $master;

    my $questions     = $c->model('DB::QuizQuestion')->search();

    my (@questions, $active_question);
    while (my $question = $questions->next) {
        push(@questions, $question->question);
        if ($question->active) {
            $active_question = $question;
        }
    }

    $master->{active_question}  = $active_question->question;
    $master->{questions}        = \@questions;

    my $teams               = $c->model('DB::QuizTeam')->search();

    my @teams;
    while (my $team = $teams->next) {
        push(@teams, $team->team);
    }

    $master->{teams}        = {};

    $c->log->debug(Dumper($c->stash->{json}));
}

sub index : Chained('base') : PathPart('') : Args(0) {}


sub load_question : Private {
    my ($self, $c) = @_;

    return unless $c->req->params->{question};
    my $master  = $c->stash->{json}->{master};

    my $question    = $c->model('DB::QuizQuestion')->search(
        {
            question => $c->req->params->{question},
        }
    )->first;

    return unless $question;

    $master->{question} = {
        active      => $question->active,
        question    => $question->question,
        teams       => {},
    };

    my $options     = $question->quiz_options->search();

    my @options;
    while (my $option = $options->next) {
        push(@options, $option->option);
    }

    $master->{question}->{options} = \@options;

    my $teamlist           = {};
    my $answers         = $question->quiz_answers->search();

    while (my $answer   = $answers->next) {
        $teamlist->{ $answer->team } = {
            answer  => 1,
            correct => $answer->option_id->correct,
        };
    }

    my $teams               = $c->model('DB::QuizTeam')->search();

    while (my $team = $teams->next) {
        unless (defined($teamlist->{ $team->team })) {
            $teamlist->{ $team->team } = {
                answer  => 0,
                correct => 0
            };
        }
    }

    $master->{question}->{teams} = $teamlist;
    $c->log->debug(Dumper($master));
}

sub question
    :Chained('base')
    :PathPart('question')
    :Args(0)
{
    my ($self, $c) = @_;

    $c->forward('load_question');
}

sub activate_question
    :Chained('base')
    :PathPart('question/activate')
    :Args(0)
{
    my ($self, $c) = @_;

    $c->forward('load_question');

    return unless $c->req->params->{question};

    my $question    = $c->model('DB::QuizQuestion')->search(
        {
            question => $c->req->params->{question},
        }
    )->first;

    return unless $question;

    my $questions   = $c->model('DB::QuizQuestion')->search(
        {
            active  => 1,
            id      => { '!='   => $question->id }
        }
    );

    while (my $oldquestion = $questions->next) {
        $oldquestion->active(0);
        $oldquestion->update;
    }

    $question->active(1);
    $question->update;

    $c->stash->{json}->{result} = 1;
}




=head1 AUTHOR

Michiel Ootjers,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

