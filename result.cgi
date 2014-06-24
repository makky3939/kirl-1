#!/usr/bin/ruby
# -*- coding: utf-8 -*-

require 'rubygems'
require 'cgi'
require 'sqlite3'
require './controller/controller.rb'
require './view/view.rb'

DB_FILE_PATH = 'model/library.db'

cgi = CGI.new

params = {}
params["keyword"] = CGI.escapeHTML cgi["keyword"]
params["limit"]   = CGI.escapeHTML cgi["limit"]
params["offset"]  = CGI.escapeHTML cgi["offset"]


if params["keyword"] != ""
  query = Query.new(params)
  SQLite3::Database.new DB_FILE_PATH do |db|
    @count  = db.execute query.count
    @result = db.execute query.select
  end
  view = View.new('検索結果', 'result', params, @result, @count)
else
  result = "検索に失敗しました"
  view = View.new('検索結果', 'result_error', params, result)
end

# result = "検索に失敗しました"
# view = View.new('検索結果', 'result_error', result, params)

puts cgi.header({charset: "utf-8", type: "text/html"})
puts view.html
puts params