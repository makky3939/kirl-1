class View
  def initialize(title="opac", type="top", data, count, params)
    puts "Content-type: text/html\r\n"
    puts ""
    puts ""
    @params = params
    @title = title_tag title
    @head = head
    @page_header = ["<h1>", "</h1>"].join title
    case type
      when "result" then
        table = table(data)
        
        _pagenation = pagenation(count[0])
        @body = body(@page_header + table + _pagenation)

      when "result_error" then
        _error = error(data)
        @body = body(@page_header + _error)
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

  def error(data)
    ["<p>", "</p>"].join(data)
  end

  def pagenation(count)
    def integer_str?(str)
      Integer(str)
      rescue ArgumentError
        0
    end
    page_sto = (integer_str? @params["offset"]) * 20
    page_sta = page_sto - 20
    list = ""
    ((count/20)+1).times.each do |page|
      page = page + 1
      list += "<li><a href='javascript: pagenation_post(#{page})'>#{page}</a></li>"
    end
    <<-DOC
      <form action="result.cgi" method="post" name="pagenation">
        <input type="hidden" name="offset">
        <input type="hidden" name="keyword">
      </form>
      <script type="text/javascript">
        function pagenation_post(offset){
          pagenation.keyword.value = "#{@params["keyword"]}"
          pagenation.offset.value = offset
          pagenation.submit();
        }
      </script>
      <p>#{count}件 のうち #{page_sta}-#{page_sto}件 を表示しています。</p>
      <div class='text-center'>
        <ul class='pagination'>
          <li class='disabled'><a href='#'>&laquo;</a></li>
          #{list}
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
