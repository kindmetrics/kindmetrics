class Share::Countries::Index < DomainShareBaseAction
  include Auth::AllowGuests
  include Hashid
  include Timeparser
  extend Timeparser

  get "/share/:share_id/countries" do
    countries = metrics.get_countries(0)
    languages = metrics.get_languages(0)
    html Domains::Countries::IndexPage, domain: domain, from: real_from, to: real_to, period: period, share_page: true, countries: countries, languages: languages
  end
end
