#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 6;
use lib qw(t/lib);
use Capture::Tiny qw(capture_stdout);

use App::CLI::Command;
use MyApp;
use MyCompleteApp;

subtest "require run() method" => sub {
    my $eval_result = eval {
        my $command = App::CLI::Command->new();
        $command->run;
    };
    ok( !$eval_result );
    like(
        $@,
        qr/does not implement mandatory method 'run'/,
        "require subclass to implement run()"
    );
};

subtest "brief_usage() behaviour" => sub {
    plan tests => 2;

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

    $output = capture_stdout {
        local *ARGV = ['help'];
        my $command = MyCompleteApp->new();
        $command->dispatch();
        $command->brief_usage();
    };
    like(
        $output,
        qr/help - help for the Complete Test App/,
        "documented brief_usage() message"
    );  # see also https://github.com/paultcochrane/app-cli/pull/14

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
    is( $output, '    help',
        "commands command shows available commands in app" );
};

subtest "help command behaviour" => sub {
    plan tests => 6;

    {
        local *ARGV = [ 'help', 'unknown_topic' ];
        my $command = MyCompleteApp->new();
        my $eval_result = eval { $command->dispatch() };
        ok( !$eval_result );
        chomp( my $error_text = $@ );
        is(
            $error_text,
            "Cannot find help topic 'unknown_topic'.",
            "Unknown topic error text"
        );
    }

    {
        local *ARGV = [ 'help', 'commands' ];
        my $command = MyCompleteApp->new();
        my $output = capture_stdout { $command->dispatch() };
        chomp $output;
        is(
            $output,
            '    help - help for the Complete Test App',
            "Explicit commands help request"
        );
    }

    {
        local *ARGV = ['help'];
        my $command = MyCompleteApp->new();
        my $output = capture_stdout { $command->dispatch() };
        chomp $output;
        is(
            $output,
            '    help - help for the Complete Test App',
            "Default help output without explicit topics arg"
        );
    }

    {
        local *ARGV = [ 'help', 'help' ];
        my $command = MyCompleteApp->new();
        my $output = capture_stdout { $command->dispatch() };
        chomp $output;
        like(
            $output,
            qr/NAME\s+help - help for the Complete Test App/m,
            "Help output for explicit topic with own usage text"
        );
    }

    {
        local *ARGV = [ 'help', 'force' ];
        my $command = MyCompleteApp->new();
        my $output = capture_stdout { $command->dispatch() };
        chomp $output;
        my $heading      = 'NAME\s+';
        my $package_name = 'MyCompleteApp::Help::Force';
        my $help_text    = 'force the action to happen';
        like(
            $output,
            qr/$heading$package_name - $help_text/m,
            "Help output for explicit topic with help in POD"
        );
    }
};

# vim: expandtab shiftwidth=4
