# -*- coding: utf-8 -*-

class View
  def initialize(title='', type='error', params={}, data=[], count=[[0]])
    @attribute = {
      'nbc.nbc' => '全国書誌番号',
      'isbn.isbn' => 'ISBN番号',
      'book.title' => '書名',
      'book.author' => '著者',
      'book.pub' => '出版者',
      'book.date' => '出版年',
      'book.phys' => '形態',
      'note.note' => '注記',
      'ed.ed' => '版',
      'series.series' => 'シリーズ',
      'titleheading.titleheading' => 'タイトルの読み',
      'authorheading.authorheading' => '著者の読み',
      'holdingsrecord.holdingsrecord' => '所在情報の識別番号',
      'holdingloc.holdingloc' => '所在情報',
      'holdingphys.holdingphys' => '所在注記'
    }

    @range = {
      '20' => '20件',
      '40' => '40件',
      '60' => '60件'
    }

    @operator_symbol = {
      and: 'AND',
      or: 'OR',
      not: 'NOT'
    }

    @params = params
    @title  = title_tag title
    @head   = head
    @count = count[0][0]
    @page_header = ['<div class="container">', '</div>'].join(head_tag title)

    case type
    when 'result'
      @offset = integer_str?(@params['offset'])
      @range = integer_str?(@params['range'])
      @offset = 1 if @offset == 0
      @range = 20 if @range == 0
      @page_sto = @offset * @range
      @page_sta = @page_sto - @range
      @page_sta = 1 if @page_sta <= 0
      @page_last = ((@count/@range)+1)

      _table = table(data)
      _pagenation = pagenation
      _result_info = ['<div class="container">', '</div>'].join result_info()
      @body = body(@page_header + _result_info + _table + _pagenation)

    when 'detail'
      _detail = detail(data)
      @body = body(@page_header + _detail)

    when 'index'
      _form = form(data)
      @body = body(@page_header + _form)

    when 'multi'
      _detail_form = detail_form(data)
      @body = body(@page_header + _detail_form)

    when 'analysis'
      _analysis = analysis(data)
      @body = body(@page_header + _analysis)

    when 'error'
      _form = form()
      _error = error(data)
      @body = body(@page_header + _error + _form)

    when 'report'
      _report = report
      @body = body(@page_header + report)

    else
      _error = error('ページが存在しません')
      @body = body(_error)
    end
  end

  def html
    ['<html>', '</html>'].join(@head + @body)
  end

  private
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

  def asset
    <<-DOC
      <link href='css/style.css' rel='stylesheet'>
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

  def head_tag(text, size=1)
    ["<h#{size}>", "</h#{size}>"].join text
  end

  def error(data)
    error = ["<p class='error'>", "</p>"].join(data)
    ['<div class="container">', '</div>'].join error
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
      td << ['<td>', '</td>'].join("<a href='detail.cgi?nbc=#{row[0]}'> #{row[1]}</a>")
      td << ['<td>', '</td>'].join(row[2])
      td << ['<td>', '</td>'].join(row[3])
      td << ['<td>', '</td>'].join(row[4])
      tr << ['<tr>', '</tr>'].join(td)
    end
    tbody = ['<tbody>', '</tbody>'].join tr

    table = ['<table class="table">', '</table>'].join(thead + tbody)
    ['<div class="container">', '</div>'].join table
  end

  def result_info
    text = []
    text.push "<a href='result.cgi?input_1_text=#{@params["input_1_text"]}'>#{@params["input_1_text"]}</a>" if @params["input_1_text"] != ""
    text.push "<a href='result.cgi?input_1_text=#{@params["input_2_text"]}'>#{@params["input_2_text"]}</a>" if @params["input_2_text"] != ""
    text.push "<a href='result.cgi?input_1_text=#{@params["input_3_text"]}'>#{@params["input_3_text"]}</a>" if @params["input_3_text"] != ""
    <<-DOC
      <div class='col-xs-6'>
        <p class='lead'>#{text.join(', ')}で検索を行い、<span>#{@count}件</span>のうち<span>#{@page_sta}件</span>目から<span>#{@page_sto}件</span>目までを表示しています。</p>
      </div>
    DOC
  end

  def pagenation
    list = ''
    ((@count/@range)+1).times.each do |page|
      page = page + 1
      if page == @offset
        list << "<li><a href='javascript: pagenation_post(#{page})' class='active'>#{page}</a></li>"
      else
        list << "<li><a href='javascript: pagenation_post(#{page})'>#{page}</a></li>"
      end
    end
    <<-DOC
      <div class='container'>
        <form action='result.cgi' method='post' name='pagenation'>
          <input type='hidden' name='offset'>
          <input type='hidden' name='input_1_text'>
          <input type='hidden' name='input_1_field'>
          <input type='hidden' name='input_2_text'>
          <input type='hidden' name='input_2_field'>
          <input type='hidden' name='input_2_operator_symbol'>
          <input type='hidden' name='input_3_text'>
          <input type='hidden' name='input_3_field'>
          <input type='hidden' name='input_3_operator_symbol'>
        </form>
        <script type='text/javascript'>
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
        <div class='col-xs-6'>
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

  def form(data=['図書館', '英語'])
    <<-DOC
      <div class='container'>
        <div class='row'>
          <form method='POST' action='result.cgi' class='search-form-single'>
            <div class='input-group'>
              <p>検索キーワードを入力してください。(例: #{data.join(', ')}, <a href="analysis.cgi">etc</a>...)</p>
              <p>全角、または半角スペースを空けることで複数語での検索ができます。</p>
            </div>
            <div class='input-group'>
              <input value='' name='input_1_text' type='text' class='form-control' autofocus>
            </div>

            <div class='input-group'>
              <div class='form-group'>
                <input type='submit' class='btn btn-blue' value='検索'>
              </div>
            </div>
            <div class='input-group search-form-border'>
              <a href='multi.cgi' class="btn btn-white_blue">詳細検索</a>
              <a href='analysis.cgi' class="btn btn-white_blue">出現単語一覧</a>
              <a href='report.cgi' class="btn btn-white_blue" target=”_blank”>レポート</a>
            </div>
          </form>
        </div>
      </div>
    DOC
  end

  def detail_form(data=[])
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
      selected_key = ['book.title', 'book.author', 'book.pub']
      if n == 3
        <<-DOC
          <div class='input-group'>
            #{select_tag(@attribute, input_field, selected_key[n-1])}
            <input value='' name='input_#{n}_text' type='text' class='form-control'>
          </div>
        DOC
      else
        <<-DOC
          <div class='input-group'>
            #{select_tag(@attribute, input_field, selected_key[n-1])}
            <div class='form-group'>
              <input value='' name='input_#{n}_text' type='text' class='form-control'>
            </div>
            #{select_tag(@operator_symbol, select_tag)}  
          </div>
        DOC
      end
    end

    <<-DOC
      <div class='container'>
        <div class='row'>
          <form method='POST' action='result.cgi' class='form-inline search-form-multi'>
            <div class='input-group'>
              <p>検索キーワードを入力してください。(例: #{data.join(', ')}, <a href="analysis.cgi">etc</a>...)</p>
            </div>

            #{input_group(1)}
            #{input_group(2)}
            #{input_group(3)}

            <div class='input-group'>
              <div class='form-group'>
                <input type='submit' class='btn btn-blue' value='検索'>
                <input type='reset' class='btn btn-default' value='フォームを初期化'>
              </div>
            </div>
            <div class='input-group search-form-border'>
              <p>1ページあたりの表示件数 #{select_tag(@range, 'range', '20')}</p>
            </div>
          </form>
        </div>
      </div>
    DOC
  end

  def detail(data)
    def parse_data(data)
      parse_data = []
      (0..5).each do |i|
        parse_data.push data[0][i]
      end

      (6..15).each do |i|
        parse_data.push []
        data.each do |row|
          if !parse_data.last.include? row[i]
            parse_data.last.push row[i] if !row[i].nil?
          end
        end
      end
      parse_data
    end
    def detail_info(info, head)
      head = ['<h3>', '</h3>'].join head
      li = ''
      if info.size == 0
        li << ['<li>', '</li>'].join('データなし')
      else
        info.each do |item|
          li << ['<li>', '</li>'].join(item)
        end
      end
      ul = ['<ul>', '</ul>'].join li
      head << ul
    end
    data = parse_data data
    <<-DOC
      <div class='container'>
        <div class='col-xs-6'>
          <div class='book'>
            <p>#{data[0]} #{data[1]}</p>
            <div class='book-head'>
              <h1 class='book-head_title'>#{data[2]}</h1>
              <p class='book-author'>#{data[3]}</p>
            </div>

            <div class='book-publish'>
              <p>#{data[4]} #{data[5]}</p>
            </div>
          </div>
        </div>

        <div class='col-xs-6'>
          <dic class='book-info'>
            <div class="book-holding">
              #{detail_info(data[12], '所在情報の識別番号')}
              #{detail_info(data[13], '所在情報')}
              #{detail_info(data[14], '所在情報の注記')}
            </div>
            #{detail_info(data[6], '形態')}
            #{detail_info(data[7], '注記')}
            #{detail_info(data[8], '版表示')}
            #{detail_info(data[9], 'シリーズ名')}
            #{detail_info(data[10], 'タイトルの読み')}
            #{detail_info(data[11], '著者の読み')}
          </div>
        </div>
      </div>
      <div class='container'>
        <div class='col-xs-12 book-link'>
          <a class='btn btn-blue' href="javascript: booklink_post('author')">同じ著者の図書を検索する</a>
          <a class='btn btn-blue' href="javascript: booklink_post('series')">同じシリーズの図書を検索する</a>
          <a class='btn btn-blue' href="javascript: booklink_post('pub')">同じ出版者の図書を検索する</a>
        </div>
        <form action='result.cgi' method='post' name='book_link'>
          <input type='hidden' name='input_1_text'>
          <input type='hidden' name='input_1_field'>
        </form>
        <script type='text/javascript'>
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

  def analysis(data)
    analysis = ''
    comment = "<p class='lead'>登録されている図書のタイトルに２回以上出現したキーワードを表示しています。</p><p>括弧の中の数値は出現回数を示しており、単語をクリックするとその語を用いて検索を行います。</p><hr>"
    data.each_with_index do |row, index|
      analysis << "<a href='result.cgi?input_1_text=#{row[0]}'>#{row[0]}(#{row[1]})</a>"
      if (index % 100) == 0 && index != 0
        analysis << "<hr>" 
      end
    end
    ["<div class='container analysis'>#{comment}", "</div>"].join analysis
  end

  def report
    <<-DOC
      <div class='container report'>
        <h2>A.</h2>
        <div class="report-container">
          <p>201311495, 小林 正樹, 知識情報演習 I-1(GE11012), 火曜組</p>
        </div>

        <h2>B.</h2>
        <div class="report-container">
          <p><a href="http://cgi.u.tsukuba.ac.jp/~s1311495/kirl/index.cgi" target="_brank">http://cgi.u.tsukuba.ac.jp/~s1311495/kirl/index.cgi</a></p>
        </div>

        <h2>C.</h2>
        <div class="report-container">
          <dl>
            <dt>index.cgi</dt>
            <dd>トップページ。検索フォームと、詳細検索ページ等へのリンクがある。</dd>
            <dt>multi.cgi</dt>
            <dd>詳細検索を行うページ。トップページの検索フォームとは異なり、検索する対象の指定と論理演算子の設定ができる。</dd>
            <dt>result.cgi</dt>
            <dd>検索結果を表示するページ。検索結果一覧の表が表示され、詳細情報ページへのリンクがある。</dd> 
            <dt>detail.cgi</dt>
            <dd>詳細画面を表示するページ。該当の図書に関するすべての情報を表示し、同じ著者や、シリーズ、出版社の情報で検索を行うためのボタンが配置されている。</dd>
            <dt>analysis.cgi</dt>
            <dd>データベースのtitleカラムに対して形態素解析を行い、名詞のみを取り出したものとその出現回数が表示される。各名詞はリンクになっており、クリックするとその名詞で検索を実行する。</dd>
            <dt>report.cgi</dt>
            <dd>当ページ。このOPACに関する情報が記載されている。</dd>
            <dt>controller/controller.rb</dt>
            <dd>データベースを参照するための SQLを作成するQueryクラスが記述されている。フォームのパラメータを受け取り、パラメータに応じてSQLを生成する。</dd>
            <dt>view/view.rb</dt>
            <dd>各HTMLの要素が含まれたViewクラスが記述されている。データベースの検索結果やフォームのパラメータを受け取り、それらを元に、各種HTMLの要素やテーブルを作成する。そしてhtmlメソッドを実行するとそれらを元にHTMLを生成する。</dd>
          </dl>
        </div>

        <h2>D.</h2>
        <div class="report-container">
          <p>
            基本的な情報は、bookテーブルに格納するが、1つの図書に対して複数の値が存在する要素についてはそれぞれ別のテーブルに格納している。
            bookテーブル以外を参照する際にはnbcを主キーとして各項目を紐づけする。
            また形態素解析を行い、名詞の出現頻度を格納したテーブルを用意した。以下に作成したテーブルの一覧を示す。
          </p>
          <table>
            <thead>
              <tr><th>Book</th></tr>
            </thead>
            <tbody>
              <tr><td><span>nbc</span></td></tr>
              <tr><td>title</td></tr>
              <tr><td>author</td></tr>
              <tr><td>pub</td></tr>
              <tr><td>date</td></tr>
              <tr><td>phys</td></tr>
            </tbody>
          </table>

          <table>
            <thead>
              <tr><th>Isbn</th></tr>
            </thead>
            <tbody>
              <tr><td><span>nbc</span></td></tr>
              <tr><td>isbn</td></tr>
            </tbody>
          </table>

          <table>
            <thead>
              <tr><th>Ed</th></tr>
            </thead>
            <tbody>
              <tr><td><span>nbc</span></td></tr>
              <tr><td>ed</td></tr>
            </tbody>
          </table>

          <table>
            <thead>
              <tr><th>Series</th></tr>
            </thead>
            <tbody>
              <tr><td><span>nbc</span></td></tr>
              <tr><td>series</td></tr>
            </tbody>
          </table>

          <table>
            <thead>
              <tr><th>TitleHeading</th></tr>
            </thead>
            <tbody>
              <tr><td><span>nbc</span></td></tr>
              <tr><td>titleheading</td></tr>
            </tbody>
          </table>

          <table>
            <thead>
              <tr><th>AuthorHeading</th></tr>
            </thead>
            <tbody>
              <tr><td><span>nbc</span></td></tr>
              <tr><td>authorheading</td></tr>
            </tbody>
          </table>

          <table>
            <thead>
              <tr><th>HoldingsRecord</th></tr>
            </thead>
            <tbody>
              <tr><td><span>nbc</span></td></tr>
              <tr><td>holdingsrecord</td></tr>
            </tbody>
          </table>

          <table>
            <thead>
              <tr><th>HoldingLoc</th></tr>
            </thead>
            <tbody>
              <tr><td><span>nbc</span></td></tr>
              <tr><td>holdingloc</td></tr>
            </tbody>
          </table>

          <table>
            <thead>
              <tr><th>HoldingsRecord</th></tr>
            </thead>
            <tbody>
              <tr><td><span>nbc</span></td></tr>
              <tr><td>holdingsrecord</td></tr>
            </tbody>
          </table>

          <table>
            <thead>
              <tr><th>HoldingPhys</th></tr>
            </thead>
            <tbody>
              <tr><td><span>nbc</span></td></tr>
              <tr><td>holdingphys</td></tr>
            </tbody>
          </table>

          <table>
            <thead>
              <tr><th>Analysis</th></tr>
            </thead>
            <tbody>
              <tr><td>word</td></tr>
              <tr><td>count</td></tr>
            </tbody>
          </table>
        </div>

        <h2>E.</h2>
        <div class="report-container">
          <p>
            　HTMLは各CGIファイル内に記述するのではなく、Viewクラスを用意し、検索フォームやテーブルなどの部品ごとに分けてメソッドを実装した。
            インスタンス変数を初期化する際に、SQLでの参照結果などを受け取り、それらのデータを用いて各メソッドがHTMLの部品を作成する。
            そして、各CGIファイルからhtmlメソッドを実行することでHTMLを作成する。
            CGIファイル内ではインスタンス変数の作成と特定のメソッドの実行のみを行い、Viewクラス内において、共通できる処理は共通のメソッド、独立させたいメソッドは独立させることにより高いメンテナンス性と、ページの追加やレイアウトの変更などの際の高い柔軟性を実現している。<br>
            　またSQL文についてもQueryクラスを用意し、フォームから取得したパラメータを受け取ることで各ページにおいて必要なSQL文が呼び出せるようにした。
          </p>
        </div>

        <h2>F.</h2>
        <div class="report-container">
          <p>
            　図書のタイトルを対象に形態素解析を行い、名詞の出現回数を記録することで、データベースに含まれているデータが得意とする分野や概念のキーワードを、ユーザに提供することが出来るのではないかと考えた。
            当OPACでは全データにおける名詞の出現回数とその名詞を表示し、クリックすると検索が実行出来る、また、Topページの検索キーワードの例を示す部分でランダムな名詞を表示するだけの機能である。
            しかし、名詞を更に分析し、分野や概念ごとに色分けなどの処理を行うことで、検索キーワードの参考になる情報を提供する、又は検索キーワードを入力しなくても検索が行える機能を持ったOPACを開発することが出来るのではないかと感じた。
          </p>
        </div>
      </div>
    DOC
  end

  def header
    <<-DOC
      <div id='header'>
        <div class='container'>
          <div class='col-xs-6'>
            <a href='index.cgi' class='title'><h1>OPAC</h1></a>
          </div>
          <div class='col-xs-6'>
            <div class='col-xs-6'></div>
            <div class='col-xs-6'>
              <form method='POST' action='result.cgi'>
                <div class='input-group'>
                  <input value='' name='input_1_text' type='text' class='form-control' placeholder='ここからも検索できます'>
                  <span class='input-group-btn'>
                    <input type='submit' class='btn btn-blue form-control' value='検索'>
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
      <div id='footer'>
        <div class='container'>
          <div class='col-xs-6'>
            <p>&copy 2014 Masaki Kobayashi</p>
          </div>
          <div class='col-xs-6 links'>
            <p class='text-right'>
              <a href='index.cgi'>検索画面に戻る</a>
              <a href='#header'>一番上に戻る</a>
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