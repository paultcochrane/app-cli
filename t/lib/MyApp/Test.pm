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

sub run {
    my $self = shift;
    if ($self->{dispatch}) {
      cliack($self->{foo} ? $self->{foo} : "");
    } else {
      cliack($self->{verbose} ? 'v' : '', @_);
    }
}

1;
