package MyCompleteApp::Help;
use base qw(App::CLI::Command::Help);

use strict;
use warnings;

sub run {
    my $self = shift;
    $self->SUPER::run(@_);
}

1;
