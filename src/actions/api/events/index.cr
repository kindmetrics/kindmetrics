class Events::Create < ApiAction
  include Api::Auth::SkipRequireAuthToken
  post "/api/track" do
    data = params.to_h
    Log.debug { {params: data} }
    address = data["domain"]
    return error unless address.present?
    ip_address = request.remote_address
    user_agent = data["user_agent"].to_s

    browser_name, browser_version = UserHash.get_browser(user_agent) if user_agent.present?
    Log.debug { {browser: browser_name, version: browser_version} }

    user_id = UserHash.create(address, ip_address, browser_name || "", browser_version || "")

    domain = DomainQuery.new.address(address.to_s).first

    return error unless domain.present?

    SaveEvent.create(domain_id: domain.id, user_id: user_id) do |operation, event|
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
