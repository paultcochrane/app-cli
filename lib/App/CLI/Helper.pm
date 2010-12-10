package App::CLI::Helper;
use Getopt::Long;

sub import {
  my $caller = caller;
  for (qw(getoptions commands files)) {
    *{$caller."::$_"} = *$_;
  }
}

=head3 getoptions([@config], %opt_map)

    give options map, process by Getopt::Long::Parser

=cut

sub getoptions {
    my $config = shift;
    my $p = Getopt::Long::Parser->new;
    $p->configure(@$config);
    my $err = '';
    local $SIG{__WARN__} = sub { 
      my $msg = shift;
      $err .= "$msg"
    };
    die $class->error_opt ($err) unless $p->getoptions(@_);
}

=head3 commands()



=cut


sub commands {
    my $class = shift;
    my $dir = ref($class) ? ref($class) : $class;
    $dir =~ s{::}{/}g;
    $dir = $INC{$dir.'.pm'};
    $dir =~ s/\.pm$//;
    return sort map { ($_) = m{^\Q$dir\E/(.*)\.pm}; lc($_) } $class->files;
}

=head3 files()

return module files of subcommands of first level

=cut

sub files {
    my $class = shift;
    $class = ref($class) if ref($class);
    $class =~ s{::}{/}g;
    my $dir = $INC{$class.'.pm'};
    $dir =~ s/\.pm$//;
    return sort glob("$dir/*.pm");
}


1;
