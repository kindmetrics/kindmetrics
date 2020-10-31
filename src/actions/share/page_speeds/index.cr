class Share::PageSpeeds::Index < DomainShareBaseAction
  include Auth::AllowGuests
  include Hashid
  include Timeparser
  extend Timeparser

  get "/share/:share_id/page_speeds" do
    html Domains::PageSpeeds::IndexPage, domain: domain, from: real_from, to: real_to, share_page: true, period: period
  end
end
