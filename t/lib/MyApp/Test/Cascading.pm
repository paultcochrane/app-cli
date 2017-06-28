package MyApp::Test::Cascading;
use base qw(App::CLI::Command);
use strict;
use CLITest;
use constant subcommands => qw(Infinite);

sub run {
  my $self = shift;
  cliack;
}

1;
