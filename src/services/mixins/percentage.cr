module Percentage
  private def count_percentage(array)
    total = array.sum { |p| p.count }
    array.map do |p|
      p.percentage = p.count / total.to_f32
      p
    end
  end

  private def count_bounce_rate(array)
    array.map do |p|
      next p if p.referrer_source.nil?
      p.bounce_rate = bounce_query_referrer(p.referrer_source.not_nil!)
      p
    end
  end

  private def count_path_bounce_rate(array, path)
    array.map do |p|
      next p if p.referrer_source.nil?
      p.bounce_rate = bounce_query_path_referrer(p.referrer_source.not_nil!, path)
      p
    end
  end

  private def count_medium_bounce_rate(array)
    array.map do |p|
      next p if p.referrer_medium.nil?
      p.bounce_rate = bounce_query_medium(p.referrer_medium.not_nil!)
      p
    end
  end

  private def count_bounce_rate_goal(array)
    array.map do |p|
      p.bounce_rate = bounce_query_goal(p.goal_name)
      p
    end
  end
end
