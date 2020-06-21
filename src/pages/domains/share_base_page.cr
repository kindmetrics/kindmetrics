abstract class Share::BasePage < SecretGuestLayout
  needs domain : Domain
  needs period : String

  def period_string
    case period
    when "14d"
      return "14 days"
    when "30d"
      return "30 days"
    when "60d"
      return "60 days"
    when "90d"
      return "90 days"
    else
      return "7 days"
    end
  end
end
