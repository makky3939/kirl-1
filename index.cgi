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
  'input_1_text'            => CGI.escapeHTML(cgi['input_1_text']),
  'input_1_field'           => CGI.escapeHTML(cgi['input_1_field']),

  'input_2_text'            => CGI.escapeHTML(cgi['input_2_text']),
  'input_2_field'           => CGI.escapeHTML(cgi['input_2_field']),
  'input_2_operator_symbol' => CGI.escapeHTML(cgi['input_1_operator_symbol']),

  'input_3_text'            => CGI.escapeHTML(cgi['input_3_text']),
  'input_3_field'           => CGI.escapeHTML(cgi['input_3_field']),
  'input_3_operator_symbol' => CGI.escapeHTML(cgi['input_1_operator_symbol']),

  'nbc'     => CGI.escapeHTML(cgi['nbc']),
  'range'   => CGI.escapeHTML(cgi['range']),
  'limit'   => CGI.escapeHTML(cgi['limit']),
  'offset'  => CGI.escapeHTML(cgi['offset'])
}

query = Query.new(params)
SQLite3::Database.new DB_FILE_PATH do |db|
  @random  = db.execute query.analysis_random
end

view = View.new('', 'index', params, @random)
puts cgi.header({charset: 'utf-8', type: 'text/html'})
puts view.html

# puts params