abstract class Domains::Data::BasePage
  include Lucky::HTMLPage
  include Timeparser
  needs domain : Domain
  needs from : Time
  needs to : Time
  needs current_user : User?
  needs goal : Goal?
  needs site_path : String = ""
  needs source_name : String = ""
  needs medium_name : String = ""
end
