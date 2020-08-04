abstract class Domains::BasePage < MainLayout
  include Period
  needs domain : Domain
  needs period : String
end
