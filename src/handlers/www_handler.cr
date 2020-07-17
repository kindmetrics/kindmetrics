class WWWHandler
  include HTTP::Handler

  def call(context)
    return call_next(context) if KindEnv.env("APP_HOST").nil?

    if !context.request.host.not_nil!.ends_with?(KindEnv.env("APP_HOST") || "app.kindmetrics.io") && Lucky::Env.production?
      context.response.status_code = 301
      context.response.headers["Location"] = "https://#{KindEnv.env("APP_HOST") || "app.kindmetrics.io"}"
    elsif context.request.host.not_nil!.starts_with?("www.")
      context.response.status_code = 301
      context.response.headers["Location"] = "https://#{KindEnv.env("APP_HOST") || "app.kindmetrics.io"}#{context.request.path}"
    else
      call_next(context)
    end
  end
end
