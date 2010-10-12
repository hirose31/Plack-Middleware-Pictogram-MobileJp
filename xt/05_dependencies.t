# -*- mode: cperl; -*-
use Test::Dependencies
    exclude => [qw(Test::Dependencies Test::Base Test::Perl::Critic
                   Plack::Middleware::Pictogram::MobileJp)],
    style   => 'light';
ok_dependencies();
