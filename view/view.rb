# -*- coding: utf-8 -*-
class View
  def initialize(title='opac', type, params, data, count)
    @attribute = {nbc: 'nbc', isbn: 'isbn', title: 'タイトル'}
    @operator_symbol = {and: 'and', or: 'or', not: 'not'}
    @params = params
    @title = title_tag title
    @head = head
    @page_header = head_tag title

    case type
    when 'result'
      _table = table(data)
      _pagenation = pagenation(count[0][0])
      @body = body(@page_header + _table + _pagenation)

    when 'detail'
      _detail = detail(data[0])
      @body = body(@page_header + _detail)

    when 'index'
      _form = form()
      _detail_form = detail_form()
      @body = body(@page_header + _detail_form)

    when "result_error", "detail_error"
      _error = error(data)
      @body = body(@page_header + _error)

    else
      @body = body("ページがありません")
    end
  end

  def html
    ['<html>', '</html>'].join(@head + @body)
  end

  def head
    ['<head>', '</head>'].join(@title + asset + meta)
  end

  def title_tag(title)
    ['<title>', '</title>'].join title
  end

  def head_tag(text, size=1)
    ['<h#{size}>', '</h#{size}>'].join text
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

  def body(content = '')
    ['<body>', '</body>'].join(header + content + footer)
  end

  def table(data)
    table = ''
    thead = ''
    tbody = ''

    tr = ''
    ['NBC', 'TITLE', 'AUTHOR', 'PUB', 'DATE'].each do |th|
      tr += ['<th>', '</th>'].join th
    end
    thead = ['<thead>', '</thead>'].join tr

    tr = ''
    data.each do |row|
      td = ''
      td += ['<td>', '</td>'].join row[0]
      td += ['<td>', '</td>'].join "<a href='/detail.cgi?nbc=#{row[0]}'> #{row[1]}</a>"
      td += ['<td>', '</td>'].join row[2]
      td += ['<td>', '</td>'].join row[3]
      td += ['<td>', '</td>'].join row[4]
      tr += ['<tr>', '</tr>'].join td
    end
    tbody = ['<tbody>', '</tbody>'].join tr

    ['<table>', '</table>'].join(thead + tbody)
  end

  def error(data)
    ["<p class='error'>", "</p>"].join(data)
  end

  def pagenation(count)
    def integer_str?(str)
      Integer(str)
      rescue ArgumentError
        0
    end
    page_sto = (integer_str? @params['offset']) * 20
    page_sta = page_sto - 20
    list = ""
    ((count/20)+1).times.each do |page|
      page = page + 1
      list += "<li><a href='javascript: pagenation_post(#{page})'>#{page}</a></li>"
    end
    <<-DOC
      <form action="result.cgi" method="post" name="pagenation">
        <input type="hidden" name="offset">
        <input type="hidden" name="input_1_text">
      </form>
      <script type="text/javascript">
        function pagenation_post(offset){
          pagenation.input_1_text.value = '#{@params["input_1_text"]}';
          pagenation.offset.value = offset;
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

  def form()
    <<-DOC
      <div class="container">
        <div class="row">
          <form method="POST" action="result.cgi">
            <div class="searchbox">
              <div class="searchbox-simple">
                <div class="input-group">
                  <p>検索キーワードを入力してください (例: 図書館学, 知識 情報, etc..)</p>
                </div>
                <div class="input-group">
                  <input value='title' name="input_1_field" type='text' class='form-control'>
                  <input value='' name="input_1_text" type='text' class='form-control'>
                  <input type='submit' class='btn btn-default' value="search">
                </div>
              </div>
            </div>
          </form>
        </div>
      </div>
    DOC
  end

  def detail_form()

    def select_tag(attr={}, name='', selected_key=false)
      option = ''
      attr.each do |key, value|
        if key == selected_key
          option << ["<option value='#{key}' selected>", "</option>"].join(value)
        else
          option << ["<option value='#{key}'>", "</option>"].join(value)
        end
      end
      ["<select name='#{name}'>", "</select>"].join option
    end

    def input_group(n)
      input_field = "input_#{n}_field"
      select_tag = "input_#{n}_operator_symbol"
      if n == 3
        <<-DOC
          <div class="input-group">
            #{select_tag(@attribute, input_field, :title)}
            <input value='' name="input_#{n}_text" type='text' class='form-control'>
          </div>
        DOC
      else
        <<-DOC
          <div class="input-group">
            #{select_tag(@attribute, input_field, :title)}
            <input value='' name="input_#{n}_text" type='text' class='form-control'>
            #{select_tag(@operator_symbol, select_tag)}
          </div>
        DOC
      end
    end

    <<-DOC
      <div class="container">
        <div class="row">
          <form method="POST" action="result.cgi">
            <div class="searchbox">
              <div class="searchbox-simple">
                <div class="input-group">
                  <p>検索キーワードを入力してください (例: 図書館学, 知識 情報, etc..)</p>
                </div>

                #{input_group(1)}
                #{input_group(2)}
                #{input_group(3)}

                <div class="button-group">
                  <input type='submit' class='btn btn-default' value="search">
                  <input type='reset' class='btn btn-default' value="reset">
                </div>

                <div class="input-group">
                  <input type="checkbox" id="check_nbc"><label for="check_nbc"> NBC </label>
                </div>

              </div>
            </div>
          </form>
        </div>
      </div>
    DOC
  end

  def detail(data)
    li = ""
    data.each do |value|
      li += ["<li>", "</li>"].join value
    end
    ["<ul>", "</ul>"].join li
  end

  def header
    <<-DOC
      <div id="header">
        <div class="container">
          <div class="row">
            <div class="col-xs-6 head-title"><a href="index.cgi">
                <h1>opac</h1></a></div>
            <div class="col-xs-6">
              <form method="POST" action="result.cgi">
                <div class='col-xs-6 pull-right head-searchform'>
                  <div class='input-group'>
                    <input value="" name="input_1_text" type='text' class='form-control'>
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
