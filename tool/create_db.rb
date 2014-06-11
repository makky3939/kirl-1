#!/usr/bin/ruby
# -*- coding: utf-8 -*-
require "rubygems"
require "sqlite3"

file_path = "jbisc.min.txt"

@records = []

query = {
create:<<SQL,
CREATE TABLE book(
  nbc text,
  isbn text,
  tr text,
  pub text
);
SQL

insert:<<SQL,
  insert into book values(?, ?, ?, ?);
SQL

select:<<SQL,
  select * from book;
SQL

drop:<<SQL
  drop table book;
SQL
}

def record_store (nbc, isbn, tr, pub)
  @records.push({nbc: nbc, isbn: isbn, tr: tr, pub: pub})
end


open(file_path, "r") do |input|
  while line = input.gets
    if /^NBC:\s+/ =~ line
      nbc = line.chomp.gsub(/^NBC:\s+/, "")
    elsif /^ISBN:\s+/ =~ line
      isbn = line.chomp.gsub(/^ISBN:\s+/, "")
    elsif /^TR:\s+/ =~ line
      tr = line.chomp.gsub(/^TR:\s+/, "").sub(/\s+\/\s+/, "|")
    elsif /^PUB:\s+/ =~ line
      pub = line.chomp.gsub(/^PUB:\s+/, "")
    elsif /^\*/ =~ line
      record_store nbc, isbn, tr, pub
      nbc = isbn = tr = pub = ""
      printf("Load Records: #{@records.length}\r")
    end
  end
end

puts "[OK]\n"
#@records.each do |row|
#  puts [row[:nbc], row[:isbn], row[:tr], row[:pub]].join " | "
#end

SQLite3::Database.new "library.db" do |db|
  db.execute query[:drop]
  db.execute query[:create]
  @records.each_with_index do |row, index|
    db.execute query[:insert], row[:nbc], row[:isbn], row[:tr], row[:pub]
    printf("Insert Query: #{index}\r")
  end
  puts "[OK]\n"
  db.execute(query[:select]).length
end