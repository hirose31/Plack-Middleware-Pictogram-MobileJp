# -*- mode: cperl; -*-

use Plack::App::Directory;

my $app = Plack::App::Directory->new({ root => '.' })->to_app;

use Plack::Builder;
builder {
    enable "Pictogram::MobileJp",
        notation => 'Unicode';
    $app;
}

__END__
