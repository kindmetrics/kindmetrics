abstract class DomainBaseAction < BrowserAction
  param period : String = "7d"
  param goal_id : Int64 = 0_i64
  param site_path : String = ""

  before require_domain

  @domain : Domain?

  private def require_domain
    @domain = DomainQuery.find(domain_id)
    raise Lucky::RouteNotFoundError.new(context) if @domain.nil?
    if DomainPolicy.show?(domain, current_user)
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
end
