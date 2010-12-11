use inc::Module::Install;

name		'App-CLI';
author		'Chia-liang Kao <clkao@clkao.org>';
abstract_from	'lib/App/CLI.pm';
license		'perl';
version_from	'lib/App/CLI.pm';
perl_version    '5.010';
repository      'http://github.com/c9s/app-cli';

requires 'Getopt::Long' => '2.35';
requires 'Locale::Maketext::Simple';
requires 'Pod::Simple::Text';
requires 'Rubyish::Attribute';
requires 'Pod::Find';

auto_install;

WriteAll;
