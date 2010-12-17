package App::CLI::Helper;
use Getopt::Long;

=head1 NAME

App::CLI::Helper

=head1 DESCRIPTION

internal helper functions

=head2 Functions

=cut

sub import {
  my $caller = caller;
  for (qw(getoptions commands files lib class_existed)) {
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

return a list of subcommands of $self

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

return module files of subcommands of $self

=cut

sub files {
    my $class = shift;
    $class = ref($class) if ref($class);
    $class =~ s{::}{/}g;
    my $dir = $INC{$class.'.pm'};
    $dir =~ s/\.pm$//;
    return sort glob("$dir/*.pm");
}

=head3 lib()

return the lib root the module is in

=cut

sub lib {
    my $self = shift;
    my $pkg = ref($self);
    $pkg =~ s{::}{/}g;
    my $lib = $INC{"$pkg.pm"};
    $lib =~ s/$pkg\.pm//;
    return $lib;
}

sub class_existed {
  my $class = shift;
  my @list = split "::", $class;
  my $last = pop @list;
  no strict "refs";
  exists(${join("::",@list)."::"}{$last."::"}) ? 1 : undef;
}

1;
