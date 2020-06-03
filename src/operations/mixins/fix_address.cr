module FixAddress
  macro included
    before_save fix_address
  end

  private def fix_address
    validate_required address

    url = URI.parse(address.value.not_nil!)
    return if !url.absolute? && !address.value.not_nil!.starts_with?("www.")

    new_address = if url.host.nil?
                    address.value.not_nil!.lstrip("www.")
                  else
                    url.host.not_nil!.lstrip("www.")
                  end
    address.value = new_address
  end
end
