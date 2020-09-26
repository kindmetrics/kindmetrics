class DomainSerializer < BaseSerializer
  def initialize(@domain : Domain)
  end

  def render
    {id: @domain.id, address: @domain.address}
  end
end
