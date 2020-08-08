abstract class Share::BasePage < SecretGuestLayout
  include Period
  needs domain : Domain
  needs period : String
end
