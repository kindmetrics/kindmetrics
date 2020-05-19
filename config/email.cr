require "carbon_smtp_adapter"
if Lucky::Env.production?
  Carbon::SmtpAdapter.configure do |settings|
    settings.host = ENV["SMTP_HOST"]
    settings.port = 25
    settings.helo_domain = nil
    settings.use_tls = true
    settings.username = ENV["SMTP_USERNAME"]
    settings.password = ENV["SMTP_PASSWORD"]
  end
end
BaseEmail.configure do |settings|
  if Lucky::Env.production?
    settings.adapter = Carbon::SmtpAdapter.new
  else
    settings.adapter = Carbon::DevAdapter.new
  end
end

private def send_grid_key_from_env
  ENV["SEND_GRID_KEY"]? || raise_missing_key_message
end

private def raise_missing_key_message
  puts "Missing SEND_GRID_KEY. Set the SEND_GRID_KEY env variable to 'unused' if not sending emails, or set the SEND_GRID_KEY ENV var.".colorize.red
  exit(1)
end
