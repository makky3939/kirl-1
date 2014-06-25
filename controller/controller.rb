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

class Query
  def initialize(params)
    @keyword = params["keyword"]
    @limit = params["limit"]
    @offset = params["offset"]
    @nbc = params["nbc"]
  end

  def select
    @keyword =
    <<-SQL
      SELECT nbc, title, author, pub, date
      FROM book 
      WHERE title 
      LIKE '%#{@keyword}%'
      LIMIT #{limit(@offset)}
    SQL
  end

  def count
    <<-SQL
      SELECT count(*)
      FROM book 
      WHERE title 
      LIKE '%#{@keyword}%'
    SQL
  end

  def select_detail
    <<-SQL
      SELECT *
      FROM book
      LEFT OUTER JOIN isbn on book.nbc = isbn.nbc
      LEFT OUTER JOIN note on book.nbc = note.nbc
      LEFT OUTER JOIN ed on book.nbc = ed.nbc
      LEFT OUTER JOIN series on book.nbc = series.nbc
      LEFT OUTER JOIN titleheading on book.nbc = titleheading.nbc
      LEFT OUTER JOIN authorheading on book.nbc = authorheading.nbc
      LEFT OUTER JOIN holdingsrecord on book.nbc = holdingsrecord.nbc
      LEFT OUTER JOIN holdingloc on book.nbc = holdingloc.nbc
      LEFT OUTER JOIN holdingphys on book.nbc = holdingphys.nbc

      WHERE book.nbc = '#{@nbc}'
    SQL
  end
end