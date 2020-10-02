class Share::Countries::Index < DomainShareBaseAction
  include Auth::AllowGuests
  include Hashid
  include Timeparser
  extend Timeparser

  get "/share/:share_id/countries" do
    countries = metrics.get_countries
    html Domains::Countries::IndexPage, domain: domain, from: real_from, to: real_to, period: period, share_page: true, countries: countries
  end
end
