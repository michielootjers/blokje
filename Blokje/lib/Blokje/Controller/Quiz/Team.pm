package Blokje::Controller::Quiz::Team;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller::REST'; }

__PACKAGE__->config(
    map     => {
        'text/html'         => [ 'View', 'TT' ],
        'application/json'  => [ 'View', 'JSON' ],
    },
);

=head1 NAME

Blokje::Controller::Quiz::Team - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub base : Chained('/quiz/base') : PathPart('team') : CaptureArgs(0) {}

sub update : Chained('base') : PathPart('update') : Args(0) {
    my ($self, $c) = @_;

    if (
        $c->req->params->{name}
    ) {
        $c->session->{quiz}->{team} = $c->req->params->{name};
        $c->model('DB::QuizTeam')->search({team => $c->req->params->{name}
            })->delete;
        $c->model('DB::QuizTeam')->create({team => $c->req->params->{name} });

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

