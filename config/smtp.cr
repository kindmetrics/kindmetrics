require "email"

class Carbon::SmtpAdapter < Carbon::Adapter
  Habitat.create do
    setting host : String = "localhost"
    setting port : Int32 = 587
    setting helo_domain : String? = nil
    setting use_tls : Bool = true
    setting username : String? = nil
    setting password : String? = nil
  end

  def deliver_now(email : Carbon::Email)
    config = ::EMail::Client::Config.new(settings.host, settings.port, helo_domain: settings.helo_domain)
    config.use_auth(settings.username.not_nil!, settings.password.not_nil!) unless settings.username.nil? || settings.password.nil?
    config.use_tls(EMail::Client::TLSMode::STARTTLS) if settings.use_tls

    client = ::EMail::Client.new(config)
    # ::EMail::Client.log_level = Log::Severity::Debug

    new_email = ::EMail::Message.new
    new_email.from email.from.address, email.from.name

    email.to.each do |to_address|
      new_email.to(to_address.address, to_address.name)
    end
    email.cc.each do |cc_address|
      new_email.cc(cc_address.address, cc_address.name)
    end
    email.bcc.each do |bcc_address|
      new_email.bcc(bcc_address.address, bcc_address.name)
    end

    email.headers.each do |key, value|
      new_email.custom_header(key, value)
    end

    new_email.subject email.subject
    new_email.message email.text_body
    new_email.message_html email.html_body

    client.start do
      send(new_email)
    end
  end
end
