package Test::MyCmd;

use strict;
use warnings;

use constant alias => (
    '--version'  => '+App::CLI::Command::Version',
       version   => '+App::CLI::Command::Version',
    '--help'     => '+App::CLI::Command::Help',
       help      => '+App::CLI::Command::Help',
       commands  => '+App::CLI::Command::Commands',
       frob      => 'frobulate',
);

use constant global_options => (
    'v|verbose' => 'verbose',
    'F|force'   => 'force',
);

use parent qw(App::CLI App::CLI::Command);

our $VERSION = '0.123';

1;

__END__

=head1 NAME

Test::MyCmd - A test command line application

=head1 SYNOPSIS

    use Test::MyCmd;
    Test::MyCmd->dispatch;

=head1 DESCRIPTION

Blib Bloob.

=cut
