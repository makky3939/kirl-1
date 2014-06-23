class View
  def initialize(title="opac", type="top", data)
    puts "Content-type: text/html\r\n"
    puts ""
    puts ""
    @title = title_tag title
    @head = head
    @page_header = ["<h1>", "</h1>"].join title
    case type
      when "result" then
        table = table(data)
        
        _pagenation = pagenation
        @body = body(@page_header + table + _pagenation)
      else
        @body = body
    end
  end

  def html
    ["<html>", "</html>"].join(@head + @body)
  end

  def head
    ["<head>", "</head>"].join(@title + asset + meta)
  end

  def title_tag(title)
    ["<title>", "</title>"].join title
  end

  def asset
    <<-DOC
      <script src='/lib/jquery/dist/jquery.js'></script>
      <link href='/css/style.css' rel='stylesheet'>
    DOC
  end

  def meta
    <<-DOC
      <meta charset='UTF-8'>
      <meta content='width=device-width, initial-scale=1.0' name='viewport'>
      <meta content='' property='keywords'>
      <meta content='' property='og:title'>
      <meta content='website' property='og:type'>
      <meta content='' property='og:description'>
      <meta content='' property='og:url'>
      <meta content='' property='og:site_name'>
    DOC
  end

  def body(content = "")
    ["<body>", "</body>"].join(header + content + footer)
  end

  def table(data)
    table = ""
    data.each do |row|
      tr = ""
      tr += ["<td>", "</td>"].join row[0]
      tr += ["<td>", "</td>"].join "<a href=""> #{row[1]}</a>"
      tr += ["<td>", "</td>"].join row[2]
      tr += ["<td>", "</td>"].join row[3]
      tr += ["<td>", "</td>"].join row[4]
      table += ["<tr>", "</tr>"].join tr
    end
    ["<table>", "</table>"].join table
  end

  def pagenation
    <<-DOC
      <div class='text-center'>
        <ul class='pagination'>
          <li class='disabled'><a href='#'>&laquo;</a></li>
          <li class='active'><a href='#'>1<span class='sr-only'>(current)</span></a></li>
          <li><a href='#'>2</a></li>
          <li><a href='#'>3</a></li>
          <li><a href='#'>4</a></li>
          <li class='disabled'><a href='#'>&raquo;</a></li>
        </ul>
      </div>
    DOC
  end

  def header
    <<-DOC
      <div id="header">
        <div class="container">
          <div class="row">
            <div class="col-xs-6 head-title"><a href="index.html">
                <h1>opac</h1></a></div>
            <div class="col-xs-6">
              <form method="POST" action="result.cgi">
                <div class='col-xs-6 pull-right head-searchform'>
                  <div class='input-group'>
                    <input value="" name="keyword" type='text' class='form-control'>
                    <input type='submit' class='btn btn-default' value="search">
                  </div>
                </div>
              </form>
            </div>
          </div>
          <hr>
        </div>
      </div>
    DOC
  end

  def footer
    <<-DOC
      <div id='footer'>
        <div class='container'>
          <hr>
          <p class='pull-right'>&copy 2014 Masaki Kobayashi</p>
        </div>
      </div>
    DOC
  end
end


#   puts <<-EOS
#     <!DOCTYPE html>
#     <html>
#     <head>
#         <title>検索結果</title>
#         <meta charset='UTF-8'>
#         <meta content='width=device-width, initial-scale=1.0' name='viewport'>
#         <meta content='' property='keywords'>
#         <meta content='' property='og:title'>
#         <meta content='website' property='og:type'>
#         <meta content='' property='og:description'>
#         <meta content='' property='og:url'>
#         <meta content='' property='og:site_name'>
#         <script src='/lib/jquery/dist/jquery.js'></script>
#         <link href='/css/style.css' rel='stylesheet'>
#       </head>
#       <body>
#         <div id='header'>
#           <div class='container'>
#             <div class='row'>
#               <div class='col-xs-6 head-title'><a href='index.cgi'>
#                   <h1>opac</h1></a></div>
#               <div class='col-xs-6'>
#                 <form method="POST" action="result.cgi">
#                   <div class='col-xs-6 pull-right head-searchform'>
#                     <div class='input-group'>
#                       <input value="" name="keyword" type='text' class='form-control'>
#                       <input type='submit' class='btn btn-default' value="search">
#                     </div>
#                   </div>
#                 </form>
#               </div>
#             </div>
#             <hr>
#           </div>
#         </div>
#         <div class='container'>
#           <h1>検索結果</h1>
#           <p><b></b>の検索結果 <b>#{search_result_length}件</b>中<b>1-20件</b>を表示しています</p>
#           <table class='table table-border'>
#             <thead>
#               <tr>
#                 <th>NBC</th>
#                 <th>Title</th>
#                 <th>Author</th>
#                 <th>Pub</th>
#                 <th>Isbn</th>
#               </tr>
#             </thead>
#             <tbody>
#               #{table}
#             </tbody>
#           </table>
#           <div class='text-center'>
#             <ul class='pagination'>
#               <li class='disabled'><a href='#'>&laquo;</a></li>
#               <li class='active'><a href='#'>1<span class='sr-only'>(current)</span></a></li>
#               <li><a href='#'>2</a></li>
#               <li><a href='#'>3</a></li>
#               <li><a href='#'>4</a></li>
#               <li class='disabled'><a href='#'>&raquo;</a></li>
#             </ul>
#           </div>
#         </div>
#         <div id='footer'>
#           <div class='container'>
#             <hr>
#             <p class='pull-right'>&copy 2014 Masaki Kobayashi</p>
#           </div>
#         </div>
#       </body>
#     </html>
#   EOS
# end
