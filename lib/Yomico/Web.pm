package Yomico::Web;
use strict;
use warnings;
use Path::Class qw/file dir/;
use Plack::Request;
use File::Spec;
use Text::Markdown qw/markdown/;
use Text::Xslate qw/mark_raw/;
use File::ShareDir qw/dist_file/;

sub new {
    my ( $class, %opt ) = @_;
    my $self = bless { %opt }, $class;
    $self;
}

sub app {
    my $self = shift;
    return sub {
        my $env = shift;
        my $req = Plack::Request->new( $env );
        my $path_info = $req->path_info;
        my $path = $self->make_path($path_info);
        if( $self->is_markdown($path) ) {
            my $file = file( $path );
            my $mkdn = $file->slurp;
            my $html = markdown( $mkdn );
            return $self->render_content( $html );
        }
        return [ 200, [ 'Content-Type' => 'text/html' ], [$path] ];
    }
}

sub render_content {
    my ( $self, $content_html ) = @_;
    my $header = file( $self->local_or_share_file('header.tt') )->slurp;
    my $footer = file( $self->local_or_share_file('footer.tt') )->slurp;
    my $tx = Text::Xslate->new(
        syntax => 'TTerse',
    );
    my $html = $tx->render_string(
        q{[% header %][% content %][% footer %]},
        {
            content => mark_raw($content_html),
            header  => mark_raw($header),
            footer  => mark_raw($footer),
        }
    );
    return [
        200,
        [ 'Content-Type' => 'text/html', 'Content-Length' => length $html ],
        [$html]
    ];
}

sub local_or_share_file {
    my ( $self, $name ) = @_;
    my $local_name = File::Spec->catfile('share', $name);
    return $local_name if -f $local_name;
    return dist_file( 'Yomico', $name );
}

sub make_path {
    my ( $self, $path_info ) = @_;
    return $self->{root} if $path_info =~ m!^/$!;
    $path_info =~ s!^/!!;
    return File::Spec->catfile( $self->{root}, $path_info );
}

sub is_markdown {
    my ( $self, $path ) = @_;
    return unless -f $path;
    if( $path =~ m!\.(?:txt|md|mkdn|markdown|mkd|mark|mdown)! ) {
        return $path;
    }
    return;
}

1;
