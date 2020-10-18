abstract class DomainPublicBaseAction < BrowserAction
  include Timeparser
  extend Timeparser
  param from : String?
  param to : String?
  param period : String = "7d"
  param goal_id : Int64?
  param site_path : String?
  param source : String?
  param medium : String?
  param country : String?
  param browser : String?

  before require_domain

  @domain : Domain?

  private def require_domain
    @domain = DomainQuery.find(domain_id)
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
    return nil if goal_id.nil?
    GoalQuery.new.domain_id(domain.id).find(goal_id.not_nil!)
  end

  private def metrics : Metrics
    Metrics.new(domain, real_from, real_to, goal, site_path, source, medium, country, browser)
  end

  private def real_from : Time
    if !from.nil?
      string_to_date(from.not_nil!)
    elsif !period.empty?
      period_time(period)
    else
      period_time("7d")
    end
  end

  private def real_to : Time
    if !to.nil?
      string_to_date(to.not_nil!)
    else
      Time.utc.at_end_of_day
    end
  end
end
