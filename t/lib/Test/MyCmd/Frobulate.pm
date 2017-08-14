package Test::MyCmd::Frobulate;

use strict;
use warnings;

use base qw(Test::MyCmd);

use constant options => (
    'foo-bar|F' => 'foo-bar',
    'widget=s'  => 'widget',
);

sub run {
    my $self = shift;
    $self->{widget} = '' unless defined $self->{widget};
    die "the widget name is $self->{widget} - @ARGV\n";
}

1;
