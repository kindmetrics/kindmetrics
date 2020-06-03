class StatsDays
  def initialize(@date : Time, @count : Int64)
  end

  DB.mapping({
    date:  Time,
    count: Int64?,
  })
end
