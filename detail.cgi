<!DOCTYPE html>
<html>
  <head>
    <title>詳細情報</title>
    <meta charset="UTF-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <meta content="" property="keywords">
    <meta content="" property="og:title">
    <meta content="website" property="og:type">
    <meta content="" property="og:description">
    <meta content="" property="og:url">
    <meta content="" property="og:site_name">
    <script src="/lib/jquery/dist/jquery.js"></script>
    <link href="/lib/bootstrap/dist/css/bootstrap.css" rel="stylesheet">
    <link href="/css/style.css" rel="stylesheet">
  </head>
  <body>
    <div id="header">
      <div class="container">
        <div class="row">
          <div class="col-xs-6 head-title"><a href="index.html">
              <h1>opac</h1></a></div>
          <div class="col-xs-6">
            <div class="col-xs-6 pull-right head-searchform">
              <div class="input-group">
                <input type="text" class="form-control"><span class="input-group-btn">
                  <button type="button" class="btn btn-default"><span class="glyphicon glyphicon-search"></span></button></span>
              </div>
            </div>
          </div>
        </div>
        <hr>
      </div>
    </div>
    <div class="container">
      <h1>{title} の詳細情報</h1>
      <div class="col-md-5">
        <div class="panel book">
          <p>NBC - ISBN</p>
          <div class="book-head">
            <p class="book-head_series">SERIES</p>
            <h2 class="book-head_title">TITLE<small class="book-head_ed">ED</small></h2>
          </div>
          <p class="book-author">AUTHOR</p>
          <div class="book-publish">
            <p>PUB - DATE</p>
            <p>PHYS</p>
          </div>
        </div>
      </div>
      <div class="col-md-7">
        <div class="panel panel-default">
          <div class="panel-body">
            <h4>NOTE</h4>
            <ul>
              <li>hoge</li>
              <li>...</li>
            </ul>
            <h4>TITLEHEADING</h4>
            <ul>
              <li>hoge</li>
              <li>...</li>
            </ul>
            <h4>AUTHORHEADING</h4>
            <ul>
              <li>hoge</li>
              <li>...</li>
            </ul>
            <h4>HOLDINGSRECORD</h4>
            <ul>
              <li>hoge</li>
              <li>...</li>
            </ul>
            <h4>HOLDINGLOC</h4>
            <ul>
              <li>hoge</li>
              <li>...</li>
            </ul>
            <h4>HOLDINGPHYS</h4>
            <ul>
              <li>hoge</li>
              <li>...</li>
            </ul>
          </div>
        </div>
      </div>
    </div>
    <div id="footer">
      <div class="container">
        <hr>
        <p class="pull-right">&copy 2014 Masaki Kobayashi</p>
      </div>
    </div>
  </body>
</html>