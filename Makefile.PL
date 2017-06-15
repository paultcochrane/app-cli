#!/usr/bin/perl

use strict;
use warnings;

use ExtUtils::MakeMaker qw(6.3.1);

WriteMakefile(
    NAME          => "App::CLI",
    VERSION_FROM  => "lib/App/CLI.pm",
    ABSTRACT_FROM => "lib/App/CLI.pm",
    AUTHOR        => ('Chia-liang Kao <clkao@clkao.org>'),
    LICENSE       => "perl_5",
    PREREQ_PM     => {
        'Locale::Maketext::Simple' => 0,
        'Getopt::Long'             => '2.35',
        'Pod::Simple::Text'        => 0,
    },
);

# vim: expandtab shiftwidth=4
