package App::CLI::Usage;

use strict;
use warnings;

use Pod::Usage;

sub new {
    my $class = shift;
    my $args = @_ ? @_ > 1 ? { @_ } : shift : {};
    $args->{select} = '(?:NAME|SYNOPSIS|DESCRIPTION)\s*' unless $args->{select};
    $args->{parser} = Pod::Usage->new                    unless $args->{parser};

    my $self = bless $args, $class;
    $self->select($self->{select});

    return $self;
}

sub select { $_[0]->parser->select(@_) }

sub parser {
    my $self = shift;
    $self->{parser} = shift if @_;
    return $self->{parser};
}

sub parse_file {
    my ($self, $filename) = @_;

    my $usage = q{};
    use autodie;
    open my $fh, '>', \$usage;
    $self->parser->parse_from_file($filename, $fh);

    return $usage;
}

1;
