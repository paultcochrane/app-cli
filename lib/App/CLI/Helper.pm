package App::CLI::Helper;

use strict;
use warnings;

sub import {
  no strict 'refs';
  my $caller = caller;
  for (qw(commands files)) {
    *{$caller."::$_"} = *$_;
  }
}


=head3 commands()



=cut


sub commands {
    my $class = shift;
    my $dir = ref($class) || $class;

    $dir =~ s{::}{/}g;
    $dir = $INC{$dir.'.pm'};
    $dir =~ s/\.pm$//;

    my @cmds = map { ($_) = m{^\Q$dir\E/(.*)\.pm}; lc($_) } $class->files;

    if (ref $class and $class->can('alias')) {
        my %aliases = $class->alias;
        push @cmds, $_ foreach keys %aliases;
    }

    return sort @cmds;
}

=head3 files()

return module files of subcommans of first level

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
