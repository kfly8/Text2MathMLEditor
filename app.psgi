use 5.10.0;
use Amon2::Lite;

use Data::Dumper;
use Text::ASCIIMathML;

# XXX
sub text2mathml {
    my $raw_text = shift;

    state $parser = new Text::ASCIIMathML();
    my @lines = split(/\n/, $raw_text);
    my @converted_lines;

    for my $line ( @lines ) {
        my $mathMLTree = $parser->TextToMathMLTree($line);
        push @converted_lines => $mathMLTree->text() if $mathMLTree;
    }

    return join '<br/>', @converted_lines;
}

get '/' => sub {
    my $c = shift;
    return $c->render('index.tx', {});
};

post '/' => sub {
    my $c = shift;

    my $raw_text = $c->req->param('raw_txt');
    my $math_ml_text = text2mathml($raw_text);

    return $c->render('index.tx', {
        raw_txt => $raw_text,
        converted_txt => $math_ml_text,
    });
};

__PACKAGE__->to_app(handle_static => 1);

__DATA__

@@ index.tx
<!DOCTYPE html>
<html>
  <head>
    <link rel="stylesheet" href="https://display-mathml.googlecode.com/hg/display-mathml.css?r=stable" />
    <link href="//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.1/css/bootstrap-combined.min.css" rel="stylesheet">
    <script src="https://display-mathml.googlecode.com/hg/display-mathml.js?r=stable"></script>
    <script src="http://code.jquery.com/jquery-1.9.1.min.js"></script>
    <script src="//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.1/js/bootstrap.min.js"></script>
  </head>
  <body>
    <div class="container">
      <div class="page-header">
        <h1>text2MathML</h1>
      </div>
      <p>
        <form method="POST">
          <textarea name="raw_txt" id="raw_txt" rows=5 class="input-block-level help-block">[% raw_txt %]</textarea>
          <input type="submit" class="btn btn-block">
        </form>
      </p>
      <p>
        <div id="preview_container" data-mathml=[% converted_txt %] >
            [% converted_txt | mark_raw %]
        </div>
      </p>
    </div>
    <script text/javascript>
        (function($){
            $('#preview_container').on('click', function(){
                alert($(this).data('mathml'));
            });
        })(jQuery)
    </script>
  </body>
</html>
