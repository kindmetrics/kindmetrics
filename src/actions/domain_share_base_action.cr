abstract class DomainShareBaseAction < BrowserAction
  include Timeparser
  extend Timeparser
  param from : String = ""
  param to : String = ""
  param period : String = "7d"
  param goal_id : Int64 = 0_i64
  param site_path : String = ""
  param source_name : String = ""
  param medium_name : String = ""

  before require_domain

  @domain : Domain?

  private def require_domain
    ids = hashids.decode(share_id)
    raise Lucky::RouteNotFoundError.new(context) if ids.empty?

    @domain = DomainQuery.find(ids.first)
    raise Lucky::RouteNotFoundError.new(context) if @domain.nil?

    if DomainPolicy.show_share?(domain, current_user)
      continue
    else
      raise Lucky::RouteNotFoundError.new(context)
    end
  end

  private def domain : Domain
    @domain.not_nil!
  end

  private def goal : Goal?
    return nil if goal_id == 0
    GoalQuery.find(goal_id)
  end

  private def metrics : Metrics
    Metrics.new(domain, real_from, real_to, goal, site_path, source_name, medium_name)
  end

  private def real_from : Time
    if !from.empty?
      string_to_date(from)
    elsif !period.empty?
      period_time(period)
    else
      period_time("7d")
    end
  end

  private def real_to : Time
    if !to.empty?
      string_to_date(to)
    else
      Time.utc.at_end_of_day
    end
  end
end
