package App::CLI::Helper;

use strict;
use warnings;

use File::Basename qw( basename );

sub import {
  no strict 'refs';
  my $caller = caller;
  for (qw(commands files prog_name)) {
    *{$caller."::$_"} = *$_;
  }
}


=head3 commands()



=cut


sub commands {
    my ($class, $include_alias) = @_;
    my $dir = ref($class) || $class;

    $dir =~ s{::}{/}g;
    $dir = $INC{$dir.'.pm'};
    $dir =~ s/\.pm$//;

    my @cmds = map { ($_) = m{^\Q$dir\E/(.*)\.pm}; lc($_) } $class->files;

    if ($include_alias and ref $class and $class->can('alias')) {
        my %aliases = $class->alias;
        push @cmds, $_ foreach keys %aliases;
    }

    return sort @cmds;
}

=head3 prog_name()

The name of the program running your application. This will default to
C<basename $0>, but can be overiden from within your application.

=cut

{
  my $default;
  sub prog_name {
    my $self = shift;

    $default = basename $0 unless $default;
    return $default unless ref $self;

    return $self->{prog_name} if defined $self->{prog_name};

    $self->{prog_name} = basename $0;
    return $self->{prog_name};
  }
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
