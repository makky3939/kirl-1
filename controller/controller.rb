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
    @limit = params["limit"]
    @offset = params["offset"]
    @nbc = params["nbc"]

    @input_1_text = params["input_1_text"]
    @input_1_field = params["input_1_field"]
    @input_1_operator_symbol = params["input_1_operator_symbol"]

    @input_2_text = params["input_2_text"]
    @input_2_field = params["input_2_field"]
    @input_2_operator_symbol = params["input_2_operator_symbol"]

    @input_3_text = params["input_3_text"]
    @input_3_field = params["input_3_field"]
    @input_3_operator_symbol = params["input_3_operator_symbol"]

    @input_1_field = "title" if @input_1_field == ""
    @input_2_field = "title" if @input_2_field == ""
    @input_3_field = "title" if @input_3_field == ""
    @input_1_operator_symbol = "and" if @input_1_operator_symbol == "" && @input_1_text != ""
    @input_2_operator_symbol = "and" if @input_2_operator_symbol == "" && @input_2_text != ""
    @input_3_operator_symbol = "and" if @input_3_operator_symbol == "" && @input_3_text != ""
  end

  def select
    where = ""
    where << "#{@input_1_field} LIKE '%#{@input_1_text}%'"
    where << "#{@input_2_operator_symbol} #{@input_2_field} LIKE '%#{@input_2_text}%'" if @input_2_text != ""
    where << "#{@input_3_operator_symbol} #{@input_3_field} LIKE '%#{@input_3_text}%'" if @input_3_text != ""

    <<-SQL
      SELECT nbc, title, author, pub, date
      FROM book
      WHERE #{where}
      LIMIT #{limit(@offset)}
    SQL
  end

  def count
    where = ""
    where << "#{@input_1_field} LIKE '%#{@input_1_text}%'"
    where << "#{@input_2_operator_symbol} #{@input_2_field} LIKE '%#{@input_2_text}%'" if @input_2_text != ""
    where << "#{@input_3_operator_symbol} #{@input_3_field} LIKE '%#{@input_3_text}%'" if @input_3_text != ""
    <<-SQL
      SELECT count(*)
      FROM book 
      WHERE #{where}
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