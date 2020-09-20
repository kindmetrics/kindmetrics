module ClickDates
  private def slim_from_date
    @from_date.at_beginning_of_day.to_s("%Y-%m-%d %H:%M:%S")
  end

  private def slim_to_date
    @to_date.at_end_of_day.to_s("%Y-%m-%d %H:%M:%S")
  end
end
