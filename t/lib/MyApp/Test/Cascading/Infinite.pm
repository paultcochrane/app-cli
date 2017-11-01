package MyApp::Test::Cascading::Infinite;
use base qw(App::CLI::Command);
use strict;
use warnings;
use CLITest;
use constant subcommands => qw(Subcommands);

sub run {
    my $self = shift;
    cliack;
}

1;
