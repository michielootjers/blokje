package Blokje::Model::DB;

use strict;
use base 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
    schema_class => 'Blokje::Schema',
    
    connect_info => {
        dsn => 'dbi:Pg:dbname=blokje',
        user => '',
        password => '',
    }
);

=head1 NAME

Blokje::Model::DB - Catalyst DBIC Schema Model

=head1 SYNOPSIS

See L<Blokje>

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema L<Blokje::Schema>

=head1 GENERATED BY

Catalyst::Helper::Model::DBIC::Schema - 0.38

=head1 AUTHOR

Michiel Ootjers

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
