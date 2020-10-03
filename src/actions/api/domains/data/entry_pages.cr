class Api::Domains::Data::EntryPages < ApiDomainBaseAction
  get "/api/domains/:domain_id/entry_pages" do
    json Domain::EntryPageSerializer.new(metrics)
  end
end
