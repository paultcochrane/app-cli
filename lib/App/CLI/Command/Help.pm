use 5.010;
use strict;
use warnings;

package App::CLI::Command::Help;
use base qw(App::CLI::Command);
use File::Find;
use File::Basename;
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

To see PODs of subsubcommand, e.g. package MyApp::Command::Server::Stop, invoke

    $ myapp help server stop

Deeper construction of PODS is also allowed. to see lib/MyApp/Help/Hello/World.pod, invoke

    $ myapp help hello world

=cut

sub run {
    my ($self, @topics) = @_;
    my $app = $self->app->new;

    if (scalar(@topics) == 0) {
      say "All commands available are:";
      say $self->brief_usage($_) for $app->files;
      # should show PODS available
      say "\nrun '".basename($0)." help <command>' to see the usage of their subcommands";
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

=head3 brief_usage ($file)

return an one-line brief usage of the command object. Optionally, a file
could be given to extract the usage from the POD.

=cut

sub brief_usage {
    my ($self, $file) = @_;
    my $buf = $self->parse_pod($file);
    my $base = $self->app;
    my $cmd = lc basename($file);
    $cmd =~ s/\.pm$//g;
    $cmd = substr $cmd."          ", 0, 11;
    my $desc = ($buf =~ /^NAME\s*\Q$base\E::\w+ - (.+)$/m) ? $1 : "undocumented";
    return  "   ".$cmd.loc($desc);
}

=head3 loc_text $text

Localizes the body of (formatted) text in $text, and returns the
localized version.

=cut

sub loc_text {
    my $self = shift;
    my $buf = shift;

    my $out = "";
    foreach my $line (split(/\n\n+/, $buf, -1)) {
        if (my @lines = $line =~ /^( {4}\s+.+\s*)$/mg) {
            foreach my $chunk (@lines) {
                $chunk =~ /^(\s*)(.+?)( *)(: .+?)?(\s*)$/ or next;
                my $spaces = $3;
                my $loc = $1 . loc($2 . ($4||'')) . $5;
                $loc =~ s/: /$spaces: / if $spaces;
                $out .= $loc . "\n";
            }
            $out .= "\n";
        }
        elsif ($line =~ /^(\s+)(\w+ - .*)$/) {
            $out .= $1 . loc($2) . "\n\n";
        }
        elsif (length $line) {
            $out .= loc($line) . "\n\n";
        }
    }
    return $out;
}

1;
