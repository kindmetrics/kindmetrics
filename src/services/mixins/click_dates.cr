module ClickDates
  private def slim_from_date
    @from_date.to_utc.to_s("%Y-%m-%d %H:%M:%S")
  end

  private def slim_to_date
    @to_date.to_utc.to_s("%Y-%m-%d %H:%M:%S")
  end
end
