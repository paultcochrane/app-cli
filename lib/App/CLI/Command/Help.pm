use 5.010;
use strict;
use warnings;

package App::CLI::Command::Help;
use base qw(App::CLI::Command);
use File::Find;
use Pod::Find qw(pod_find);
use Locale::Maketext::Simple;
use Pod::Simple::Text;

=head1 NAME

App::CLI::Command::Help

=head1 SYNOPSIS

    package MyApp::Help;
    use base qw(App::CLI::Command::Help);

    sub run {
        my ($self, @args) = @_;
        # preprocess
        $self->SUPER(@_);       # App::CLI::Command::Help would output PODs of each command
    }

=head1 DESCRIPTION

Your command class should be capitalized.

To add help message , you just add PODs in command class:

    package MyApp::Command::Foo;


    =head1 NAME

    MyApp::Command::Foo - execute foo

    =head1 DESCRIPTION

    blah blah

    =head1 USAGE

    blah

    =head1 OPTIONS

    ....

    =cut

The message would show when users invoke

    $ myapp help foo

To add help message on spcecial topic rather than specific command, append PODs to lib/MyApp/Help/Bar.pod

    =head1 NAME
    
    MyApp::Help::Bar

    =head1 DESCRIPTION

    blah

    =cut

    1;

The message would show when users invoke

    $ myapp help bar

If you want to put the PODs in lib/MyApp/Documents/Bar.pod, attaching one line in MyApp::Command::Help makes it possible

    sub help_base { "MyApp::Documents" }

Otherwise, normally you can leave your Help subcommands blank except use base qw(App::CLI::Command::Help);

To see PODs of subsubcomand, e.g. package MyApp::Command::Server::Stop, invoke

    $ myapp help server stop

Deeper construction of PODS is also allowed. to see lib/MyApp/Help/Hello/World.pod, invoke

    $ myapp help hello world

=cut

sub run {
    my ($self, @topics) = @_;
    my $app = $self->app->new;

    if (scalar(@topics) == 0) {
      $self->brief_usage($_) for $self->app->files;
    } elsif ($app->root_cascadable($topics[0])) {
      local *ARGV = [@topics];
      print $self->parse_pod($app->prepare->filename);
    } elsif (my $file = $self->find_topic(@topics)) {
      print $self->parse_pod($file);
    } else {
      die loc("Cannot find help topic '%1'.\n", join "::", map {ucfirst($_)} @topics);
    }

    return;
}


sub help_base { shift->app."::Help" }

sub find_topic {
    my $self = shift;
    my $topic = join "::", map {ucfirst($_)} @_;

    my $lib = $self->lib();
    my $base = $self->help_base;
    $base =~ s{::}{/}g;

    my %pods = reverse pod_find({},"$lib/$base");
    return $pods{$topic};
}

sub parse_pod {
    my ($self, $file) = @_;
    my $parser = Pod::Simple::Text->new;
    my $buffer;
    $parser->output_string(\$buffer);
    $parser->parse_file($file);
    $self->loc_text($buffer);
}

1;
