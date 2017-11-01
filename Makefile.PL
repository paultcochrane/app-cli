#!/usr/bin/env perl

use strict;
use warnings;

use ExtUtils::MakeMaker qw(6.64);

WriteMakefile(
    NAME          => "App::CLI",
    VERSION_FROM  => 'lib/App/CLI.pm',
    ABSTRACT_FROM => "lib/App/CLI.pm",
    AUTHOR        => [
        'Chia-liang Kao <clkao@clkao.org>',
        'Yo-An Lin      <cornelius.howl@gmail.com>',
        'Shelling       <navyblueshellingford@gmail.com>',
        'Paul Cochrane  <paul@liekut.de>',
    ],
    LICENSE   => "perl_5",
    PREREQ_PM => {
        'base'                     => 0,
        'constant'                 => 0,
        'strict'                   => 0,
        'warnings'                 => 0,
        'Capture::Tiny'            => 0,
        'Carp'                     => 0,
        'Class::Load'              => 0,
        'File::Basename'           => 0,
        'File::Find'               => 0,
        'Getopt::Long'             => '2.35',
        'Locale::Maketext::Simple' => 0,
        'Pod::Simple::Text'        => 0,
        'Scalar::Util'             => 0,
    },
    MIN_PERL_VERSION => 5.006,
    TEST_REQUIRES    => {
        'lib'            => 0,
        'Test::Kwalitee' => 0,
        'Test::More'     => 0,
        'Test::Pod'      => 0,
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
        x_contributors => ['José Joaquín Atria <jjatria@gmail.com>'],
    },
);

# vim: expandtab shiftwidth=4
