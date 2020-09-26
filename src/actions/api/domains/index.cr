class Api::Domains::Index < ApiAction
  get "/api/domains" do
    json DomainsSerializer.new(DomainQuery.new.user_id(current_user.id))
  end
end
