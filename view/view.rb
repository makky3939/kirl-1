# -*- coding: utf-8 -*-

class View
  def initialize(title='', type='error', params={}, data=[], count=[[0]])
    @attribute = {
      nbc: '全国書誌番号',
      isbn: 'ISBN番号',
      title: '書名',
      author: '著者',
      pub: '出版者',
      date: '出版年',
      phys: '形態',
      note: '注記',
      ed: '版',
      series: 'シリーズ',
      titleheading: 'タイトルの読み',
      authorheading: '著者の読み',
      holdingsrecord: '所在情報の識別番号',
      holdingloc: '所在情報',
      holdingphys: '所在注記'
    }

    @range ={
      '20' => '20件',
      '40' => '40件',
      '60' => '60件'
    }

    @operator_symbol = {and: 'AND', or: 'OR', not: 'NOT'}
    @params = params
    @title = title_tag title
    @head = head
    @page_header = ['<div class="container">', '</div>'].join(head_tag title)

    case type
    when 'result'
      @count = count[0][0]
      @offset = integer_str?(@params['offset'])
      @offset = 1 if @offset == 0
      @range = integer_str?(@params['range'])
      @range = 20 if @range == 0
      @page_sto = @offset * @range
      @page_sta = @page_sto - @range
      @page_sta = 1 if @page_sta <= 0
      @page_last = ((@count/@range)+1)

      _table = table(data)
      _pagenation = pagenation()
      _result_info = ['<div class="container">', '</div>'].join result_info()
      @body = body(@page_header + _result_info + _table + _pagenation)

    when 'detail'
      _detail = detail(data[0])
      @body = body(@page_header + _detail)

    when 'index'
      _form = form
      @body = body(@page_header + _form)

    when 'error'
      _detail_form = detail_form()
      _error = error(data)
      @body = body(@page_header + _error + _detail_form)

    else
      @body = body('ページがありません')
    end
  end

  def html
    ['<html>', '</html>'].join(@head + @body)
  end

  def head
    ['<head>', '</head>'].join(@title + asset + meta)
  end

  def title_tag(title)
    if title == ''
      title = 'OPAC'
    else
      title = "#{title} | OPAC"
    end
    ['<title>', '</title>'].join title
  end

  def head_tag(text, size=1)
    ["<h#{size}>", "</h#{size}>"].join text
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
      tr << ['<th>', '</th>'].join(th)
    end
    thead = ['<thead>', '</thead>'].join tr

    tr = ''
    data.each do |row|
      td = ''
      td << ['<td>', '</td>'].join(row[0])
      td << ['<td>', '</td>'].join("<a href='/detail.cgi?nbc=#{row[0]}'> #{row[1]}</a>")
      td << ['<td>', '</td>'].join(row[2])
      td << ['<td>', '</td>'].join(row[3])
      td << ['<td>', '</td>'].join(row[4])
      tr << ['<tr>', '</tr>'].join(td)
    end
    tbody = ['<tbody>', '</tbody>'].join tr

    table = ['<table class="table">', '</table>'].join(thead + tbody)
    ['<div class="container">', '</div>'].join table
  end

  def error(data)
    error = ["<p class='error'>", "</p>"].join(data)
    ['<div class="container">', '</div>'].join error
  end

  def result_info
    <<-DOC
      <div class="col-xs-6">
        <p class="lead">#{@count}件 のうち #{@page_sta}-#{@page_sto}件 を表示しています。</p>
      </div>
    DOC
  end

  def pagenation
    list = ""
    ((@count/@range)+1).times.each do |page|
      page = page + 1
      if page == @offset
        list << "<li><a href='javascript: pagenation_post(#{page})' class='active'>#{page}</a></li>"
      else
        list << "<li><a href='javascript: pagenation_post(#{page})'>#{page}</a></li>"
      end
    end
    <<-DOC
      <div class="container">
        <form action="result.cgi" method="post" name="pagenation">
          <input type="hidden" name="offset">
          <input type="hidden" name="input_1_text">
          <input type="hidden" name="input_1_field">
          <input type="hidden" name="input_2_text">
          <input type="hidden" name="input_2_field">
          <input type="hidden" name="input_2_operator_symbol">
          <input type="hidden" name="input_3_text">
          <input type="hidden" name="input_3_field">
          <input type="hidden" name="input_3_operator_symbol">
        </form>
        <script type="text/javascript">
          function pagenation_post(offset){
            pagenation.input_1_text.value = '#{@params["input_1_text"]}';
            pagenation.input_1_field.value = '#{@params["input_1_field"]}';

            pagenation.input_2_text.value = '#{@params["input_2_text"]}';
            pagenation.input_2_field.value = '#{@params["input_2_field"]}';
            pagenation.input_2_operator_symbol.value = '#{@params["input_2_operator_symbol"]}';

            pagenation.input_3_text.value = '#{@params["input_3_text"]}';
            pagenation.input_3_field.value = '#{@params["input_3_field"]}';
            pagenation.input_3_operator_symbol.value = '#{@params["input_3_operator_symbol"]}';

            pagenation.offset.value = offset;
            pagenation.submit();
          }
        </script>
        #{result_info}
        <div class="col-xs-6">
          <div class='text-center'>
            <ul class='pagination'>
              <li class='page_first'><a href='javascript: pagenation_post(#{@page_sta})'>&laquo;</a></li>
                #{list}
              <li class='page_last'><a href='javascript: pagenation_post(#{@page_last})'>&raquo;</a></li>
            </ul>
          </div>
        </div>
      </div>
    DOC
  end

  def form()
    <<-DOC
      <div class="container">
        <div class="row">
          <form method="POST" action="result.cgi" class="search-form-single">
            <div class="input-group">
              <p>検索キーワードを入力してください (例: 図書館学, 知識 情報, etc..)</p>
            </div>
            <div class="input-group">
              <input value='' name="input_1_text" type='text' class='form-control' autofocus>
            </div>

            <div class="input-group">
              <div class="form-group">
                <input type='submit' class='btn btn-blue' value="検索">
              </div>
            </div>
          </form>
        </div>
      </div>
    DOC
  end

  def detail_form()
    def select_tag(attr={}, name='', selected_key=false)
      select = ''
      option = ''
      attr.each do |key, value|
        if key == selected_key
          option << ["<option value='#{key}' selected>", "</option>"].join(value)
        else
          option << ["<option value='#{key}'>", "</option>"].join(value)
        end
      end
      select = ["<select name='#{name}' class='form-control'>", "</select>"].join option
      ["<span class='input-group-addon'>", "</span>"].join select
    end

    def input_group(n)
      input_field = "input_#{n}_field"
      select_tag = "input_#{n}_operator_symbol"
      selected_key = [:title, :author, :pub]
      if n == 3
        <<-DOC
          <div class="input-group">
            #{select_tag(@attribute, input_field, selected_key[n-1])}
            <input value='' name="input_#{n}_text" type='text' class='form-control'>
          </div>
        DOC
      else
        <<-DOC
          <div class="input-group">
            #{select_tag(@attribute, input_field, selected_key[n-1])}
            <div class="form-group">
              <input value='' name="input_#{n}_text" type='text' class='form-control'>
            </div>
            #{select_tag(@operator_symbol, select_tag)}  
          </div>
        DOC
      end
    end

    <<-DOC
      <div class="container">
        <div class="row">
          <form method="POST" action="result.cgi" class="form-inline">
                <div class="input-group">
                  <p>検索キーワードを入力してください (例: 図書館学, 知識 情報, etc..)</p>
                </div>

                #{input_group(1)}
                #{input_group(2)}
                #{input_group(3)}

                <div class="input-group">
                  <div class="form-group">
                    <input type='submit' class='btn btn-blue' value="検索">
                    <input type='reset' class='btn btn-default' value="フォームを初期化">
                  </div>
                </div>
                <p>1ページあたりの表示件数 #{select_tag(@range, 'range', '20')}</p>
          </form>
        </div>
      </div>
    DOC
  end

  def detail(data)
    def detail_info(info, head)
      head = ["<h3>", "</h3>"].join head
      li = ""
      if info.nil?
        li << ["<li>", "</li>"].join("データなし")
      else
        li << ["<li>", "</li>"].join(info)
      end
      ul = ["<ul>", "</ul>"].join li
      head << ul
    end
    <<-DOC
      <div class="container">
        <div class="col-xs-6">
          <div class="book">
            <p>#{data[0]} #{data[1]}</p>
            <div class="book-head">
              <h1 class="book-head_title">#{data[2]}</h1>
              <p class="book-author">#{data[3]}</p>
            </div>

            <div class="book-publish">
              <p>#{data[4]} #{data[5]}</p>
            </div>
          </div>
        </div>

        <div class="col-xs-6">
          <dic class="book-info">
            #{detail_info(data[6], "形態")}
            #{detail_info(data[7], "注記")}
            #{detail_info(data[8], "版表示")}
            #{detail_info(data[9], "シリーズ名")}
            #{detail_info(data[10], "タイトルの読み")}
            #{detail_info(data[11], "著者の読み")}
            #{detail_info(data[12], "所在情報の識別番号")}
            #{detail_info(data[13], "所在情報")}
            #{detail_info(data[14], "所在情報の注記")}
          </div>
        </div>
      </div>
      <div class="container">
        <div class="col-xs-12 book-link">
          <a class="btn btn-blue" href="javascript: booklink_post('author')">同じ著者の図書を検索する</a>
          <a class="btn btn-blue" href="javascript: booklink_post('series')">同じシリーズの図書を検索する</a>
          <a class="btn btn-blue" href="javascript: booklink_post('pub')">同じ出版者の図書を検索する</a>
        </div>
        <form action="result.cgi" method="post" name="book_link">
          <input type="hidden" name="input_1_text">
          <input type="hidden" name="input_1_field">
        </form>
        <script type="text/javascript">
          function booklink_post(type){
            if(type == "author"){
              book_link.input_1_text.value = '#{data[3]}';
              book_link.input_1_field.value = 'author';
            }else if(type == "series"){
              book_link.input_1_text.value = '#{data[9]}';
              book_link.input_1_field.value = 'series';
            }else if(type == "pub"){
              book_link.input_1_text.value = '#{data[4]}';
              book_link.input_1_field.value = 'pub';
            }
            book_link.submit();
          }
        </script>
      </div>
    DOC
  end

  def header
    <<-DOC
      <div id="header">
        <div class="container">
          <div class="col-xs-6">
            <a href="index.cgi" class="title"><h1>OPAC</h1></a>
          </div>
          <div class="col-xs-6">
            <div class="col-xs-6"></div>
            <div class="col-xs-6">
              <form method="POST" action="result.cgi">
                <div class='input-group'>
                  <input value="" name="input_1_text" type='text' class='form-control'>
                  <span class="input-group-btn">
                    <input type='submit' class='btn btn-blue form-control' value="検索">
                  </span>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
    DOC
  end

  def footer
    <<-DOC
      <div id="footer">
        <div class='container'>
          <div class="col-xs-6">
            <p>&copy 2014 Masaki Kobayashi</p>
          </div>
          <div class="col-xs-6 links">
            <p class="text-right">
              <a href="index.cgi">検索画面に戻る</a>
              <a href="#header">Topに戻る</a>
            </p>
          </div>
        </div>
      </div>
    DOC
  end

  def integer_str?(str)
    begin
      int = Integer(str)
    rescue ArgumentError
      int = 0
    end
    return int
  end
end