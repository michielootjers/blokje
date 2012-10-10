package Blokje::Controller::Quiz;
use Moose;
use namespace::autoclean;

use Data::Dumper;

BEGIN {extends 'Catalyst::Controller::REST'; }

__PACKAGE__->config(
    map     => {
        'text/html'         => [ 'View', 'TT' ],
        'application/json'  => [ 'View', 'JSON' ],
    },
);

=head1 NAME

Blokje::Controller::Quiz - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

sub base : Chained('/') : PathPart('quiz') : CaptureArgs(0) {
    my ($self, $c)  = @_;

    $c->session->{quiz};

    $c->stash->{json}   = {
        team        => $c->session->{quiz}->{team},
    };

    if ($c->stash->{json}->{team}) {
        if (
            !$c->model('DB::QuizTeam')
                ->search(
                    {team=>$c->session->{quiz}->{team}}
                )->count
        ) {
            $c->delete_session;
            $c->stash->{json}->{team} = undef;
        } else {
            $c->stash->{json}->{question} = $c->forward('load_question');
        }
    }
    
    $c->log->debug(
        'JSON' . Dumper($c->stash->{json})
    );
}


sub index : Chained('base') : PathPart('') : Args(0) {
    my ($self, $c) = @_;

    $c->stash->{template}       = 'quiz/index.tt';
}

sub load_question : Private {
    my ($self, $c) = @_;

    $c->log->debug('load_question: load question');
    my $question    = $c->model('DB::QuizQuestion')->search({active => 1})->first;

    return unless $question;

    $c->log->debug('load_question: load options');

    my $options     = $question->quiz_options->search();

    return unless $options->count;

    ### Check if team has already given an answer
    $c->log->debug('load_question: check team answer');
    my $answer      = $c->model('DB::QuizAnswer')->search(
        {
            question_id => $question->id,
            team        => $c->session->{quiz}->{team}
        }
    );

    return if $answer->count;

    $c->log->debug('load_question: return question');
    my @options;
    while (my $option = $options->next) {
        push(@options, $option->option);
    }

    return {
        question    => $question->question,
        options     => \@options
    }
}

sub answer_update : Chained('base') : PathPart('answer/update') {
    my ($self, $c) = @_;

    return unless (
        $c->req->params->{question} &&
        $c->req->params->{answer}
    );

    my $question    = $c->model('DB::QuizQuestion')->search(
        {
            question => $c->req->params->{question},
        }
    )->first;

    return unless $question;

    my $option      = $question->quiz_options->search(
        {
            option => $c->req->params->{answer},
        }
    )->first;

    return unless $option;

    my $current_answer  = $option->quiz_answers->search(
        {
            question_id => $question->id,
            team        => $c->session->{quiz}->{team}
        }
    );

    return if $current_answer->count;

    my $answer          = $c->model('DB::QuizAnswer')->create(
        {
            question_id => $question->id,
            option_id   => $option->id,
            team        => $c->session->{quiz}->{team},
        }
    );

    if ($answer) {
        $c->stash->{json}->{result} = 1;
    }
}





=head1 AUTHOR

Michiel Ootjers,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

