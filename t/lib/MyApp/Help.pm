package MyApp::Help;
use base 'App::CLI::Command::Help';

sub help_base {
  shift->app."::Documents"; 
  # rewrite the caculated default: MyApp::Help
}

1;
