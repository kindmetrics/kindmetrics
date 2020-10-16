class Share::Show < DomainShareBaseAction
  include Auth::AllowGuests
  include Hashid
  include Period
  include PreviousDomainMetrics
  include Timeparser
  extend Timeparser

  get "/share/:share_id" do
    html Domains::ShowPage, domain: domain, goal: goal, real_count: metrics.real_count, source: source, medium: medium, site_path: site_path, share_page: true, total_unique: metrics.unique_query, total_unique_previous: previous_metric.unique_query, total_bounce: metrics.bounce_query, total_bounce_previous: previous_metric.bounce_query, total_sum: metrics.total_query, total_previous: previous_metric.total_query, length: metrics.avg_length, length_previous: previous_metric.avg_length, from: real_from, to: real_to, period: period, period_string: period_string
  end
end
