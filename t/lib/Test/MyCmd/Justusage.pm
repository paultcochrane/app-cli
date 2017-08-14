package Test::MyCmd::Justusage;

use strict;
use warnings;

use base qw(Test::MyCmd);

use constant options => (
    'd|detail' => 'detail',
);

sub run {
  my $self = shift;
  die $self->usage($self->{detail});
}

1;

__END__

=head1 NAME

Test::MyCmd::Justusage - it just dies its own usage, no matter what

=cut
