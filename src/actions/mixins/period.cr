module Period
  def period_string
    case period
    when "14d"
      "14 days"
    when "30d"
      "30 days"
    when "60d"
      "60 days"
    when "90d"
      "90 days"
    else
      "7 days"
    end
  end
end
