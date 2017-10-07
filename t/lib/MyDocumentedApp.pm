package MyDocumentedApp;
use strict;
use warnings;
use base qw(App::CLI App::CLI::Command);

use constant alias => ( te => 'test' );

use constant global_options => ( 'help' => 'help',
				 'username=s' => 'username',
				 'force' => 'force' );

=head1 NAME

MyDocumentedApp - my command line app with docs

=head1 SYNOPSIS

    use MyDocumentedApp;

=head1 AUTHORS

Me, Myself, I

=cut


1;
