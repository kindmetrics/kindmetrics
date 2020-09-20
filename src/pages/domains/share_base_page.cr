abstract class Share::BasePage < SecretGuestLayout
  include Period
  needs domain : Domain
  needs from : Time
  needs to : Time
end
