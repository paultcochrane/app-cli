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

    ....

    =cut

The message would show when users invoke

    $ myapp help foo

To add help message on spcecial topic rather than specific command, append PODs to lib/MyApp/Help/Bar.pod

    =head1 MyApp::Help::Bar

    blah

    1;

The message would show when users invoke

    $ myapp help bar

If you want to put the PODs in lib/MyApp/Documents/Bar.pod, attaching one line in MyApp::Command::Help makes it possible

    sub help_base { "MyApp::Documents" }

=cut

sub run {
    my $self = shift;
    my @topics = @_;

    push @topics, 'commands' unless (@topics);

    foreach my $topic (@topics) {
        if ($topic eq 'commands') {
            $self->brief_usage ($_) for $self->app->files;
        }
        elsif (my $cmd = $self->app->new->root_cascadable($topic) ) {
          print $cmd->new->usage(1);
        }
        elsif (my $file = $self->find_topic($topic)) {
            open my $fh, '<:utf8', $file or die $!;
            require Pod::Simple::Text;
            my $parser = Pod::Simple::Text->new;
            my $buf;
            $parser->output_string(\$buf);
            $parser->parse_file($fh);

            $buf =~ s/^NAME\s+(.*?)::Help::\S+ - (.+)\s+DESCRIPTION/    $2:/;
            print $self->loc_text($buf);
        }
        else {
            die loc("Cannot find help topic '%1'.\n", $topic);
        }
    }
    return;
}

sub help_base {
    my $self = shift;
    return $self->app."::Help";
}


sub find_topic {
    my ($self, $topic) = @_;

    my $pkg = ref($self);
    $pkg =~ s{::}{/};
    my $inc = $INC{"$pkg.pm"};
    $inc =~ s/$pkg\.pm//;
    my $base = $self->help_base;
    $base =~ s{::}{/};

    my %pods = reverse pod_find({},"$inc/$base");
    return $pods{ucfirst($topic)};
}

1;
