#!/usr/bin/perl

use strict;
use warnings;

use ExtUtils::MakeMaker qw(6.64);

WriteMakefile(
    NAME          => "App::CLI",
    VERSION       => '0.4.4',
    ABSTRACT_FROM => "lib/App/CLI.pm",
    AUTHOR        => [
        'Chia-liang Kao <clkao@clkao.org>',
        'Yo-An Lin      <cornelius.howl@gmail.com>',
        'Shelling       <navyblueshellingford@gmail.com>',
        'Paul Cochrane  <paul@liekut.de>',
    ],
    LICENSE   => "perl_5",
    PREREQ_PM => {
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
    },
);

# vim: expandtab shiftwidth=4
