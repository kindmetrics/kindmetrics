abstract class Domains::Data::BasePage
  include Lucky::HTMLPage
  include Timeparser
  needs domain : Domain
  needs from : Time
  needs to : Time
  needs current_user : User?
  needs goal : Goal?
  needs site_path : String?
  needs source : String?
  needs medium : String?
  needs browser : String?
  needs country : String?
end
