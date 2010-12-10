package MyApp::Test;
use strict;
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

package MyApp::Test::hate;
use base 'MyApp::Test';
use CLITest;

sub run {
    my $self = shift;
    cliack($self->{verbose} ? 'v' : '', 'hate', @_);
}

1;
