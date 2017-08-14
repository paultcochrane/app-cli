package App::CLI::Command::Help;

use strict;
use warnings;

use base qw/App::CLI::Command/;

use File::Find qw(find);
use Locale::Maketext::Simple;
use Pod::Simple::Text;
use Class::Load qw( load_class );

=head1 NAME

App::CLI::Command::Help

=head1 SYNOPSIS

    package MyApp::Help;
    use base qw(App::CLI::Command::Help);

    sub run {
        my $self = shift;
        # preprocess
        $self->SUPER::run(@_);  # App::CLI::Command::Help would output POD of each command
    }

=head1 DESCRIPTION

Your command class should be capitalized.

To add help message, just add POD in the command class:

    package YourApp::Command::Foo;


    =head1 NAME

    YourApp::Command::Foo - execute foo

    =head1 DESCRIPTION

    blah blah

    =head1 USAGE

    ....

    =cut

=cut

sub run {
    my $self = shift;
    my @topics = @_;

    return $self->app->usage unless @topics;
    return $self->app->get_cmd($_)->usage foreach @topics;
}

1;
