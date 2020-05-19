class SessionHandler
  include HTTP::Handler

  def call(context : HTTP::Server::Context)
    call_next(context)

    unless starts_with?(context.request.path)
      write_session(context)
      write_cookies(context)
    end
  end

  private def write_session(context : HTTP::Server::Context) : Void
    context.cookies.set(
      Lucky::Session.settings.key,
      context.session.to_json
    )
  end

  private def write_cookies(context : HTTP::Server::Context) : Void
    response = context.response

    context.cookies.updated.each do |cookie|
      response.cookies[cookie.name] = cookie
    end

    response.cookies.add_response_headers(response.headers)
  end

  private def starts_with?(path)
    path.starts_with?("/js") || path.starts_with?("/api")
  end
end
