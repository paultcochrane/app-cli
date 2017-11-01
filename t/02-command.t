#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 5;
use lib qw(t/lib);
use Capture::Tiny qw(capture_stdout);

use App::CLI::Command;
use MyApp;
use MyCompleteApp;

eval {
    my $command = App::CLI::Command->new();
    $command->run;
};
like(
    $@,
    qr/does not implement mandatory method 'run'/,
    "require subclass to implement run()"
);

subtest "brief_usage() behaviour" => sub {
    plan tests => 1;

    my $output = capture_stdout {
        local *ARGV = ['help'];
        my $command = MyApp->new();
        $command->dispatch();
        $command->brief_usage();
    };
    like(
        $output,
        qr/myapp - undocumented/,
        "undocumented brief_usage() message"
    );

    # TODO: undocumented in specified file
    # how to behave if input filename doesn't exist?
};

subtest "usage() behaviour" => sub {
    plan tests => 2;

    my $output = capture_stdout {
        local *ARGV = ['help'];
        my $command = MyApp->new();
        $command->dispatch();
        $command->usage;
    };
    is( $output, '', "undocumented command displays no usage" );

    $output = capture_stdout {
        local *ARGV = ['help'];
        my $command = MyCompleteApp->new();
        $command->dispatch();
        $command->usage;
    };
    like( $output, qr/NAME\s+MyCompleteApp/m,
        "documented command displays usage text" );

    # what to expect with docs in app?
    # what to expect with $with_detail option to usage()?
};

subtest "version() behaviour" => sub {
    plan tests => 2;

    my $output = capture_stdout {
        local *ARGV = ['version'];
        my $command = MyCompleteApp->new();
        $command->dispatch();
    };
    chomp $output;
    is(
        $output,
        '02-command.t (MyCompleteApp) version 0.1 (t/02-command.t)',
        "version command shows version information"
    );

    $output = capture_stdout {
        local *ARGV = ['--version'];
        my $command = MyCompleteApp->new();
        $command->dispatch();
    };
    chomp $output;
    is(
        $output,
        '02-command.t (MyCompleteApp) version 0.1 (t/02-command.t)',
        "--version command shows version information"
    );
};

subtest "commands() behaviour" => sub {
    plan tests => 1;

    my $output = capture_stdout {
        local *ARGV = ['commands'];
        my $command = MyCompleteApp->new();
        $command->dispatch();
    };
    chomp $output;
    is(
        $output,
        '    help',
        "commands command shows available commands in app"
    );

};

# vim: expandtab shiftwidth=4
