abstract class Domains::Data::BasePage
  include Lucky::HTMLPage
  needs domain : Domain
  needs period : String
  needs current_user : User?
  needs goal : Goal?
  needs site_path : String = ""
  needs source_name : String = ""
  needs medium_name : String = ""
end
