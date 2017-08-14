package Test::MyCmd::Exit;

use strict;
use warnings;

use base qw(Test::MyCmd);

sub run {
  my ($self) = shift;
  exit(defined $ARGV[0] ? $ARGV[0] : 0);
}

1;
