#!/usr/bin/ruby
require 'rubygems'
require 'cgi'
require 'sqlite3'

print "Content-type: text/html\r\n"

puts ""
puts ""
puts <<-EOS
<html>
<form method="POST" action="result.cgi">
  <div class='col-xs-6 pull-right head-searchform'>
    <div class='input-group'>
      <input value="" name="keyword" type='text' class='form-control'>
      <input type='submit' class='btn btn-default' value="sub">
    </div>
  </div>
</form>
</html>
EOS

# <!DOCTYPE html>
# <html>
#   <head>
#     <title>opac</title>
#     <meta charset="UTF-8">
#     <meta content="width=device-width, initial-scale=1.0" name="viewport">
#     <meta content="" property="keywords">
#     <meta content="" property="og:title">
#     <meta content="website" property="og:type">
#     <meta content="" property="og:description">
#     <meta content="" property="og:url">
#     <meta content="" property="og:site_name">
#     <script src="/lib/jquery/dist/jquery.js"></script>
#     <link href="/lib/bootstrap/dist/css/bootstrap.css" rel="stylesheet">
#     <link href="/css/style.css" rel="stylesheet">
#   </head>
#   <body>
#     <div id="header">
#       <div class="container">
#         <div class="row">
#           <div class="col-xs-6 head-title"><a href="index.html">
#               <h1>opac</h1></a></div>
#           <div class="col-xs-6">
#             <div class="col-xs-6 pull-right head-searchform">
#               <div class="input-group">
#                 <input type="text" class="form-control"><span class="input-group-btn">
#                   <button type="button" class="btn btn-default"><span class="glyphicon glyphicon-search"></span></button></span>
#               </div>
#             </div>
#           </div>
#         </div>
#         <hr>
#       </div>
#     </div>
#     <div class="container">
#       <div class="row">
#         <div class="searchbox">
#           <div class="searchbox-simple">
#             <div class="input-group">
#               <p>検索キーワードを入力してください (例: 図書館学, 知識 情報, etc..)</p>
#             </div>
#             <div class="input-group">
#               <input type="text" class="form-control"><span class="input-group-btn">
#                 <button type="button" class="btn btn-default"><span class="glyphicon glyphicon-search"></span></button></span>
#             </div>
#           </div>
#         </div>
#       </div>
#     </div>
#     <div class="container">
#       <div class="row"><a href="result.html">result</a></div>
#     </div>
#     <div id="footer">
#       <div class="container">
#         <hr>
#         <p class="pull-right">&copy 2014 Masaki Kobayashi</p>
#       </div>
#     </div>
#   </body>
# </html>