package App::CLI::Command;
use strict;
use warnings;
use Locale::Maketext::Simple;
use Carp ();

use App::CLI::Helper;
use App::CLI::Usage;

use Class::Load qw( load_class );
use Scalar::Util qw( weaken );
use String::Format;

=head1 NAME

App::CLI::Command - Base class for App::CLI commands

=head1 SYNOPSIS

    package MyApp::List;
    use base qw(App::CLI::Command);

    use constant options => (
        'verbose'   => 'verbose',
        'n|name=s'  => 'name',
    );

    sub run {
        my ( $self, $arg ) = @_;

        print "verbose" if $self->{verbose};

        my $name = $self->{name}; # get arg following long option --name

        # anything you want this command do
    }

    # See App::CLI for information of how to invoke (sub)command.

=head1 DESCRIPTION


=cut

use constant subcommands => ();
use constant options => ();
use constant usage_desc => '%c %C %o';

sub new {
    my $class = shift;
    bless {@_}, $class;
}



sub command_options {
    ((map { $_ => $_ } $_[0]->subcommands), $_[0]->options);
}

# XXX:
sub _mk_completion_sh { }
sub _mk_completion_zsh { }



sub run_command {
    my $self = shift;
    $self->run(@_);
}

sub run {
  my $class = shift;
  Carp::croak ref($class) . " does not implement mandatory method 'run'\n";
}

=head3 subcommand()

    return old genre subcommand of $self;

=cut

sub subcommand {
    my $self = shift;
    my @cmd = $self->subcommands;
    @cmd = values %{{$self->options}} if @cmd && $cmd[0] eq '*';
    my $subcmd = undef;
    for (grep {$self->{$_}} @cmd) {
      no strict 'refs';
      if (exists ${ref($self).'::'}{$_.'::'}) {
        my %data = %{$self};
	$subcmd = bless ({%data}, (ref($self)."::$_"));
        last;
      }
    }
    $subcmd ? $subcmd : $self;
}

=head3 cascading()

Return instance of cascading subcommand invoked if it was listed in your
constant subcommands.

=cut

sub cascading {
  my $self = shift;
  if (my $subcmd = $self->cascadable) {
    shift @ARGV;
    my %data = %{$self};
    return bless {%data}, $subcmd;
  } else {
    die $self->error_cmd($ARGV[0]);
  }
}

=head3 cascadable()

Return package name of subcommand if the subcommand invoked is in your
constant subcommands, otherwise, return C<undef>.

=cut

sub cascadable {
  my $self = shift;
  my $class = ref $self || $self;
  for ($self->subcommands) {
    no strict 'refs';
    my $package_name = $class . '::' . $_;
    load_class $package_name;
    if ($ARGV[0] and ucfirst($ARGV[0]) eq $_ && exists ${$class . '::'}{$_ . '::'}) {
      return $package_name;
    }
  }
  return undef
}

sub app {
    my $self = shift;

    if (@_) {
        $self->{app} = shift;
        weaken($self->{app});
    }

    return $self->{app};
}

=head3 brief_usage ($file)

Display a one-line brief usage of the command object.

=cut

sub brief_usage {
    my ($self) = @_;

    my $option_string = q{};
    my $program_name  = $self->prog_name;
    my @components    = split /::/, ref $self;
    my $command_name  = lc pop @components;
       $command_name  = '<commands>' if ref $self->app eq ref $self;

    my %options;
    %options = $self->global_options if $self->can('global_options');
    %options = (%options, $self->options);

    if (%options) {
      my (@short, @long);

      foreach my $opt (keys %options) {
        foreach (split qr{\|}, $opt) {
          (length == 1)
            ? push @short, $_
            : push @long,  $_;
        }
      }

      $option_string  = '[' . join(q{}, sort @short) . ']' if @short;
      $option_string .= ' [long options]' if @long;
    }

    return stringf( $self->usage_desc . "\n\n" =>
        'c' => $program_name,
        'C' => $command_name,
        'o' => $option_string,
    );
}

=head3 usage ($want_detail)

Display usage. If C<$want_detail> is true, the C<DESCRIPTION>
section is displayed as well.

=cut

sub usage {
    my ($self, $want_detail) = @_;

    my $select = '(?:NAME|SYNOPSIS'
        . ($want_detail ? '|DESCRIPTION' : '')
        . ')\s*';

    my $usage = $self->brief_usage;

    my $parser = App::CLI::Usage->new( select => $select );
    $usage .= $parser->parse_file( $self->filename );

    print $usage;
    return $usage;
}

=head3 loc_text $text

Localizes the body of (formatted) text in C<$text> and returns the
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

=head3 filename

Return the filename for the command module.

=cut

sub filename {
    my $self = shift;
    my $fname = ref($self);
    $fname =~ s{::[a-z]+$}{}; # subcommand
    $fname =~ s{::}{/}g;
    return $INC{"$fname.pm"};
}


=head1 SEE ALSO

L<App::CLI>, L<Getopt::Long>

=head1 AUTHORS

Chia-liang Kao E<lt>clkao@clkao.orgE<gt>

Cornelius Lin  E<lt>cornelius.howl@gmail.comE<gt>

Shelling       E<lt>navyblueshellingford@gmail.comE<gt>

Paul Cochrane  E<lt>paul@liekut.deE<gt> (current maintainer)

=head1 COPYRIGHT

Copyright 2005-2006 by Chia-liang Kao E<lt>clkao@clkao.orgE<gt>.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>

=cut

1;
