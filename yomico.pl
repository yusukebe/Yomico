#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib/";
use Yomico;
use Pod::Usage;
use Getopt::Long;

my %opt;
Getopt::Long::GetOptions(\%opt, qw/ reload=s R=s port=i /);
my $doc = $ARGV[0] or pod2usage(2);
my $yomico = Yomico->new( doc => $doc );
my @opt;
for my $key ( keys %opt ) {
    push @opt, ( "-$key" => $opt{$key} ),
}
$yomico->run(\@opt);

__END__

=head1 NAME

yomico.pl - Yet Another Markdown Viewer.

=head1 SYNOPSIS

yomico.pl [options] [file or directory ...]

=cut
