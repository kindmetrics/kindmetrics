abstract class DomainBaseAction < BrowserAction
  param period : String = "7d"

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
end
