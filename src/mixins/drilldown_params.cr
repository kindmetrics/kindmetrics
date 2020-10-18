module DrilldownParams
  macro included
    needs goal : Goal? = nil
    needs source : String?
    needs medium : String?
    needs country : String?
    needs browser : String?
    needs site_path : String?
  end

  def set_params(prefix : String)
    params = Hash(String, String).new

    params["#{prefix}site_path"] = site_path.not_nil! if !site_path.nil?
    params["#{prefix}source"] = source.not_nil! if !source.nil?
    params["#{prefix}medium"] = medium.not_nil! if !medium.nil?
    params["#{prefix}country"] = country.not_nil! if !country.nil?
    params["#{prefix}browser"] = browser.not_nil! if !browser.nil?
    params["#{prefix}goal"] = goal.not_nil!.id.to_s if !goal.nil?

    return nil if params.empty?
    params
  end
end
