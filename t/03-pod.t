#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Class::Load qw(try_load_class);
try_load_class( 'Test::Pod', { '-version' => 1.00 } )
  or plan skip_all => "Test::Pod 1.00 required for testing POD";

Test::Pod::all_pod_files_ok();

# vim: expandtab shiftwidth=4
