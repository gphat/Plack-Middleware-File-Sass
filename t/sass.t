use strict;
use Plack::App::File;
use Plack::Middleware::File::Sass;
use Test::More;
use Plack::Test;
use HTTP::Request::Common;

my $app = Plack::App::File->new(root => "t");
$app = Plack::Middleware::File::Sass->wrap($app);

test_psgi $app, sub {
    my $cb = shift;

    my $res = $cb->(GET "/");
    is $res->code, 404;

    $res = $cb->(GET "/foo.css");
    is $res->code, 200;
    is $res->content_type, 'text/css';
    like $res->content, qr/border-color: \#3bbfce/;

    $res = $cb->(GET "/bar.css");
    is $res->code, 200;
    is $res->content_type, 'text/css';
    like $res->content, qr/float: left/;
};

done_testing;
