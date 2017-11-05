package MyCompleteApp::Help::Force;
use base qw(App::CLI::Command::Help);

use strict;
use warnings;

=head1 NAME

MyCompleteApp::Help::Force - force the action to happen

=cut


sub run {
    my $self = shift;
    $self->SUPER::run(@_);
}

1;
