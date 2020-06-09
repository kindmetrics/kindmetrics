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
    Carbon::Address.new("Håkan Nylén", "hakan@kindmetrics.io")
  end
end
