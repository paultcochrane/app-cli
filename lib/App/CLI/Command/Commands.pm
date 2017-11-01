package App::CLI::Command::Commands;

use strict;
use warnings;

use base qw/App::CLI::Command/;

=head1 NAME

App::CLI::Command::Commands - Print a list of commands for your app

=head1 SYNOPSIS

    package MyApp;
    use base qw(App::CLI App::CLI::Command);

    # Make your app get a list of commands
    use constant alias => (
        commands => '+App::CLI::Command::Commands',
    );

    1;

=head1 DESCRIPTION

Print a list of commands registered for your application;

=cut

sub run {
    my ($self) = shift;

    my ($longest) = sort { length($b) cmp length($a) } $self->app->commands;
    $longest = length $longest;

    foreach ( $self->app->commands ) {
        my $cmd        = $self->app->get_cmd($_);
        my @components = split /::/, ref $cmd;
        my $name       = lc pop @components;
        printf "    %${longest}s\n", $name;
    }
}

1;
