#!/usr/bin/perl

use strict;
use warnings;

use ExtUtils::MakeMaker qw(6.64);

WriteMakefile(
    NAME          => "App::CLI",
    VERSION       => '0.4.2',
    ABSTRACT_FROM => "lib/App/CLI.pm",
    AUTHOR        => ('Chia-liang Kao <clkao@clkao.org>'),
    LICENSE       => "perl_5",
    PREREQ_PM     => {
        'Locale::Maketext::Simple' => 0,
        'Getopt::Long'             => '2.35',
        'Pod::Simple::Text'        => 0,
        'Carp'                     => 0,
        'File::Find'               => 0,
    },
    MIN_PERL_VERSION => 5.006,
    TEST_REQUIRES    => {
        'Test::More' => 0,
    },
    META_MERGE => {
        "meta-spec" => { version => 2 },
        resources   => {
            repository => {
                type => 'git',
                url  => 'git@github.com:paultcochrane/app-cli.git',
                web  => 'https://github.com/paultcochrane/app-cli',
            },
        },
        provides => {
            'App::CLI' => {
                file => 'lib/App/CLI.pm',
            },
            'App::CLI::Helper' => {
                file => 'lib/App/CLI/Helper.pm',
            },
            'App::CLI::Command' => {
                file => 'lib/App/CLI/Command.pm',
            },
            'App::CLI::Command::Help' => {
                file => 'lib/App/CLI/Command/Help.pm',
            },
        }
    },
);

# vim: expandtab shiftwidth=4
