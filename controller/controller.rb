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
  end

  def select
    <<-SQL
      SELECT * 
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
end