package MyCompleteApp;
use strict;
use warnings;
use base qw(App::CLI App::CLI::Command);

our $VERSION = '0.1';

use constant alias => (
    '--version' => '+App::CLI::Command::Version',
    'version'   => '+App::CLI::Command::Version',
    commands    => '+App::CLI::Command::Commands',
    te          => 'test',
);

use constant options => (
    'help'       => 'help',
    'username=s' => 'username',
    'force'      => 'force'
);

=head1 NAME

MyCompleteApp - my command line app with docs, version, etc.

=head1 SYNOPSIS

    use MyCompleteApp;

=head1 AUTHORS

Me, Myself, I

=cut

sub run {
    my ( $self, @args ) = @_;
}

1;
