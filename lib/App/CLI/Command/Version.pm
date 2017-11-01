package App::CLI::Command::Version;

use strict;
use warnings;

use base qw/App::CLI::Command/;

=head1 NAME

App::CLI::Command::Version - Print a preformatted version string

=head1 SYNOPSIS

    package MyApp;
    use base qw(App::CLI App::CLI::Command);

    use constant alias => (
        '--version' => '+App::CLI::Command::Version',
          'version' => '+App::CLI::Command::Version',
        # Other aliases
    );

    # Your app now supports a default version command and option

=head1 DESCRIPTION

This is package provides a default C<version> command modelled after
that of L<App::Cmd>. You can modify the default message by subclassing
this command and overriding its C<run> method, or by modifying it with
eg. L<Class::Method::Modifiers>.

=cut

sub run {
    my ($self) = shift;
    no strict 'refs';
    print sprintf "%s (%s) version %s (%s)\n",
      $self->app->prog_name, ref $self->app, $self->app->VERSION, $0;
}

1;
