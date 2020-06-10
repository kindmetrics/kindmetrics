class ReportUser < BaseModel
  table do
    belongs_to domain : Domain
    column email : String
    column weekly : Bool
    column monthly : Bool
  end
end
