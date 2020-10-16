# Include modules and add methods that are for all API requests
abstract class ApiDomainBaseAction < ApiAction
  include Timeparser
  extend Timeparser
  include ApiTrialCheck
  param from : String?
  param to : String?
  param period : String = "7d"
  param goal_id : Int64?
  param site_path : String?
  param source_name : String?
  param medium_name : String?

  before require_domain

  @domain : Domain?

  private def require_domain
    @domain = DomainQuery.new.user_id(current_user.id).id(domain_id).first?
    raise Lucky::RouteNotFoundError.new(context) if @domain.nil?

    if DomainPolicy.show?(domain, current_user)
      continue
    else
      raise LuckyCan::ForbiddenError.new(context)
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
    Metrics.new(domain, real_from, real_to, goal, site_path, source_name, medium_name)
  end

  def render(error : LuckyCan::ForbiddenError)
    error = ErrorSerializer.new(message: "Forbidden", details: "Probably no working subscription")
    json error, HTTP::Status::FORBIDDEN
  end

  def render(error : Lucky::RouteNotFoundError)
    error = ErrorSerializer.new(message: "Not Found")
    json error, HTTP::Status::NOT_FOUND
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
