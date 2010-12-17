use 5.010;
use strict;
use warnings;

package App::CLI::Command;
use Locale::Maketext::Simple;
use Carp;
use App::CLI::Helper;
use Rubyish::Attribute;
use Module::Load;

=head1 NAME

App::CLI::Command - Base class for App::CLI commands

=head1 SYNOPSIS

    package MyApp::List;
    use base qw(App::CLI::Command);

    use constant subcommands => qw(User Nickname);

    use constant alias => (
        'ni'        => 'nickname',
    );

    use constant options => (
        'verbose'   => 'verbose',
        'n|name=s'  => 'name',
    );

    sub run {
        my ( $self, $arg ) = @_;

        print "verbose" if $self->{verbose};

        my $name = $self->{name}; # get arg following long option --name

        # any thing your want this command do
    }

    # See App::CLI for information of how to invoke (sub)command.

=head1 DESCRIPTION

The base class of all subcommand

=cut

use constant subcommands => ();
use constant options => ();
use constant alias => ();

attr_accessor "app";

sub new {
    my $class = shift;
    bless {@_}, $class;
}

sub options_mapper {
  my ($self) = @_;
  my %opts = $self->command_options();
  getoptions(
    [qw(no_ignore_case bundling)],
    map { $_ => ref($opts{$_}) ? $opts{$_} : \$self->{$opts{$_}} } keys %opts
  );
  $self;
}

sub command_options { (map { $_ => $_ } $_[0]->subcommands), $_[0]->options }

# XXX:
sub _mk_completion_sh { }
sub _mk_completion_zsh { }



sub run_command {
    my $self = shift;
    $self->run(@_);
}

=head3 subcommand()

    return old genre subcommand of $self;

=cut

sub subcommand {
    my $self = shift;
    my @cmd = $self->subcommands;
    @cmd = values %{{$self->options}} if @cmd && $cmd[0] eq '*';
    for (grep {$self->{$_}} @cmd) {
      my $require = ref($self)."::$_";
      return $require->new(%{$self}) if class_existed $require;
    }
    return $self;
}

=head3 cascading()

return instance of cascading subcommand invoked if it was listed in your constant subcommands.

=cut

sub cascading {
  my $self = shift;
  if (my $subcmd = $self->cascadable) {
    shift @ARGV;
    return $subcmd->new(%{$self});
  } else {
    die "not cascadable $0";
  }
}

=head3 cascadable()

return package name of subcommand if the subcommand invoked is in you constant subcommands

otherwise, return undef

=cut

sub cascadable {
  my $self = shift;
  $ARGV[0] = {$self->alias}->{$ARGV[0]} // $ARGV[0] if $ARGV[0] && $ARGV[0] =~ m/^[?a-z]+$/;
  for ($self->subcommands) {
    load my $require = ref($self)."::$_";
    return $require if ucfirst($ARGV[0]) eq $_ && class_existed $require;
  }
  return undef;
}

=head3 filename

Return the filename for the command module.

=cut

sub filename {
    my $self = shift;
    my $fname = ref($self);
    $fname =~ s{::[a-z]+$}{}; # subcommand
    $fname =~ s{::}{/}g;
    return $INC{"$fname.pm"};
}

=head3 help

return PODs of the command module

=cut

sub help {
    my $self = shift;
    $self->app
         ->new->root_cascadable("help")
         ->new->parse_pod($self->filename);
}


=head1 SEE ALSO

L<App::CLI>
L<Getopt::Long>

=head1 AUTHORS

Chia-liang Kao E<lt>clkao@clkao.orgE<gt>
Cornelius Lin  E<lt>cornelius.howl@gmail.comE<gt>
shelling       E<lt>navyblueshellingford@gmail.comE<gt>

=head1 COPYRIGHT

Copyright 2005-2006 by Chia-liang Kao E<lt>clkao@clkao.orgE<gt>.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>

=cut

1;
