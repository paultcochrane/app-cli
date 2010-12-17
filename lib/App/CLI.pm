use 5.010;
use strict;
use warnings;

package App::CLI;
our $VERSION = '0.313';

=head1 NAME

App::CLI - Dispatcher module for command line interface programs

=head1 SYNOPSIS

    package MyApp;
    use base 'App::CLI';        # the DISPATCHER of your App
                                # it's not necessary putting the dispather
                                #  on the top level of your App
    use constant alias => (
      "ls"          => "list",  # dispatch $ myapp ls to MyApp::List
    );
    
    use constant global_options => (
      "help|h"      => "help",  # all subcommands will have option --help 
    );

    package main;

    MyApp->dispatch(foo => "bar");  # call dispather in where you want
                                    # with more info you want the subcommand see
                                    # in this case, the subcommand would receive
                                    # $self->{foo} as "bar" in its run()


    package MyApp::List;
    use base qw(App::CLI::Command); # any (SUB)COMMAND of your App
                                    # keep your classes loose coupling
                                    # don't just use base qw(MyApp) here 
                                    # and use base qw(App::CLI App::CLI::Command) in MyApp

    use constant options => ( 
        "verbose"   => "verbose",
        'n|name=s'  => 'name',
    );

    use constant alias => (
        "ni"        => "nickname",  # dispatch $ myapp ls ni to MyApp::List::Nickname
    );

    use constant subcommands => qw(User Nickname type); # if you want subcommands
                                                        # automatically dispatch to subcommands
                                                        # when invoke $ myapp list [user|nickname|--type]
                                                        # note 'type' lower case in first char
                                                        # is subcommand of old genre which is deprecated

    sub run {
        my ($self, @args) = @_;

        print "verbose" if $self->{verbose};
        my $name = $self->{name}; # get arg following long option --name

        if ($self->{help}) {
            # if $ myapp list --help or $ $ myapp list -h
            print $self->help();
            # just only output PODs of this subcommand, MyApp::List
        } else {
            # do something when imvoking $ my app list 
            # without subcommand and --help
        }
    }


    package MyApp::List::User;
    use base qw(App::CLI::Command);
    use constant options => (
        "v|verbose"  =>  "verbose",
    );

    sub run {
        my ($self,@args) = @_;
        # code for listing user
    }


    pakcage MyApp::List::Nickname;
    use base qw(App::CLI::Command);
    use constant options => (
        "sort=s"  =>  "sort",
    );

    sub run {
        my ($self,@args) = @_;
        # code for listing nickname
    }

    package MyApp::List::type;   # old genre of subcommand could not be cascading infinitely
    use base qw(MyApp::List);    # should inherit its parents command

    sub run {
        my ($self, @args);
        # run to here when invoking $ myapp list --type 
    }


    package MyApp::Help;
    use base 'App::CLI::Command::Help';

    use constant options => (
        'verbose' => 'verbose',
    );

    sub run {
        my ($self, @arg) = @_;
        # do something
        $self->SUPER(@_); # App::CLI::Command::Help would output PDOs of each command
    }

=head1 DESCRIPTION

C<App::CLI> dispatches CLI (command line interface) based commands
into command classes.  It also supports subcommand and per-command
options.

The package is the base class of dispatcher.

=cut

use App::CLI::Helper;
use Module::Load;

use constant alias => ();
use constant global_options => ();

sub new {
    my $class = shift;
    bless {@_}, $class;
}

sub prepare {
    my $self = shift;
    my $cmd = $self->global_options_mapper->root_cascading;
    while ($cmd->cascadable) { $cmd = $cmd->cascading }
    $cmd->options_mapper->subcommand;
}

sub global_options_mapper {
    my ($self) = @_;
    my %opt = $self->global_options;
    getoptions(
      [qw(no_ignore_case bundling pass_through)],
      map { $_ => ref($opt{$_}) ? $opt{$_} : \$self->{$opt{$_}}} keys %opt
    );
    $self;
}

=head3

interface of dispatcher

=cut

sub dispatch { shift->new(@_)->prepare()->run_command(@ARGV) }

sub error_cmd { "Command not recognized, try $0 --help.\n"; }

sub error_opt { $_[1] }

=head3 root_cascading()

return subcommand of first level via $ARGV[0]

=cut

sub root_cascading {
    my ($self) = @_;
    unless (my $pkg = $self->root_cascadable) {
      warn $@ if $@;
      die $self->error_cmd;
    } else {
      shift @ARGV;
      $pkg->new(%{$self})->app(ref($self));
    }
}

=head3 root_cascadable()

return package name of subcommand of first level via $ARGV[0] or first argument

=cut

sub root_cascadable {
  my ($self, $subcmd) = @_;
  $subcmd //= $ARGV[0];
  die $self->error_cmd unless $subcmd && $subcmd =~ m/^[?a-z]+$/;

  $subcmd = {$self->alias}->{$subcmd} // $subcmd;

  for ($self->commands) {
    load my $require = ref($self)."::".ucfirst($_);
    return $require if $subcmd eq $_ && class_existed $require;
  }
  return undef;
}

# back-compatible
sub get_cmd {
  my ($class, $cmd) = @_;
  $cmd = $class->new->root_cascadable($cmd);
  $cmd->new if $cmd;
}

=head1 SEE ALSO

L<App::CLI::Command>
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
