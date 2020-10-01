abstract class Share::BasePage < SecretGuestLayout
  include Timeparser
  include PeriodPage
  needs domain : Domain
  needs from : Time
  needs to : Time
  needs period : String
end
