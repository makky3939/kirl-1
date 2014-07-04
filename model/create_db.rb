# -*- coding: utf-8 -*-

require 'rubygems'
require 'sqlite3'
require 'natto'

JBISC_FILE_PATH = 'jbisc.txt'
# JBISC_FILE_PATH = 'jbisc.min.txt'
DB_FILE_PATH = 'library.db'

query = {
create: {
  book:<<-SQL,
    CREATE TABLE book(
      nbc text,
      title text,
      author text,
      pub text,
      date text,
      phys text
    );
  SQL

  isbn:<<-SQL,
    CREATE TABLE isbn(
      nbc text,
      isbn text
    );
  SQL

  note:<<-SQL,
    CREATE TABLE note(
      nbc text,
      note text
    );
  SQL

  ed:<<-SQL,
    CREATE TABLE ed(
      nbc text,
      ed text
    );
  SQL

  series:<<-SQL,
    CREATE TABLE series(
      nbc text,
      series text
    );
  SQL

  titleheading:<<-SQL,
    CREATE TABLE titleheading(
      nbc text,
      titleheading text
    );
  SQL

  authorheading:<<-SQL,
    CREATE TABLE authorheading(
      nbc text,
      authorheading text
    );
  SQL

  holdingsrecord:<<-SQL,
    CREATE TABLE holdingsrecord(
      nbc text,
      holdingsrecord text
    );
  SQL

  holdingloc:<<-SQL,
    CREATE TABLE holdingloc(
      nbc text,
      holdingloc text
    );
  SQL

  holdingphys:<<-SQL,
    CREATE TABLE holdingphys(
      nbc text,
      holdingphys text
    );
  SQL

  analysis:<<-SQL,
    CREATE TABLE analysis(
      word text,
      count integer
    );
  SQL
  },

insert: {
book:<<-SQL,
    insert into book values(?, ?, ?, ?, ?, ?);
  SQL

isbn:<<-SQL,
    insert into isbn values(?, ?);
  SQL

note:<<-SQL,
    insert into note values(?, ?);
  SQL

ed:<<-SQL,
    insert into ed values(?, ?);
  SQL

series:<<-SQL,
    insert into series values(?, ?);
  SQL

titleheading:<<-SQL,
    insert into titleheading values(?, ?);
  SQL

authorheading:<<-SQL,
    insert into authorheading values(?, ?);
  SQL

holdingsrecord:<<-SQL,
    insert into holdingsrecord values(?, ?);
  SQL

holdingloc:<<-SQL,
    insert into holdingloc values(?, ?);
  SQL

holdingphys:<<-SQL,
    insert into holdingphys values(?, ?);
  SQL

analysis:<<-SQL,
    insert into analysis values(?, ?);
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
    'AUTHOR' => [], #
    'PUB' => [], #
    'DATE' => [], #
    'PHYS' => [], #
    'NOTE' => [], #
    'ED' => [], #
    'SERIES' => [], #
    'TITLEHEADING' => [],
    'AUTHORHEADING' => [],
    'HOLDINGSRECORD' => [],
    'HOLDINGLOC' => [],
    'HOLDINGPHYS' => [] 
  }
end

def integer_str?(str)
  begin
    int = Integer(str)
  rescue ArgumentError
    int = nil
  end
  return int
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


records = []
parsed_key = {}
natto = Natto::MeCab.new

File.unlink DB_FILE_PATH if File.exist? DB_FILE_PATH

SQLite3::Database.new DB_FILE_PATH do |db|
  query[:create].each do |key, val|
    puts "Create table: #{key}"
    db.execute val
  end

  open(JBISC_FILE_PATH, 'r') do |input|
    puts "Start getRecord"
    while record = getRecord(input)
      records.push record
      db.execute query[:insert][:book], record["NBC"], record["TITLE"], record["AUTHOR"], record["PUB"], record["DATE"], record["PHYS"]

      record["ISBN"].each do |isbn|
        db.execute query[:insert][:isbn], record["NBC"], isbn
      end

      record["NOTE"].each do |note|
        db.execute query[:insert][:note], record["NBC"], note
      end

      record["ED"].each do |ed|
        db.execute query[:insert][:ed], record["NBC"], ed
      end

      record["SERIES"].each do |series|
        db.execute query[:insert][:series], record["NBC"], series
      end

      record["TITLEHEADING"].each do |titleheading|
        db.execute query[:insert][:titleheading], record["NBC"], titleheading
      end

      record["AUTHORHEADING"].each do |authorheading|
        db.execute query[:insert][:authorheading], record["NBC"], authorheading
      end

      record["HOLDINGSRECORD"].each do |holdingsrecord|
        db.execute query[:insert][:holdingsrecord], record["NBC"], holdingsrecord
      end

      record["HOLDINGLOC"].each do |holdingloc|
        db.execute query[:insert][:holdingloc], record["NBC"], holdingloc
      end

      record["HOLDINGPHYS"].each do |holdingphys|
        db.execute query[:insert][:holdingphys], record["NBC"], holdingphys
      end

      natto.parse(record['TITLE'][0]) do |item|
         if item.feature.include?("名詞") && item.surface.size > 1 && !integer_str?(item.surface)
          parsed_key[item.surface] = parsed_key[item.surface] ? parsed_key[item.surface] + 1 : 1
        end
      end
      print("Records: #{records.size}\r")
    end
    puts "\nEnd getRecord"

    parsed_key = parsed_key.sort_by{|k, v| v}
    parsed_key.reverse.each do |key, val|
      db.execute(query[:insert][:analysis], key, val) if val > 1
    end

    query[:create].each do |key, val|
      puts "#{key} size: #{db.execute("select count(*) from #{key}")[0][0]}"
    end
  end
end