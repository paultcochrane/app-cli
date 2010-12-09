package App::CLI;
our $VERSION = '0.313';
use strict;
use warnings;

=head1 NAME

App::CLI - Dispatcher module for command line interface programs

=head1 SYNOPSIS

    package MyApp;
    use base 'App::CLI';        # the DISPATCHER of your App
                                # it's not necessary putting the dispather
                                #  on the top level of your App

    package main;

    MyApp->dispatch;            # call dispather in where you want


    package MyApp::List;
    use base qw(App::CLI::Command); # any (SUB)COMMAND of your App

    use constant options => qw( 
        "h|help"   => "help",
        "verbose"  => "verbose",
        'n|name=s'  => 'name',
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
            # just only output PODs
        } else {
            # do something when imvoking $ my app list 
            # without subcommand and --help
        }
    }


    package MyApp::List::User;
    use base qw(App::CLI::Command);
    use constant options => (
        "h|help"  =>  "help",
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

=cut

use App::CLI::Helper;

use constant alias => ();
use constant global_options => ();
use constant options => ();

sub new {
    my $class = shift;
    bless {@_}, $class;
}

sub prepare {
    my $self = shift;
    $self->opt_map;
    my $cmd = ref($self)->get_cmd(shift @ARGV, @_, %{$self});
    while ($cmd->cascadable) { $cmd = $cmd->cascading }
    $cmd->options_mapper;
    $cmd = $cmd->subcommand;
    $cmd;
}

sub opt_map {
    my ($self) = @_;
    my %opt = $self->global_options;
    get_opt(
      [qw(no_ignore_case bundling pass_through)],
      map { $_ => ref($opt{$_}) ? $opt{$_} : \$self->{$opt{$_}}} keys %opt
    );
}

=head3

interface of dispatcher

=cut

sub dispatch { shift->new()->prepare(@_)->run_command(@ARGV) }

sub error_cmd { "Command not recognized, try $0 --help.\n"; }

sub error_opt { $_[1] }

=head3 get_cmd($cmd, @arg)

return subcommand of first level via $ARGV[0]

=cut

sub get_cmd {
    my ($class, $cmd, @arg) = @_;
    die $class->error_cmd unless $cmd && $cmd =~ m/^[?a-z]+$/;

    my %alias = $class->alias;
    $cmd = exists($alias{$cmd}) ? ucfirst($alias{$cmd}) : ucfirst($cmd);
    my $pkg = join('::', $class, $cmd);
    my $file = "$pkg.pm";
    $file =~ s!::!/!g;
    eval { require $file; };

    unless ($pkg->can('run')) {
      warn $@ if $@ and exists $INC{$file};
      die $class->error_cmd;
    } else {
      $cmd = $pkg->new(@arg);
      $cmd->app($class);
      return $cmd;
    }
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
