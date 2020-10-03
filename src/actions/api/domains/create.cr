class Api::Domains::Create < ApiAction
  post "/api/domains" do
    domain = SaveDomain.create!(params, user_id: current_user.id, current_user: current_user)
    json DomainSerializer.new(domain), HTTP::Status::CREATED
  end
end
