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
  "nbc"            => CGI.escapeHTML(cgi["nbc"]),
  "isbn"           => CGI.escapeHTML(cgi["isbn"]),
  "author"         => CGI.escapeHTML(cgi["author"]),
  "pub"            => CGI.escapeHTML(cgi["pub"]),
  "date"           => CGI.escapeHTML(cgi["date"]),
  "phys"           => CGI.escapeHTML(cgi["phys"]),
  "note"           => CGI.escapeHTML(cgi["note"]),
  "ed"             => CGI.escapeHTML(cgi["ed"]),
  "series"         => CGI.escapeHTML(cgi["series"]),
  "titleheading"   => CGI.escapeHTML(cgi["titleheading"]),
  "authorheading"  => CGI.escapeHTML(cgi["authorheading"]),
  "holdingsrecord" => CGI.escapeHTML(cgi["holdingsrecord"]),
  "holdingloc"     => CGI.escapeHTML(cgi["holdingloc"]),
  "holdingphys"    => CGI.escapeHTML(cgi["holdingphys"]),

  "keyword" => CGI.escapeHTML(cgi["keyword"]),
  "limit"   => CGI.escapeHTML(cgi["limit"]),
  "offset"  => CGI.escapeHTML(cgi["offset"])
}

view = View.new('index', 'index', params, "", 0)
puts cgi.header({charset: "utf-8", type: "text/html"})
puts view.html
puts params
