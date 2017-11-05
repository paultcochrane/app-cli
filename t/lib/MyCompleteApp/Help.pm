package MyCompleteApp::Help;
use base qw(App::CLI::Command::Help);

use strict;
use warnings;

=head1 NAME

MyCompleteApp::Help - help for the complete test app

=cut


sub run {
    my $self = shift;
    $self->SUPER::run(@_);
}

1;
