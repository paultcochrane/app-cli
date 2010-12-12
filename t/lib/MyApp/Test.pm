use 5.010;
use strict;
use warnings;

package MyApp::Test;
use base qw(App::CLI::Command);
use CLITest;
use constant subcommands => qw(hate Cascading);
use constant options => (
    'v|verbose' => 'verbose',
    'dispatch'  => 'dispatch',
);
use constant alias => (
    'ca'        => 'cascading',
);

sub run {
    my $self = shift;
    if ($self->{dispatch}) {
      cliack($self->{foo} ? $self->{foo} : "");
    } else {
      cliack($self->{verbose} ? 'v' : '', @_);
    }
}

=head1 NAME

MyApp::Test - Intro to MyApp

=head1 DESCRIPTION

blah

=head1 USAGE

blah

=cut

1;
