def join_if_array(a, sep)
  if a.instance_of?(Array)
    return a.join(sep)
  else
    return a
  end
end

def split_tr(record)
  if record.key?("TR")
  record["tr-title"] = Array.new
  record["tr-author"] = Array.new
  record["TR"].each{ | s |
    v = s.split(/\s+\/\s+/, 2)
    record["tr-title"].push(v[0])
    record["tr-author"].push(v[1])
  }
  end
end

def split_pub(record)
  if record.key?("PUB")
  record["pub-publ"] = Array.new
  record["pub-date"] = Array.new
  record["PUB"].each{ | s |
    v = s.split(/\s*,\s+/, 2)
    record["pub-publ"].push(v[0])
    record["pub-date"].push(v[1])
  }
  end
end

# open('jbisc.txt', 'r'){ | io |
#   db = SQLite3::Database.new(データベースファイル名)
#   begin
#   db.transaction{
#     while rec = read1record(io)
#       split_tr(rec)
#       split_pub(rec)
#       output(rec, db)
#     end
#   }
#   ensure
#     db.close
#   end
# }