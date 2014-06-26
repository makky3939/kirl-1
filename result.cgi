#!/usr/bin/ruby
# -*- coding: utf-8 -*-

require 'rubygems'
require 'cgi'
require 'sqlite3'
require './controller/controller.rb'
require './view/view.rb'

DB_FILE_PATH = 'model/library.db'
cgi = CGI.new

params = {
  'nbc'                     => CGI.escapeHTML(cgi['nbc']),
  'isbn'                    => CGI.escapeHTML(cgi['isbn']),
  'author'                  => CGI.escapeHTML(cgi['author']),
  'pub'                     => CGI.escapeHTML(cgi['pub']),
  'date'                    => CGI.escapeHTML(cgi['date']),
  'phys'                    => CGI.escapeHTML(cgi['phys']),
  'note'                    => CGI.escapeHTML(cgi['note']),
  'ed'                      => CGI.escapeHTML(cgi['ed']),
  'series'                  => CGI.escapeHTML(cgi['series']),
  'titleheading'            => CGI.escapeHTML(cgi['titleheading']),
  'authorheading'           => CGI.escapeHTML(cgi['authorheading']),
  'holdingsrecord'          => CGI.escapeHTML(cgi['holdingsrecord']),
  'holdingloc'              => CGI.escapeHTML(cgi['holdingloc']),
  'holdingphys'             => CGI.escapeHTML(cgi['holdingphys']),

  'input_1_text'            => CGI.escapeHTML(cgi['input_1_text']),
  'input_1_field'           => CGI.escapeHTML(cgi['input_1_field']),
  'input_1_operator_symbol' => CGI.escapeHTML(cgi['input_1_operator_symbol']),

  'input_2_text'            => CGI.escapeHTML(cgi['input_2_text']),
  'input_2_field'           => CGI.escapeHTML(cgi['input_2_field']),
  'input_2_operator_symbol' => CGI.escapeHTML(cgi['input_1_operator_symbol']),
  'input_3_text'            => CGI.escapeHTML(cgi['input_3_text']),
  'input_3_field'           => CGI.escapeHTML(cgi['input_3_field']),
  'input_3_operator_symbol' => CGI.escapeHTML(cgi['input_1_operator_symbol']),

  'limit'   => CGI.escapeHTML(cgi['limit']),
  'offset'  => CGI.escapeHTML(cgi['offset'])
}

if params['input_1_text'] != ''
  query = Query.new(params)
  SQLite3::Database.new DB_FILE_PATH do |db|
    @count  = db.execute query.count
    @result = db.execute query.select
  end
  if @count[0][0] == 0
    @result = '該当データが見つかりませんでした'
    view = View.new('検索結果', 'result_error', params, @result, 0)
  else
    view = View.new('検索結果', 'result', params, @result, @count)
  end
else
  result = '検索に失敗しました'
  view = View.new('検索結果', 'result_error', params, result, 0)
end

puts cgi.header({charset: 'utf-8', type: 'text/html'})
puts view.html

puts params
puts @result