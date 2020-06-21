class User < BaseModel
  include Carbon::Emailable
  include Authentic::PasswordAuthenticatable

  table do
    column name : String?
    column email : String
    column encrypted_password : String
    column confirmed_at : Time?
    column confirmed_token : String
    column admin : Bool
    belongs_to current_domain : Domain?
    has_many domains : Domain
  end

  def confirmed?
    !confirmed_at.nil?
  end

  def emailable : Carbon::Address
    Carbon::Address.new(email)
  end
end
