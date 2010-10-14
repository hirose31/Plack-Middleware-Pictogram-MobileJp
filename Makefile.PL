use inc::Module::Install;
#use Module::Install::AuthorTests;
#use Module::Install::Repository;

name     'Plack-Middleware-Pictogram-MobileJp';
all_from 'lib/Plack/Middleware/Pictogram/MobileJp.pm';
license  'perl';
#homepage 'http://';
auto_set_repository;

requires 'parent';
requires 'Plack::Middleware';
requires 'HTTP::MobileAgent';
requires 'HTML::Pictogram::MobileJp';

test_requires 'Test::More';
test_requires 'Test::TCP';

tests_recursive;
author_tests 'xt';

use_test_base;
WriteAll;
