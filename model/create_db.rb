#!/usr/bin/ruby
# -*- coding: utf-8 -*-

require 'rubygems'
require 'sqlite3'

JBISC_FILE_PATH = 'jbisc.txt'
# JBISC_FILE_PATH = 'jbisc.min.txt'
DB_FILE_PATH = 'library.db'

records = []

query = {
create: {
book:<<SQL,
CREATE TABLE book(
  nbc text,
  title text,
  date text,
  phys text,
  ed text
);
SQL

isbn:<<SQL,
CREATE TABLE isbn(
  nbc text,
  isbn text
);
SQL
},

insert: {
book:<<SQL,
  insert into book values(?, ?, ?, ?, ?);
SQL

isbn:<<SQL,
  insert into isbn values(?, ?);
SQL
},

select: {
book:<<SQL,
  select * from book;
SQL

isbn:<<SQL,
  select * from isbn;
SQL
}


}

def defaultRecord
  {
    'NBC' => [], #
    'ISBN' => [], #
    'TITLE' => [], #
    'AUTHOR' => [],
    'PUB' => [], 
    'DATE' => [], #
    'PHYS' => [], #
    'NOTE' => [],
    'ED' => [], # 版表示
    'SERIES' => [],
    'TITLEHEADING' => [],
    'AUTHORHEADING' => [],
    'HOLDINGSRECORD' => [],
    'HOLDINGLOC' => [],
    'HOLDINGPHYS' => [] # ???
  }
end

def sliceAttribute input
  line = input.gets
  return nil if !line

  row = line.chomp.split(/:\s*/, 2)

  if row[0] == '*'
    return nil
  end

  if row[0] == 'TR'
    value = row[1].split(/\s+\/\s+/, 2)
    row = []
    row.push ['TITLE', value[0]]
    row.push ['AUTHOR', value[1]]
    return row
  end

  if row[0] == 'PUB'
    value = row[1].split(/\s*,\s+/, 2)
    row = []
    row.push ['PUB', value[0]]
    row.push ['DATE', value[1]]
    return row
  end

  return [row]
end

def getRecord input
  record = defaultRecord

  while attributes = sliceAttribute(input)
    attributes.each do |attribute|
      record[attribute[0]].push(attribute[1])
    end
  end

  if record.values.flatten.empty?
    return nil
  else
    return record
  end
end



table = {
  "book" => [],
  "isbn" => []
}

open(JBISC_FILE_PATH, 'r') do |input|
  puts "Start getRecord"
  while record = getRecord(input)
    records.push(record)

    table["book"].push [record["NBC"], record["TITLE"], record["DATE"], record["PHYS"], record["ED"]]

    record["ISBN"].each do |isbn|
      table["isbn"].push [record["NBC"], isbn]
    end

    print("Records: #{records.size}\r")
  end
  puts "\nEnd getRecord"
end



File.unlink DB_FILE_PATH if File.exist? DB_FILE_PATH
SQLite3::Database.new DB_FILE_PATH do |db|
  query[:create].each do |key, val|
    puts "Create table: #{key}"
    db.execute val
  end

  table["book"].each do |val|
    db.execute query[:insert][:book], val[0], val[1], val[2], val[3], val[4]
  end

  table["isbn"].each do |val|
    db.execute query[:insert][:isbn], val[0], val[1]
  end

  p db.execute(query[:select][:book])
  p db.execute(query[:select][:isbn])
end