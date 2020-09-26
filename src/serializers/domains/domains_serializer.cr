class DomainsSerializer < BaseSerializer
  def initialize(@domains : DomainQuery)
  end

  def render
    @domains.map do |d|
      {id: d.id, address: d.address}
    end
  end
end
