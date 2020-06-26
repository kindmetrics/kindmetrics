# Learn about sending emails
# https://luckyframework.org/guides/emails/sending-emails-with-carbon
abstract class BaseEmail < Carbon::Email
  # You can add defaults using the 'inherited' hook
  #
  # Example:
  #
  macro inherited
    from default_from
  end

  #
  def default_from
    if KindEnv.env("EMAIL_FROM_NAME").nil? || KindEnv.env("EMAIL_FROM").nil?
      raise "EMAIL_FROM_NAME and EMAIL_FROM need to be set"
    end
    Carbon::Address.new(KindEnv.env("EMAIL_FROM_NAME").not_nil!, KindEnv.env("EMAIL_FROM").not_nil!)
  end
end
