abstract class DomainPublicBaseAction < BrowserAction
  include Timeparser
  extend Timeparser
  param from : String = time_to_string(Time.utc - 7.days)
  param to : String = time_to_string(Time.utc)
  param goal_id : Int64 = 0_i64
  param site_path : String = ""
  param source_name : String = ""
  param medium_name : String = ""

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
    return nil if goal_id == 0
    GoalQuery.find(goal_id)
  end

  private def metrics : Metrics
    Metrics.new(domain, string_to_date(from), string_to_date(to), goal, site_path, source_name, medium_name)
  end
end
