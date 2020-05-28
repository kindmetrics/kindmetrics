class Domains::Referrer::Show < DomainBaseAction
  get "/domains/:domain_id/referrers/:source" do
    puts URI.decode(source)
    html ShowPage, domain: domain, events: get_referrals, source: parse_source
  end

  def get_referrals
    metrics = Metrics.new(domain, "7d")
    metrics.get_source_referrers(parse_source)
  end

  def parse_source
    URI.decode(source).sub("+", " ")
  end
end
