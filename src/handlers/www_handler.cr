class WWWHandler
  include HTTP::Handler

  def call(context)
    return call_next(context) if ENV["APP_HOST"]?.nil?

    if !context.request.host.not_nil!.ends_with?(KindEnv.env("APP_HOST")) && Lucky::Env.production?
      context.response.status_code = 301
      context.response.headers["Location"] = "https://#{KindEnv.env("APP_HOST")}"
    elsif context.request.host.not_nil!.starts_with?("www.")
      context.response.status_code = 301
      context.response.headers["Location"] = "https://#{KindEnv.env("APP_HOST")}#{context.request.path}"
    else
      call_next(context)
    end
  end
end
