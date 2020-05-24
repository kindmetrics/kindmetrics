require "../spec_helper"

describe Metrics do
  it "unique calculation" do
    domain = DomainBox.create
    events = EventBox.create_pair &.domain_id(domain.id)

    metrics = Metrics.new(domain, "7d")
    unique = metrics.unique_query
    unique.should eq(2.to_s)
  end

  it "total calculation" do
    domain = DomainBox.create
    events = EventBox.create_pair &.domain_id(domain.id)

    metrics = Metrics.new(domain, "7d")
    total_views = metrics.total_query
    total_views.should eq(2.to_s)
  end

  it "7 days calculation" do
    domain = DomainBox.create
    events = EventBox.create_pair &.domain_id(domain.id)

    metrics = Metrics.new(domain, "7d")
    days, today, data = metrics.get_days
    days.size.should eq(8)
    data.size.should eq(7)
    today.size.should eq(8)

    days.last.day.should eq(Time.utc.day)
    days.last.month.should eq(Time.utc.month)

    days.first.day.should eq((Time.utc - 7.days).day)
    days.first.month.should eq((Time.utc - 7.days).month)
  end

  it "fill empty days" do
    domain = DomainBox.create
    events = EventBox.create_pair &.domain_id(domain.id)

    metrics = Metrics.new(domain, "7d")
    days, today, data = metrics.get_days
    days.size.should eq(8)
    data.size.should eq(7)
    today.size.should eq(8)

    empty_days = data[0..data.size-1]
    empty_days.size.should eq(7)

    empty_days.each { |ed| ed.should eq(0)}

    empty_today = today[0..today.size-3]
    empty_today.size.should eq(6)

    empty_today.each { |ed| ed.should eq(nil)}
  end

  it "14 days calculation" do
    domain = DomainBox.create
    events = EventBox.create_pair &.domain_id(domain.id)

    metrics = Metrics.new(domain, "14d")
    days, today, data = metrics.get_days
    days.size.should eq(15)
    data.size.should eq(14)
    today.size.should eq(15)

    days.last.day.should eq(Time.utc.day)
    days.last.month.should eq(Time.utc.month)

    days.first.day.should eq((Time.utc - 14.days).day)
    days.first.month.should eq((Time.utc - 14.days).month)
  end
end
