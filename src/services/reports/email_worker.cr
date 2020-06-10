class EmailWorker

  def self.send_report(kind : String = "weekly")
    if kind == "weekly"
      return weekly
    else
      return monthly
    end
  end

  def self.weekly

  end

  def self.monthly

  end

end
