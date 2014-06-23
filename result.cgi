#!/usr/bin/ruby
# -*- coding: utf-8 -*-

require 'rubygems'
require 'cgi'
require 'sqlite3'
require './view/view.rb'

DB_FILE_PATH = 'model/library.db'

cgi = CGI.new
keyword =  CGI.escapeHTML cgi["keyword"]

query = {
select: {
book:<<-SQL,
  select * from book where title like '%#{keyword}%' LIMIT 0, 20;
SQL

isbn:<<SQL,
  select * from isbn;
SQL
}
}

SQLite3::Database.new DB_FILE_PATH do |db|
  @result = db.execute(query[:select][:book])
end

view = View.new("検索結果", "result", @result)
puts view.html
