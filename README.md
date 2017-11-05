# App::CLI - Dispatcher module for command line interface programs

[![Coverage Status](https://coveralls.io/repos/github/paultcochrane/app-cli/badge.svg)
](https://coveralls.io/github/paultcochrane/app-cli)
[![Travis Build Status](https://travis-ci.org/paultcochrane/app-cli.svg?branch=master)
](https://travis-ci.org/paultcochrane/app-cli)
[![AppVeyor Build status](https://ci.appveyor.com/api/projects/status/g0dlp43k42lpy3s8?svg=true)
](https://ci.appveyor.com/project/paultcochrane/app-cli)


`App::CLI` dispatches CLI (command line interface) based commands
into command classes.  It also supports subcommand and per-command
options.

## Installation

The easiest way to install `App::CLI` is to use `cpanm`:

```
$ cpanm App::CLI
```

To install it from source, clone the repo, create the `Makefile`, and run
`make install`:

```
git clone https://github.com/paultcochrane/app-cli.git
cd app-cli
perl Makefile.PL
make
make test
make install
```

## Example usage

```
package MyApp;
use base 'App::CLI';        # the DISPATCHER of your App
                            # it's not necessary to put the dispatcher
                            # on the top level of your App

package main;

MyApp->dispatch;            # call the dispatcher where you want


package MyApp::List;
use base qw(App::CLI::Command); # any (SUB)COMMAND of your App

use constant options => (
    "h|help"   => "help",
    "verbose"  => "verbose",
    'n|name=s'  => 'name',
);

use constant subcommands => qw(User Nickname type); # if you want subcommands
                                                    # automatically dispatch to subcommands
                                                    # when invoke $ myapp list [user|nickname|--type]
                                                    # note 'type' is not capitalized
                                                    # it is a deprecated subcommand

sub run {
    my ($self, @args) = @_;

    print "verbose" if $self->{verbose};
    my $name = $self->{name}; # get arg following long option --name

    if ($self->{help}) {
        # if $ myapp list --help or $ myapp list -h
        # only output PODs
    } else {
        # do something when invoking $ myapp list
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

package MyApp::List::type;   # old genre of subcommand could not cascade infinitely
use base qw(MyApp::List);    # should inherit its parent's command

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
    $self->SUPER(@_); # App::CLI::Command::Help would output POD of each command
}
```
