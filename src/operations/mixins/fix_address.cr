module FixAddress
  macro included
    before_save fix_address
  end

  private def fix_address
    validate_required address

    new_address = address.value.not_nil!
    new_address = new_address.lstrip("https://")
    new_address = new_address.lstrip("http://")
    new_address = new_address.lstrip("www.")
    address.value = new_address
  end
end
