package Test::MyCmd::Hello;

use strict;
use warnings;

use base qw(Test::MyCmd);

use IPC::Cmd qw/can_run/;

sub run {
  my ($self, $opt, $arg) =@_;

  if ( $^O eq 'MSWin32' ) {
    system('cmd', '/c', 'echo', "Hello World");
  }
  else {
    my $echo = can_run("echo");
    $self->usage_error("Program 'echo' not found") unless $echo;
    system($echo, "Hello World");
  }
  return;
}

1;
