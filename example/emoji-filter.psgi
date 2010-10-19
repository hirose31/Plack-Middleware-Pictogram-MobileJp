# -*- mode: cperl; -*-
#
# 3キャリア対応絵文字入りの HTML の実機確認用に。
#
# $TMPL_DIR 配下のファイルの内容を返す。
#   ファイルは shift_jis で書かれているのを期待している。
#   出力は shift_jis に変換して返す。
#   &#xXXXX; を、クライアントのキャリアに応じた絵文字コードに変換する。
#   Xslate を使っているのは、共通ヘッダとフッタを include したいから。
#   変換対象のパスを限定したいなら、Plack::Builder::Conditionals を併用す
#   るのがいいと思います。
#     http://github.com/kazeburo/Plack-Builder-Conditionals
# Static でそのまま返すものも指定できる。
#

use Text::Xslate;
use Encode;
use Plack::App::Directory;

my $TMPL_DIR   = '/web/example.jp/tmpl';
my $STATIC_DIR = '/web/example.jp/htdocs';

my $xslate = Text::Xslate->new(
    path        => [$TMPL_DIR],
    cache       => 0,
    input_layer => ':encoding(cp932)',
    syntax      => 'TTerse',
    suffix      => '.html',
   );

my $app = sub {
    $env = shift;

    my $path = $env->{PATH_INFO};
    # $path .= '.tx' unless $path =~ /\.tx$/;
    my $code = 200;

    my %vars = (
        username => 'hirose31',
       );

    if (-d "$TMPL_DIR/$path") {
        return Plack::App::Directory->new({
            root     => $TMPL_DIR,
            encoding => "shift_jis",
        })->to_app->($env);
    } else {
        my $body = Encode::encode('cp932', $xslate->render($path, \%vars));

        return [$code,
                ['Content-Type'   => 'application/xhtml+xml; charset=shift_jis',
                 'Content-Length' => length($body)],
                [$body]];
    }
};

use Plack::Builder;
builder {
    enable "Pictogram::MobileJp",
        notation => 'Unicode';
    enable "Static",
        path => qr{\.(gif|png|jpe?g)},
        root => $STATIC_DIR;
    $app;
}

__END__
