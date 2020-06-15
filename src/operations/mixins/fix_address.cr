module FixAddress
  macro included
    before_save fix_address
    before_save validate_address
  end

  private def fix_address
    validate_required address

    url = URI.parse(address.value.not_nil!)
    return if !url.absolute? && !address.value.not_nil!.starts_with?("www.")

    new_address = if url.host.nil?
                    address.value.not_nil!.sub(/^www./i, "")
                  else
                    url.host.not_nil!.sub(/^www./i, "")
                  end
    address.value = new_address
  end

  private def validate_address
    unless address.value =~ /^[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,63}$/
      address.add_error "is not a valid hostname - should be like 'test.com'"
    end
  end
end
