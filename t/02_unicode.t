# -*- mode: cperl -*-
use strict;
use utf8;
use Test::Base;
use Test::MobileAgent qw(:all);
use HTTP::MobileAgent;
use Encode;
use Plack::Builder;
use Plack::Test;
use Plack::Middleware::Pictogram::MobileJp;

plan tests => 1 * blocks;

my $notation = 'Unicode';

sub bytestring { Encode::encode('cp932', $_[0]); }

filters { expected => ['bytestring']  };

run {
    my $block = shift;

    my $app = builder {
        enable 'Pictogram::MobileJp', notation => $notation;
        sub { [200, [ 'Content-Type' => 'text/plain; charset=shift_jis' ], [ $block->input ]] };
    };

    test_psgi
        app    => sub {
            my $env = shift;
            my $res = $app->($env);
            $res->[2][0] = bytestring($res->[2][0]);
            return $res;
        },
        client => sub {
            my $cb = shift;

            my %env = test_mobile_agent_env($block->ua);
            $ENV{$_} = $env{$_} for keys %env;

            my $req = HTTP::Request->new(GET => "http://localhost/");
            my $res = $cb->($req);
            is( $res->content, $block->expected );
        };
}

__END__
=== docomo
--- ua:       docomo
--- input:    &#xE63E;
--- expected: &#xE63E;

=== ezweb
--- ua:       ezweb
--- input:    &#xE63E;
--- expected: <img localsrc="44" />

=== softbank
--- ua:       softbank
--- input:    &#xE63E;
--- expected: &#xE04A;

=== nonmobile
--- ua:       nonmobile
--- input:    &#xE63E;
--- expected: &#xE63E;

=== docomo extend
--- ua:       docomo
--- input:    &#xE70C;
--- expected: &#xE70C;

=== softbank unmapped
--- ua:       softbank
--- input:    &#xE69A;
--- expected: &#xE69A;


