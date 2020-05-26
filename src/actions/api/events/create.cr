class Events::Create < ApiAction
  include Api::Auth::SkipRequireAuthToken
  post "/api/track" do
    address = params.get?(:domain).to_s
    return error unless address.present?

    domain = DomainQuery.new.address(address).first
    return error if domain.nil?

    remote_ip = request.headers["X-Forwarded-For"]? || "92.35.68.246"
    user_agent = params.get?(:user_agent).to_s
    referrer = URI.parse params.get?(:referrer).try { |r| r.to_s } || ""
    url = URI.parse params.get?(:url).try { |r| r.to_s } || ""

    EventHandler.handle_event(address, remote_ip, user_agent, referrer, url, params, domain)

    head status: 200
  end

  def error
    head status: 404
  end

  def render(error : Avram::RecordNotFoundError)
    head status: 404
  end
end
