class Events::Create < ApiAction
  include Api::Auth::SkipRequireAuthToken
  post "/api/track" do
    data = params.to_h
    Log.debug { {params: data} }
    address = data["domain"].to_s
    return error unless address.present?
    Log.debug { {headers: request.headers.to_h} }
    remote_ip = request.headers["X-Forwarded-For"]? || "localhost"

    user_agent = data["user_agent"].to_s

    browser_name, browser_version = UserHash.get_browser(user_agent) if user_agent.present?
    Log.debug { {browser: browser_name, version: browser_version} }

    user_id = UserHash.create(address, remote_ip, browser_name || "", browser_version || "").to_s

    domain = DomainQuery.new.address(address).first

    return error unless domain.present?

    SaveEvent.create(name: data["name"].to_s, user_agent: user_agent, referrer: data["referrer"].to_s, url: data["url"].to_s, source: data["source"].to_s, screen_width: data["screen_width"].to_s, domain_id: domain.id, user_id: user_id) do |operation, event|
      if event
        Log.debug { "Yay, saved!" }
      else
        Log.debug { "Not saved, error" }
      end
    end
    plain_text "tracked!"
  end

  def error
    plain_text "Error on getting domain name, sorry.", status: 404
  end

  def render(error : Avram::RecordNotFoundError)
    plain_text "domain not found", status: 404
  end
end
