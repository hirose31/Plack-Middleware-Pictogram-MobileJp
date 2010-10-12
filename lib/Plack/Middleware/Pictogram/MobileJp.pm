package Plack::Middleware::Pictogram::MobileJp;

use strict;
use warnings;
use parent qw/Plack::Middleware/;

use Plack::Util::Accessor qw( notation );
use HTTP::MobileAgent;

our $VERSION = '0.01';

sub new {
    my $class = shift;
    my $self  = $class->SUPER::new(@_);
    Plack::Util::load_class($self->_converter);
    return $self;
}

sub call {
    my($self, $env) = @_;

    return $self->_handle_pictogram($env);
}


sub _converter {
    my $self = shift;

    return 'HTML::Pictogram::MobileJp::' . do {
        if ($self->notation =~ /unicode/i) {
            'Unicode';
        } else {
            'EmojiNumber';
        }
    };
}

sub _handle_pictogram {
    my($self, $env) = @_;

    my $ma = HTTP::MobileAgent->new($env->{HTTP_USER_AGENT});

    my $res = $self->app->($env);

    $self->response_cb($res, sub {
        my $res = shift;

        return sub {
            my $chunk = shift;
            return unless defined $chunk;
            $chunk = $self->_converter->convert($ma, $chunk);
            return $chunk;
        };
    });
}

1;

__END__

=encoding utf-8

=head1 NAME

Plack::Middleware::Pictogram::MobileJp - convert emoji code into 3 carriers by user agent

=head1 SYNOPSIS

  enable "Pictogram::MobileJp", notation => "EmojiNumber";
    OR
  enable "Pictogram::MobileJp", notation => "Unicode";

=head1 DESCRIPTION

Plack::Middleware::Pictogram::MobileJp is a content text filter to
convert emoji code into suitable character code by user agent
(one of 3 mobile phone operators in Japan: DoCoMo, au, Softbank).

=head1 AUTHOR

HIROSE Masaaki E<lt>hirose31 _at_ gmail.comE<gt>

=head1 REPOSITORY

L<http://github.com/hirose31/plack-middleware-pictogram-mobilejp>

  git clone git://github.com/hirose31/plack-middleware-pictogram-mobilejp.git

patches and collaborators are welcome.

=head1 SEE ALSO

L<HTML::Pictogram::MobileJp>

=head1 COPYRIGHT & LICENSE

Copyright HIROSE Masaaki

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

