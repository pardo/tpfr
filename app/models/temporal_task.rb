class TemporalTask < Task
  validates :state, inclusion: { in: %w(done not_done expired) }
  validates :start_date, :end_date, presence: true
  validates :progress_state, absence: true

  validate :valid_date_range_required

  def expired?
    if end_date < Date.today and state != "expired"
      self.state = "expired"
      self.save
    end
    self.state == "expired"
  end

  def valid_date_range_required
    if (start_date && end_date) && (end_date < start_date)
      errors.add(:end_date, "must be later than Start date")
    end
  end
end