module DrilldownParams

  macro included
    needs goal : Goal? = nil
    needs source : String = ""
    needs medium : String = ""
    needs site_path : String = ""
  end

  def set_params(prefix : String)
    params = Hash(String, String).new

    params["#{prefix}site_path"] = site_path if !site_path.empty?
    params["#{prefix}source"] = source if !source.empty?
    params["#{prefix}medium"] = medium if !medium.empty?
    params["#{prefix}goal"] = goal.not_nil!.id.to_s if !goal.nil?

    return nil if params.empty?
    params
  end
end
