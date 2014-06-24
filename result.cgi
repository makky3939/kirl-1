#!/usr/bin/ruby
# -*- coding: utf-8 -*-

require 'rubygems'
require 'cgi'
require 'sqlite3'
require './view/view.rb'

DB_FILE_PATH = 'model/library.db'

cgi = CGI.new
keyword =  CGI.escapeHTML cgi["keyword"]

# Pagenation
limit_size =  CGI.escapeHTML cgi["limit_size"]
offset =  CGI.escapeHTML cgi["offset"]

@params = {}
@params["keyword"] = keyword
@params["limit_size"] = limit_size
@params["offset"] = offset


def integer_str?(str)
  begin
    int = Integer(str)
  rescue ArgumentError
    int = nil
  end
  return int
end

def limit(offset=1, limit_size = 20)
  if integer_str? offset
    offset = offset.to_i
  else
    offset = 1
  end
  limit = limit_size
  offset = (limit_size * (offset - 1))
  "#{offset}, #{limit}"
end

query = {
select: {
book:<<-SQL,
  SELECT * 
  FROM book 
  WHERE title 
  LIKE '%#{keyword}%'
  LIMIT #{limit(cgi['offset'])}
SQL

count:<<-SQL,
  SELECT count(*)
  FROM book 
  WHERE title 
  LIKE '%#{keyword}%'
SQL

isbn:<<SQL,
  select * from isbn;
SQL
}
}

if keyword != ""
  SQLite3::Database.new DB_FILE_PATH do |db|
    @count = db.execute(query[:select][:count])
    @result = db.execute(query[:select][:book])
  end
  view = View.new('検索結果', 'result', @result, @count[0], @params)
else
  @result = "検索に失敗しました"
  view = View.new('検索結果', 'result_error', @result, @params)
end

puts view.html  
puts @params