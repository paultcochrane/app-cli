package MyApp;
use strict;
use warnings;
use base qw(App::CLI App::CLI::Command);

use constant alias => ( te => 'test' );

use constant global_options => (
    'help'       => 'help',
    'username=s' => 'username',
    'force'      => 'force'
);

1;
