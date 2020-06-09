class WWWHandler
  include HTTP::Handler

  def call(context)
    if !context.request.host.not_nil!.ends_with?("kindmetrics.io") && Lucky::Env.production?
      context.response.status_code = 301
      context.response.headers["Location"] = "https://kindmetrics.io"
    elsif context.request.host.not_nil!.starts_with?("www.")
      context.response.status_code = 301
      context.response.headers["Location"] = "https://kindmetrics.io#{context.request.path}"
    else
      call_next(context)
    end
  end
end
