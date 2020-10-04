class Api::Events::Create < ApiAction
  include Api::Auth::SkipRequireAuthToken
  post "/api/track" do
    address = params.get?(:domain).to_s
    return error unless address.present?

    hostname = remove_www(address.not_nil!)

    domain = DomainQuery.new.address(hostname).first
    return error if domain.nil?

    remote_ip = request.headers["X-Forwarded-For"]? || "92.35.68.246"
    user_agent = params.get?(:user_agent).to_s
    referrer = hide_local(URI.parse(params.get?(:referrer).try { |r| r.to_s } || ""))

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

  private def remove_www(uri : String)
    uri.sub(/^www./i, "")
  end

  private def hide_local(referrer)
    return URI.parse("") if ["localhost", "127.0.0.1"].includes?(referrer.host)
    referrer
  end
end
