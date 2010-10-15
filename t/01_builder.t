# -*- mode: cperl -*-
use strict;
use Test::More tests => 1;
use Test::MobileAgent qw(:all);
use HTTP::MobileAgent;

use Plack::Builder;
use Plack::Test;
use Plack::Middleware::Pictogram::MobileJp;

{
    my $app = builder {
        enable 'Pictogram::MobileJp', notation => 'EmojiNumber';
        sub { [200, [ 'Content-Type' => 'text/plain' ], [ "[emoji:1]" ]] };
    };

    test_psgi
        app => $app,
        client => sub {
            my $cb = shift;

            my %env = test_mobile_agent_env('docomo');
            $ENV{$_} = $env{$_} for keys %env;

            my $req = HTTP::Request->new(GET => "http://localhost/");
            my $res = $cb->($req);
            like( $res->content, qr/&#xE63E;/ );
        };
}

