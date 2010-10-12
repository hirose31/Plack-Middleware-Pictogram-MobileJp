use inc::Module::Install;

name     'Plack-Middleware-Pictogram-MobileJp';
all_from 'lib/Plack/Middleware/Pictogram/MobileJp.pm';
license  'perl';

requires 'parent';
requires 'Plack::Middleware';
requires 'HTTP::MobileAgent';
requires 'HTML::Pictogram::MobileJp';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
use_test_base;
auto_include;
WriteAll;
