package Yomico;
use strict;
use warnings;
use Carp qw/croak/;
use Yomico::Web;
use Path::Class qw/file dir/;
use Plack::Runner;

our $VERSION = '0.01';

sub base_dir {
    my $path = ref $_[0] || $_[0];
    $path =~ s!::!/!g;
    if ( my $libpath = $INC{"$path.pm"} ) {
        $libpath =~ s!(?:blib/)?lib/+$path\.pm$!!;
        File::Spec->rel2abs( $libpath || './' );
    }
    else {
        File::Spec->rel2abs('./');
    }
}

sub new {
    my ( $class, %opt ) = @_;
    croak "new method requred doc opt" unless $opt{doc};
    croak "opt method must be file or directory path"
        unless ( -f $opt{doc} || -d $opt{doc} );
    my $self = bless { doc => $opt{doc} }, $class;
    $self;
}

sub run {
    my ($self, $opt) = @_;
    my $web;
    $web = Yomico::Web->new( root => dir($self->{doc}) ) if -d $self->{doc};
    $web = Yomico::Web->new( root => file($self->{doc}) ) if -f $self->{doc};
    my $app = $web->app;
    my $runner = Plack::Runner->new;
    $runner->parse_options(@$opt);
    $runner->run( $app );
}

1;

__END__

=head1 NAME

Yomico - Yet Another Markdown Viewer.

=head1 SYNOPSIS

  use Yomico;

  my $yomico = Yomico->new( doc => 'README.mkdn' );
  $yomico->run();

=head1 DESCRIPTION

Yomico is Core module of Yomico.

=head1 AUTHOR

Yusuke Wada E<lt>yusuke@kamawada.comE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
